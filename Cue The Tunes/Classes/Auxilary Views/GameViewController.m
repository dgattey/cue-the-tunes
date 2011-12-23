//
//  GameViewController.m
//  Cue The Tunes
//
//  Created by Dylan Gattey on 6/8/11.
//  Copyright (c) 2011 Gattey/Azinger. All rights reserved.
//  http://dylangattey.com
//
//  Redistribution and use in binary and source forms, with or without modification,
//  are permitted for any project, commercial or otherwise, provided that the
//  following conditions are met:
//  
//  Redistributions in binary form should display the copyright notice in the About
//  view, website, and/or documentation if possible.
//  
//  Redistributions of source code must retain the copyright notice, this list of
//  conditions, and the following disclaimer.
//
//  THIS SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
//  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
//  PARTICULAR PURPOSE AND NONINFRINGEMENT OF THIRD PARTY RIGHTS. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THIS SOFTWARE.
//

#import "GameViewController.h"
#import "MainViewController.h"

@implementation GameViewController

@synthesize titleLabelGame= _titleLabelGame,
        backgroundView = _backgroundView,
        nextQuestionButton = _nextQuestionButton,
        nextQuestionLabel = _nextQuestionLabel,
        chooseSongButton = _chooseSongButton,
        chooseSongLabel = _chooseSongLabel,
        backButton = _backButton,
        backButtonLabel = _backButtonLabel,
        optionsButton = _optionsButton,
        optionsButtonLabel = _optionsButtonLabel,
        questionsLeft = _questionsLeft,
        questionLabel = _questionLabel,
        musicNotes = _musicNotes,
        optionsTopBarBackground = _optionsTopBarBackground,
        optionsOverlay = _optionsOverlay,
        optionsView = _optionsView,
        optionsAccelerometerSwitch = _optionsAccelerometerSwitch,
        optionsVibrationSwitch = _optionsVibrationSwitch,
        optionItemAccelerometer = _optionItemAccelerometer,
        optionItemVibration = _optionItemVibration,
        questionArray = _questionArray,
        musicPlayer = _musicPlayer,
        musicCollection = _musicCollection,
        mediaItem = _mediaItem;

#pragma mark - View lifecycle

