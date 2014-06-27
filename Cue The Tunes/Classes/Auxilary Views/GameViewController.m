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
        questionLabel = _questionLabel,
        musicNotes = _musicNotes,
        optionsTopBarBackground = _optionsTopBarBackground,
        questionArray = _questionArray,
        musicPlayer = _musicPlayer;

/* -------------------------------------- */
   # pragma mark - View lifecycle
/* -------------------------------------- */

- (void)viewDidLoad {    
    /* ----------------------------------------------
      *  Make the music player the iPodMusicPlayer
      *  Register for music notifications, etc.
      *  ---------------------------------------------- */
    self.musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    [self registerForNotifications];
    
    /* -----------------------------------------------------
      *  If the game should be continued:
      *  Set the current question from prefs
      *  Fill the question array with the RemainingQuestions file
      *  Count the number of questions and set bools to no
      *  ----------------------------------------------------- */
    if ([prefs boolForKey:@"CONTINUE_GAME"]) {
        self.questionLabel.text = [prefs  valueForKey:@"CURRENT_QUESTION"];
        self.questionArray = [[NSMutableArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"RemainingQuestions.plist"]];
        numQuestions = [self.questionArray count];
        [prefs setBool:NO forKey:@"CONTINUE_GAME"];
        [prefs setBool:NO forKey:@"NEW_GAME"];
    }
    
    /* --------------------------------------------------
      *  Or, if starting a new game:
      *  Fill the question array with the Questions file
      *  Update the question text with a random one
      *  Count the number of questions and set bools to no
      *  Fade out the currently playing media
      *  -------------------------------------------------- */
    if ([prefs boolForKey:@"NEW_GAME"]) {
        self.questionArray = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Questions" ofType:@"plist"]]];
        numQuestions = [self.questionArray count];
        [self updateQuestionText:self];
        [prefs setBool:NO forKey:@"CONTINUE_GAME"];
        [prefs setBool:NO forKey:@"NEW_GAME"];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        [self.musicPlayer stop];
    }
    
    /* ----------------------------------------------
      *  Set FXLabel styles based on label's tag
      *  ---------------------------------------------- */
    for (FXLabel *label in [self.view allSubviews]) {
        if ([label isKindOfClass:[FXLabel class]]) {
            if (label.tag == 0) {
                /* ------------------------------------
                       *  Question label as well as the buttons
                       *  ------------------------------------ */
                setDefaultStyleUsingLabel(label);
                [label setFont:interstateBold(13.5)];
            }
            if (label.tag == 1) {
                /* --------------
                       *  Title buttons
                       *  -------------- */
                setTitleButtonStyleUsingLabel(label);
            }
            if (label.tag == 2) {
                /* ------------
                       *  Title label
                       *  ------------ */
                setTitleStyleUsingLabel(label);
            }
        }
    }
    
    /* -----------------------------------------------
      *  Set the question label's style just based on font
      *  ----------------------------------------------- */
    [self.questionLabel setFont:interstateRegular(21)];
    
    /* --------------------------------------------------
      *  Based on playback state, set the option button text
      *  -------------------------------------------------- */
    if (self.musicPlayer.playbackState == MPMusicPlaybackStateStopped || self.musicPlayer.playbackState == MPMusicPlaybackStateInterrupted) {
        self.optionsButtonLabel.text = @"Options";
    }
    else if (self.musicPlayer.playbackState == MPMusicPlaybackStatePlaying || self.musicPlayer.playbackState == MPMusicPlaybackStatePaused) {
        self.optionsButtonLabel.text = @"Playing";
    }
    
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {    
    /* -------------------------------------------------
      *  Call the global instance to refresh the options view
      *  Set all properties for the options instance too
      *  ------------------------------------------------- */
    [[DGOptionsDropdown sharedInstance] refreshOptionsView];
    [[DGOptionsDropdown sharedInstance] setAnchor:self.optionsTopBarBackground];
    [[DGOptionsDropdown sharedInstance] setOptionsButton:self.optionsButton];
    [[DGOptionsDropdown sharedInstance] setOptionsButtonLabel:self.optionsButtonLabel];
    [[DGOptionsDropdown sharedInstance] setViewsToHide:[[NSArray alloc] initWithObjects:self.backButton, self.backButtonLabel, nil]];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    /* ----------------------------------------------
      *  Fade in the corner music notes
      *  ---------------------------------------------- */
    [UIView animateWithDuration:0.4 animations:^{
        self.musicNotes.alpha = 1.0;
    }];
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {    
    /* ----------------------------------------------
      *  Fade out the corner music notes
      *  ---------------------------------------------- */
    [UIView animateWithDuration:0.2 animations:^{
        self.musicNotes.alpha = 1.0;
    }];
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    /* ----------------------------------------------
      *  Only allow rotation to portrait orientation
      *  ---------------------------------------------- */
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/* ------------------------------------ */
   # pragma mark - Accelerometer
/* ------------------------------------ */
- (BOOL)canBecomeFirstResponder {
    /* ----------------------------------------------
      *  Allow accelerometer to return results
      *  ---------------------------------------------- */
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	/* ------------------------------------------------------------------
      *  For a shake with the accelerometer enabled, show the next question
      *  ------------------------------------------------------------------ */
    if (event.type == UIEventSubtypeMotionShake && [prefs boolForKey:@"OPTION_ACCELEROMETER"]) {
        [self showNextQuestion:nil];
	}
}

/* --------------------------------------- */
   # pragma mark - Hiding/showing views
/* --------------------------------------- */

- (IBAction)doneGameView:(id)sender {
    /* ----------------------------------------------
      *  For a tap on the back button, pop to main menu
      *  ---------------------------------------------- */
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)showNowPlayingViewController:(id)sender {
    /* --------------------------------------------------------------
      *  Create a musicPlayerController and present it modally with a flip
      *  -------------------------------------------------------------- */
    MusicPlayerViewController *playerController = [[MusicPlayerViewController alloc] init];
    [playerController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentModalViewController:playerController animated:YES];
}

- (IBAction)showOptionsViewFromGameView:(id)sender {
    /* ---------------------------------------------------------------------
      *  Based on playback state, show the options view or the music controller
      *  --------------------------------------------------------------------- */
    if (self.musicPlayer.playbackState == MPMusicPlaybackStateInterrupted || self.musicPlayer.playbackState == MPMusicPlaybackStateStopped) {
        /* -----------------------------------------------
            *  If stopped or interrupted, slide down the options
            *  ----------------------------------------------- */
        [[DGOptionsDropdown sharedInstance] slideOptionsWithDuration:0.3];
    }
    else if (self.musicPlayer.playbackState == MPMusicPlaybackStatePlaying || self.musicPlayer.playbackState == MPMusicPlaybackStatePaused) {
        /* ----------------------------------------------------
            *  Otherwise, if paused or playing, show the music view
            *  ---------------------------------------------------- */
        [self showNowPlayingViewController:self];
    }
}

/* --------------------------------------------- */
   # pragma mark - Music and playback methods
/* --------------------------------------------- */

- (IBAction)chooseSong:(id)sender {    
    /* ----------------------------------------------------------
      *  When choosing a song, stop the music and present a picker
      *  ---------------------------------------------------------- */
    [self.musicPlayer stop];
    MPMediaPickerController *picker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
    [picker setDelegate:self];
    [self presentModalViewController:picker animated:YES];
}

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)collection {
    [self dismissModalViewControllerAnimated:NO];
    /* --------------------------------------------------------
      *  When media items have been picked:
      *  Queue the music player to the just picked song and play it
      *  Present the music player controller
      *  -------------------------------------------------------- */
    [self.musicPlayer setQueueWithItemCollection:collection];
    [self.musicPlayer play];
    [self showNowPlayingViewController:self];
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    /* ----------------------------------------------
      *  Hide the media picker view
      *  ---------------------------------------------- */
    [self dismissModalViewControllerAnimated:YES];
}

- (void)handle_PlaybackStateChanged:(id)notification {
    /* ----------------------------------------------------------------
      *  Based on the changed playback state, set the options button text
      *  ---------------------------------------------------------------- */
    if (self.musicPlayer.playbackState == MPMusicPlaybackStatePlaying || self.musicPlayer.playbackState == MPMusicPlaybackStatePaused) {
        self.optionsButtonLabel.text = @"Playing";
    }
    else {
        self.optionsButtonLabel.text = @"Options";
    }
}

- (void)registerForNotifications {
    /* ----------------------------------------------------
      *  Register for music player notifications & add observer
      *  ---------------------------------------------------- */
    [self.musicPlayer beginGeneratingPlaybackNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handle_PlaybackStateChanged:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:self.musicPlayer];
}

- (void)unregisterForNotifications {
    /* -----------------------------------------------------------
      *  Unregister for music player notifications & remove observer
      *  ----------------------------------------------------------- */
    [self.musicPlayer endGeneratingPlaybackNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:self.musicPlayer];
}

/* ------------------------------------ */
   # pragma mark - Questions
/* ------------------------------------ */

- (IBAction)showNextQuestion:(id)sender {    
    /* ----------------------------------------------
      *  For when the next question button is tapped
      *  Vibrate device if that preference is enabled
      *  ---------------------------------------------- */
    if ([prefs boolForKey:@"OPTION_VIBRATION"]) {
        AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    }
    
    /* ------------------------------------------------------------------
      *  Stop the music and if no questions, reload them and update the text
      *  ------------------------------------------------------------------ */
    [self.musicPlayer stop];
    if (numQuestions == 0) {
        self.questionArray = nil;
        self.questionArray = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Questions" ofType:@"plist"]]];        
        [self updateQuestionText:self];
    }
    
    /* -------------------------------------------------
      *  If there are still questions left, just update the text
      *  ------------------------------------------------- */
    else if (numQuestions > 0) {
        [self updateQuestionText:self];
    }
    
    /* ----------------------------------------------
      *  Disable the next question button for 0.5 secs
      *  ---------------------------------------------- */
    [self.nextQuestionButton setEnabled:NO];
    [self resignFirstResponder];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(enableNextQuestionButton:)userInfo:nil repeats:NO];
}

- (void)enableNextQuestionButton:(id)sender {
    /* ----------------------------------------------
      *  Enable the next question button
      *  ---------------------------------------------- */
    [self becomeFirstResponder];
    self.nextQuestionButton.enabled = YES;
}

- (void)updateQuestionText:(id)sender {
    /* -------------------------------------------------------------------
      *  Method to update the question text
      *  If no questions left, recount number of questions/nil current question
      *  ------------------------------------------------------------------- */
    if (numQuestions == 0) {
        numQuestions = [self.questionArray count];
        [prefs setValue:nil forKey:@"CURRENT_QUESTION"];
    }
    
    /* ----------------------------------------------------------------
      *  Remove the current text
      *  Take a question at a random index and make it the new question
      *  Enable the choose song button
      *  ---------------------------------------------------------------- */
    self.questionLabel.text = nil;
    int randNum = arc4random() % (numQuestions);
    self.questionLabel.text = [self.questionArray objectAtIndex:randNum];
    [self.chooseSongButton setEnabled:YES];
    
    /* -----------------------------------------------------------
      *  Save the random question to prefs for use later
      *  Remove it from the question array and recount the questions
      *  Save the remaining questions to a plist for later loading
      *  ----------------------------------------------------------- */
    [prefs setValue:[self.questionArray objectAtIndex:randNum] forKey:@"CURRENT_QUESTION"];        
    [self.questionArray removeObjectAtIndex:randNum];
    numQuestions = [self.questionArray count];
    [self.questionArray writeToFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"RemainingQuestions.plist"] atomically:YES];
}

@end