- (void)viewDidLoad {   
    //Set audio session active
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    //Reset options
    [DGOptionsDropdown resetOptions];
    
    //Options views setup
    self.optionsOverlay = [[UIView alloc] initWithFrame:CGRectZero];
    self.optionsView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [DGOptionsDropdown setupOptionsViewsWithAnchorView:self.optionsTopBarBackground overlay:self.optionsOverlay optionView:self.optionsView backgroundImage:[UIImage imageNamed:@"OptionsBackground"]];
    
    //Add accelerometer item
    self.optionsAccelerometerSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    [self.optionsAccelerometerSwitch addTarget:self action:@selector(optionsToggledAccelerometer:) forControlEvents:UIControlEventValueChanged];
    self.optionItemAccelerometer = [[DGOptionItem alloc] initOptionWithTitle:@"Accelerometer" withDetail:@"Shake device for next prompt" withSwitch:self.optionsAccelerometerSwitch];
    [DGOptionsDropdown addOptionItem:self.optionItemAccelerometer toView:self.optionsView];
    
    //Add Vibrate
    self.optionsVibrationSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    [self.optionsVibrationSwitch addTarget:self action:@selector(optionsToggledVibration:) forControlEvents:UIControlEventValueChanged];
    self.optionItemVibration = [[DGOptionItem alloc] initOptionWithTitle:@"Vibration" withDetail:@"Next question vibrates device" withSwitch:self.optionsVibrationSwitch];
    [DGOptionsDropdown addOptionItem:self.optionItemVibration toView:self.optionsView];
    
    //Make the music player real
    self.musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    [self registerForNotifications];
    
    //If the user indicated they wanted to continue the game, load the remaining questions
    if ([prefs boolForKey:@"CONTINUE_GAME"]) {
        [prefs setBool:NO forKey:@"NEW_GAME"];
        self.questionLabel.text = [prefs  valueForKey:@"CURRENT_QUESTION"];
        
        //Get the file and set self.questionArray to its contents
        NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [docPaths objectAtIndex:0];
        NSString *docPath = [documentsDirectory stringByAppendingPathComponent:@"RemainingQuestions.plist"];
        self.questionArray = [[NSMutableArray alloc] initWithContentsOfFile:docPath];
        
        numQuestions = [self.questionArray count];
        
        //Get total number of questions and save it
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Questions" ofType:@"plist"];
        NSArray *tempArray =  [NSArray arrayWithContentsOfFile:path];
        [prefs setInteger:[tempArray count] forKey:@"TOTAL_NUMBER_QUESTIONS"];
        
        //Refresh the question number label
        [self refreshQuestionNumberLabel];
        
        //Set bool to no for continue game or not
        [prefs setBool:NO forKey:@"CONTINUE_GAME"];
    }
    
    //Or, if starting from scratch, load 'Questions.plist' from the bundle and display a question
    if ([prefs boolForKey:@"NEW_GAME"]) {
        [prefs setBool:NO forKey:@"CONTINUE_GAME"];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Questions" ofType:@"plist"];
        NSArray *array =  [NSArray arrayWithContentsOfFile:path];
        self.questionArray = [[NSMutableArray alloc] initWithArray:array];
        numQuestions = [self.questionArray count];
        [self updateQuestionText:self];
        
        //Fade out current song
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        [self.musicPlayer stop];
        
        //Save total number of questions
        [prefs setInteger:[array count] forKey:@"TOTAL_NUMBER_QUESTIONS"];
        
        //Refresh the question number label
        [self refreshQuestionNumberLabel];
        [prefs setBool:NO forKey:@"NEW_GAME"];
    }
    
    //Sets FXLabel styles
    for (FXLabel *label in [self.view allSubviews]) {
        if ([label isKindOfClass:[FXLabel class]]) {
            if (label.tag == 0) {
                //Question label + buttons
                setDefaultStyleUsingLabel(label);
                [label setFont:interstateBold(13.5)];
            }
            if (label.tag == 1) {
                //Title buttons
                setTitleButtonStyleUsingLabel(label);
            }
            if (label.tag == 2) {
                //TItle label
                setTitleStyleUsingLabel(label);
            }
            if (label.tag == 3) {
                //Questions left
                [label setFont:interstateRegular(16)];
                [label setTextColor:customGrayColor];
                setDefaultShadowWithLabel(label)
            }
        }
    }    
    [self.questionLabel setFont:interstateRegular(21)];
    
    if (self.musicPlayer.playbackState == MPMusicPlaybackStatePlaying || self.musicPlayer.playbackState == MPMusicPlaybackStatePaused) {
        self.optionsButtonLabel.text = @"Playing";
    }
    else {
        self.optionsButtonLabel.text = @"Options";
    }
    
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {    
    [DGOptionsDropdown refreshOptionView:self.optionsView withOptionItem:self.optionItemAccelerometer withOverlay:self.optionsOverlay];
    [DGOptionsDropdown refreshOptionView:self.optionsView withOptionItem:self.optionItemVibration withOverlay:self.optionsOverlay];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [UIView animateWithDuration:0.4 animations:^{
        self.musicNotes.alpha = 1.0;
    }];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [UIView animateWithDuration:0.2 animations:^{
        self.musicNotes.alpha = 1.0;
    }];
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {  
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/* ------------------------------------ */
   # pragma mark - Accelerometer
/* ------------------------------------ */
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	/* ------------------------------------------------------
     *  Helper method to go to the next question for a shake
     *  ------------------------------------------------------ */
    if (event.type == UIEventSubtypeMotionShake && [prefs boolForKey:@"OPTION_ACCELEROMETER"]) {
        [self performSelector:@selector(showNextQuestion:) withObject:nil];
	}
}


#pragma mark - View Actions

- (IBAction)doneGameView:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Options

- (IBAction)showOptionsViewFromGameView:(id)sender {
    if (self.musicPlayer.playbackState == MPMusicPlaybackStatePlaying || self.musicPlayer.playbackState == MPMusicPlaybackStatePaused) {
        
        //Show the now playing view controller
        [self showNowPlayingViewController:self];
    }
    else {
        //Show the options dropdown
        NSArray *array = [[NSArray alloc] initWithObjects:self.backButton, self.backButtonLabel, nil];
        [DGOptionsDropdown 
         slideOptionsWithDuration:0.3
         viewController:self 
         anchorView:self.optionsTopBarBackground
         theOptionsView:self.optionsView
         overlay:self.optionsOverlay
         backgroundImage:[UIImage imageNamed:@"OptionsBackground"]
         overlayAmount:0.6
         optionsButton:self.optionsButton
         viewsToHide:array];
        
        //Tap gesture recognizers so that anywhere onscreen minus the options view itself will close the options view
        UITapGestureRecognizer *overlayTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(overlayTapped:)];
        UITapGestureRecognizer *topBarTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(overlayTapped:)];
        
        if ([prefs boolForKey:@"OPTIONS_HIDDEN"]) {
            [self.optionsOverlay removeGestureRecognizer:overlayTapGestureRecognizer];
            self.optionsTopBarBackground.userInteractionEnabled = NO;
            [self.optionsTopBarBackground removeGestureRecognizer:topBarTapGestureRecognizer];
            [self.optionsButtonLabel setText:@"Options"];
        }
        else {
            [self.optionsOverlay addGestureRecognizer:overlayTapGestureRecognizer];
            self.optionsTopBarBackground.userInteractionEnabled = YES;
            [self.optionsTopBarBackground addGestureRecognizer:topBarTapGestureRecognizer];
            [self.optionsButtonLabel setText:@"Done"];
        }
    }
}

- (void)optionsToggledAccelerometer:(id)sender {
    [DGOptionsDropdown optionsToggledWithSwitch:self.optionsAccelerometerSwitch withTitle:@"Accelerometer"];
}

- (void)optionsToggledVibration:(id)sender {
    [DGOptionsDropdown optionsToggledWithSwitch:self.optionsVibrationSwitch withTitle:@"Vibration"];
}

- (void)overlayTapped:(id)sender {
    [self showOptionsViewFromGameView:self];
}

#pragma mark - Music Actions

- (IBAction)chooseSong:(id)sender {    
    [self.musicPlayer stop];
    
    MPMediaPickerController *picker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
    [picker setDelegate:self];
    [self presentModalViewController:picker animated:YES];
}

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)collection {
    [self dismissModalViewControllerAnimated:NO];
    
    //Set the music collection to be the just picked song, queue it up, and play it
    self.musicCollection = collection;
    [self.musicPlayer setQueueWithItemCollection:self.musicCollection];
    [self.musicPlayer play];
    
    //Present a musicPlayerViewController & update the options button to show now playing
    [self showNowPlayingViewController:self];
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    [self dismissModalViewControllerAnimated: YES];
}
         
- (void)showNowPlayingViewController:(id)sender {
    MusicPlayerViewController *playerController = [[MusicPlayerViewController alloc] init];
    [playerController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentModalViewController:playerController animated:YES];
}

# pragma mark - Media Playback info

- (void)handle_PlaybackStateChanged:(id)notification {
    if (self.musicPlayer.playbackState == MPMusicPlaybackStatePlaying || self.musicPlayer.playbackState == MPMusicPlaybackStatePaused) {
        self.optionsButtonLabel.text = @"Playing";
    }
    else {
        self.optionsButtonLabel.text = @"Options";
    }
}

- (void)registerForNotifications {
    // Register for music player notifications
    [self.musicPlayer beginGeneratingPlaybackNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handle_PlaybackStateChanged:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:self.musicPlayer];
}

- (void)unregisterForNotifications {
    [self.musicPlayer endGeneratingPlaybackNotifications];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:self.musicPlayer];
}


#pragma mark - Questions

- (IBAction)showNextQuestion:(id)sender {    
    if ([prefs boolForKey:@"OPTION_VIBRATION"]) {
        AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    }
    
    //Refresh the question number label
    [self refreshQuestionNumberLabel];
    
    //Stop the music
    [self.musicPlayer stop];
    
    //If there are no questions, reload Questions.plist and update the text
    if (numQuestions == 0) {
        self.questionArray = nil;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Questions" ofType:@"plist"];
        NSArray *array =  [NSArray arrayWithContentsOfFile:path];
        self.questionArray = [[NSMutableArray alloc] initWithArray:array];        
        [self updateQuestionText:self];
    }
    
    //Otherwise, update the text only
    else {
        [self updateQuestionText:self];
    }
    
    //Disable for a bit
    [self.nextQuestionButton setEnabled:NO];
    [self resignFirstResponder];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(enableNextQuestionButton:)userInfo:nil repeats:NO];
}

- (void)enableNextQuestionButton:(id)sender {
    [self becomeFirstResponder];
    self.nextQuestionButton.enabled = YES;
}

- (void)refreshQuestionNumberLabel {    
    //By doing this only when it's not zero, you prevent "Question 59 of 58"
    if (![self.questionArray count] == 0) {
        //Sets the number of the question you're on into a string
        NSString *firstNumber = [[NSString alloc] init];
        
        //For continuing or new game, just use the count
        if ([prefs boolForKey:@"CONTINUE_GAME"] || [prefs boolForKey:@"NEW_GAME"]) {
            firstNumber = [NSString stringWithFormat:@"%i", ([prefs integerForKey:@"TOTAL_NUMBER_QUESTIONS"] - [self.questionArray count])];
        }
        
        //If not a continued or new game, add one to make sequential
        if (![prefs boolForKey:@"NEW_GAME"] && ![prefs boolForKey:@"CONTINUE_GAME"]) {
            firstNumber = [NSString stringWithFormat:@"%i", ([prefs integerForKey:@"TOTAL_NUMBER_QUESTIONS"] - [self.questionArray count] + 1)];
        }
        
        //Does the same thing for the total number of questions
        NSString *secondNumber = [NSString stringWithFormat:@"%i",[prefs integerForKey:@"TOTAL_NUMBER_QUESTIONS"]];
        
        //Sets the question label to "Question _ of _" with the strings from before
        [self.questionsLeft setText:[@"Question " stringByAppendingString:[firstNumber stringByAppendingString:[@" of " stringByAppendingString:secondNumber]]]]; 
    }
}

- (void)updateQuestionText:(id)sender {
    
    if (numQuestions == 0) {
        self.questionLabel.text = nil;
        self.questionLabel.text = @"No more questions! Start a new game below.";
        self.questionsLeft.text = nil;
        
        [self.nextQuestionLabel setText:@"New Game"];
        [self.chooseSongButton setEnabled:NO];
        self.chooseSongLabel = nil;
        self.chooseSongLabel = [[FXLabel alloc] init];
        self.chooseSongLabel.text = @"Choose Song";
        [self.chooseSongLabel setTextColor:customGrayColor];
        
        numQuestions = [self.questionArray count];
        
        [prefs setValue:nil forKey:@"CURRENT_QUESTION"];
    }
    else {        
        self.questionLabel.text = nil;
        int randNum;
        randNum = arc4random() % (numQuestions);
        self.questionLabel.text = [self.questionArray objectAtIndex:randNum];
        
        [self.nextQuestionLabel setText:@"Next Question"];
        [self.chooseSongButton setEnabled:YES];
        setDefaultStyleUsingLabel(self.chooseSongLabel);
        [self.chooseSongLabel setFont:interstateBold(13.5)];
        
        //Save current question
        [prefs setValue:[self.questionArray objectAtIndex:randNum] forKey:@"CURRENT_QUESTION"];        
        
        [self.questionArray removeObjectAtIndex:randNum];
        numQuestions = [self.questionArray count];
        
        //Save remaining questions to file
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"RemainingQuestions.plist"];
        [self.questionArray writeToFile:path atomically:YES];
    }
}

@end
