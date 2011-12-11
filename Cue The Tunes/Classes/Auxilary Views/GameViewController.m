//
//  GameViewController.m
//  Cue The Tunes
//
//  Created by Dylan Gattey on 6/8/11.
//  Copyright 2011 Gattey/Azinger. All rights reserved.
//

#import "GameViewController.h"
#import "MainViewController.h"
#import "OptionsViewController.h"

@implementation GameViewController

@synthesize backgroundView = _backgroundView,
        playBarView = _playBarView,
        currentlyPlayingArtworkView = _currentlyPlayingArtworkView,
        currentlyPlayingArtworkImage = _currentlyPlayingArtworkImage,
        currentlyPlayingTitle = _currentlyPlayingTitle,
        currentlyPlayingArtist = _currentlyPlayingArtist,
        currentlyPlayingAlbum = _currentlyPlayingAlbum,
        currentlyPlayingTimeSlider = _currentlyPlayingTimeSlider,
        airPlayButtonView = _airPlayButtonView;
@synthesize playPauseButton = _playPauseButton,
        nextQuestionButton = _nextQuestionButton,
        chooseSongButton = _chooseSongButton,
        questionLabel = _questionLabel,
        backButton = _backButton,
        titleLabelGame= _titleLabelGame,
        optionsButton = _optionsButton,
        questionsLeft = _questionsLeft;
@synthesize optionsTopBarBackground = _optionsTopBarBackground,
        optionsOverlay = _optionsOverlay,
        optionsView = _optionsView,
        optionsAccelerometerSwitch = _optionsAccelerometerSwitch,
        optionsVibrationSwitch = _optionsVibrationSwitch,
        optionItemAccelerometer = _optionItemAccelerometer,
        optionItemVibration = _optionItemVibration;
@synthesize currentlyPlayingTimeRemainingLabel = _currentlyPlayingTimeRemainingLabel, 
        currentlyPlayingTimeElapsedLabel = _currentlyPlayingTimeElapsedLabel,
        minutesString = _minutesString,
        secondsString = _secondsString,
        artworkTapGestureRecognizer = _artworkTapGestureRecognizer,
        backgroundTapGestureRecognizer = _backgroundTapGestureRecognizer;
@synthesize questionArray = _questionArray,
        musicPlayer = _musicPlayer,
        musicCollection = _musicCollection,
        mediaItem = _mediaItem;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{        
    //Reset music player
    [self resetMusicPlayer];
    
    //Moves down the play bar
    [self slidePlayBarWithDuration:0.01 inDirection:@"down"];
    
    //Add tap gesture recognizer to background, but set user interaction to no
    self.backgroundTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(artworkTapped:)];
    [self.backgroundView addGestureRecognizer:self.backgroundTapGestureRecognizer];
    [self.backgroundView setUserInteractionEnabled:NO];
    
    //Add tap gesture recognizer to artwork, but set user interaction to no
    self.artworkTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(artworkTapped:)];
    [self.currentlyPlayingArtworkView addGestureRecognizer:self.artworkTapGestureRecognizer];
    [self.currentlyPlayingArtworkView setUserInteractionEnabled:NO];
    
    //Register for notifications
    [self registerForMediaPlayerNotifications];
    
    //Library changed stuff
    libraryChanged = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(libraryChangedAction:) name:MPMediaLibraryDidChangeNotification object:self.musicPlayer];
    
    //Set the MPVolumeView to show only the AirPlay button (Route button) and set to my own larger image
    [self.airPlayButtonView setShowsRouteButton:YES];
    [self.airPlayButtonView setShowsVolumeSlider:NO];
    for (UIButton *button in self.airPlayButtonView.subviews) { //Sizes the button to fit
        if ([button isKindOfClass:[UIButton class]]) {
            [button setImage:[UIImage imageNamed:@"AirPlayIconButton"] forState:UIControlStateNormal];
        }
    }
    
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
        
        //Show song info, etc if playing
        #ifdef TARGET_OS_IPHONE
        self.musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
        if (self.musicPlayer.playbackState == MPMusicPlaybackStatePlaying || self.musicPlayer.playbackState == MPMusicPlaybackStatePaused) {
            //Setup the info & display
            [self setupSongInfo];
            [self displaySongInfoWithDuration:0.01];
            
            //Allows the user to show/hide the artwork view
            [self.currentlyPlayingArtworkView setUserInteractionEnabled:YES];
            [self.backgroundView setUserInteractionEnabled:YES];
            
            //Show the correct button
            if (self.musicPlayer.playbackState == MPMusicPlaybackStatePaused) {
                [self setPlayPauseButtonImage:@"Play" enabled:YES];
            }
            
            if (self.musicPlayer.playbackState == MPMusicPlaybackStatePlaying) {
                [self setPlayPauseButtonImage:@"Pause" enabled:YES];
            }
            
            //Time
            [self updateSliderTime:nil];
        }
        #endif
        
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
        
        //Save total number of questions
        [prefs setInteger:[array count] forKey:@"TOTAL_NUMBER_QUESTIONS"];
        
        //Refresh the question number label
        [self refreshQuestionNumberLabel];
        [prefs setBool:NO forKey:@"NEW_GAME"];
    }
    
    //Sets Gotham as custom font for all labels
    [self.titleLabelGame setFont:gothamMedium20];
    [self.questionsLeft setFont:gothamMedium15];
    [self.questionLabel setFont:gothamMedium20];
    
    //Set default styles for AutoScroll title label
    [self.currentlyPlayingTitle setFont:gothamBold15];
    self.currentlyPlayingTitle.bufferSpaceBetweenLabels = 24.0;
    self.currentlyPlayingTitle.scrollSpeed = 19;
    self.currentlyPlayingTitle.pauseInterval = 3;
    self.currentlyPlayingTitle.textColor = [UIColor whiteColor];
    self.currentlyPlayingTitle.text = [self.musicPlayer.nowPlayingItem valueForKey:MPMediaItemPropertyTitle];
    
    //And artist label
    [self.currentlyPlayingArtist setFont:gothamMedium12];
    self.currentlyPlayingArtist.bufferSpaceBetweenLabels = 24.0;
    self.currentlyPlayingArtist.scrollSpeed = 25;
    self.currentlyPlayingArtist.pauseInterval = 3;
    self.currentlyPlayingArtist.textColor = [UIColor whiteColor];
    self.currentlyPlayingArtist.text = [self.musicPlayer.nowPlayingItem valueForKey:MPMediaItemPropertyArtist];
    
    //And album label
    [self.currentlyPlayingAlbum setFont:gothamMedium12];
    self.currentlyPlayingAlbum.bufferSpaceBetweenLabels = 24.0;
    self.currentlyPlayingAlbum.scrollSpeed = 23;
    self.currentlyPlayingAlbum.pauseInterval = 3;
    self.currentlyPlayingAlbum.textColor = [UIColor whiteColor];
    self.currentlyPlayingAlbum.text = [self.musicPlayer.nowPlayingItem valueForKey:MPMediaItemPropertyAlbumTitle];
    
    //Set up reflection using custom ReflectionView
    [self.currentlyPlayingArtworkView setDynamic:YES];
    [self.currentlyPlayingArtworkView setOpaque:YES];
    [self.currentlyPlayingArtworkView setExclusiveTouch:YES];
    [self.currentlyPlayingArtworkView setReflectionAlpha:0.25];
    [self.currentlyPlayingArtworkView setReflectionGap:3];
    [self.currentlyPlayingArtworkView setReflectionScale:0.28];
    
    //Set default image
    [self.currentlyPlayingArtworkImage setImage:[UIImage imageNamed:@"NoArtworkImage"]];
    
    //Setup images for UISlider (for song progress)
    [self.currentlyPlayingTimeSlider setThumbImage: [UIImage imageNamed:@"SliderThumb"] forState:UIControlStateNormal];
    [self.currentlyPlayingTimeSlider setMinimumTrackImage:[[UIImage imageNamed:@"SliderBlueTrack"] stretchableImageWithLeftCapWidth:3.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [self.currentlyPlayingTimeSlider setMaximumTrackImage:[[UIImage imageNamed:@"SliderWhiteTrack"] stretchableImageWithLeftCapWidth:3.0 topCapHeight:0.0] forState:UIControlStateNormal];
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:0.5];
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
	[self becomeFirstResponder];
    
    [DGOptionsDropdown refreshOptionView:self.optionsView withOptionItem:self.optionItemAccelerometer withOverlay:self.optionsOverlay];
    [DGOptionsDropdown refreshOptionView:self.optionsView withOptionItem:self.optionItemVibration withOverlay:self.optionsOverlay];
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
	[self resignFirstResponder];    
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{    
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - View Actions

- (IBAction)doneGameView:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"TITLE_NEEDS_ANIMATION"];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Options

- (IBAction)showOptionsViewFromGameView:(id)sender
{
    self.currentlyPlayingArtworkView.dynamic = NO;
    [DGOptionsDropdown 
        slideOptionsWithDuration:0.3
        viewController:self 
        anchorView:self.optionsTopBarBackground
        theOptionsView:self.optionsView
        overlay:self.optionsOverlay
        backgroundImage:[UIImage imageNamed:@"OptionsBackground"]
        overlayAmount:0.6
        optionsButton:self.optionsButton
        backButton:self.backButton];
    
    //Tap gesture recognizers so that anywhere onscreen minus the options view itself will close the options view
    UITapGestureRecognizer *overlayTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(overlayTapped:)];
    UITapGestureRecognizer *topBarTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(overlayTapped:)];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"OPTIONS_HIDDEN"]) {
        [self.optionsOverlay addGestureRecognizer:overlayTapGestureRecognizer];
        self.optionsTopBarBackground.userInteractionEnabled = YES;
        [self.optionsTopBarBackground addGestureRecognizer:topBarTapGestureRecognizer];
    }
    else {
        [self.optionsOverlay removeGestureRecognizer:overlayTapGestureRecognizer];
        self.optionsTopBarBackground.userInteractionEnabled = NO;
        [self.optionsTopBarBackground removeGestureRecognizer:topBarTapGestureRecognizer];
    }

}

- (void)optionsToggledAccelerometer:(id)sender
{
    [DGOptionsDropdown optionsToggledWithSwitch:self.optionsAccelerometerSwitch withTitle:@"Accelerometer"];
}

- (void)optionsToggledVibration:(id)sender
{
    [DGOptionsDropdown optionsToggledWithSwitch:self.optionsVibrationSwitch withTitle:@"Vibration"];
}

- (void)overlayTapped:(id)sender
{
    [self showOptionsViewFromGameView:self];
}

#pragma mark - Music Actions

- (IBAction)chooseSong:(id)sender
{    
    //If there's artwork showing, hide it first
    if (self.currentlyPlayingArtworkView.alpha == 1) {
        [self artworkTapped:self];
    }
    
    //Otherwise, stop the music and show the modal picker view
    else {
        [self.musicPlayer stop];
        
        if (libraryChanged == NO) {
            MPMediaPickerController *picker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
            [picker setDelegate:self];                       
            [self presentModalViewController:picker animated:YES];
        }
        if (libraryChanged == YES) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Syncing" message:@"It appears your device is currently syncing, or has just finished. This could cause issues with songs being unavailable. Please return to the main menu and try again." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Ignore", @"Menu", nil];
            [alert show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //If it was the ignore button
    if (buttonIndex == 1) {
        libraryChanged = NO;
        [self chooseSong:self];
        libraryChanged = YES;
    }
    
    //If it was the menu button
    if (buttonIndex == 2) {
        [self doneGameView:self];
    }
}

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)collection {
    [self dismissModalViewControllerAnimated: YES];
    [self updatePlayerQueueWithCollection:collection];
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    [self dismissModalViewControllerAnimated: YES];
}

- (void)updatePlayerQueueWithCollection:(MPMediaItemCollection*)collection {
    
    //Set its collection and load it into the queue
    self.musicCollection = collection;
    [self.musicPlayer setQueueWithItemCollection:self.musicCollection];
    
    //Register for media notifications
    [self registerForMediaPlayerNotifications];
    
    //Play it
    [self.musicPlayer play];
    
    //Set timer to repeat the update every minute
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(updateSliderTime:) userInfo:nil repeats:NO];
    
    //Enable artwork and background tap gesture recognizers
    [self.currentlyPlayingArtworkView setUserInteractionEnabled:YES];
    [self.backgroundView setUserInteractionEnabled:YES];
    
    //Setup the song info & display
    [self setupSongInfo];
    [self displaySongInfoWithDuration:0.01];
}

- (IBAction)playPauseMusic:(id)sender
{
    if (self.musicPlayer.playbackState == MPMusicPlaybackStatePlaying) {
        [self.musicPlayer pause];
        [self setPlayPauseButtonImage:@"Play"enabled:YES];
    }
    if (self.musicPlayer.playbackState == MPMusicPlaybackStatePaused) {
        [self.musicPlayer play];
        [self setPlayPauseButtonImage:@"Pause" enabled:YES];
    }
}

- (void)artworkTapped:(id)sender
{
    if (self.currentlyPlayingArtworkView.alpha == 1) {
        [UIView animateWithDuration:0.3 animations:^ {
            [self.currentlyPlayingArtworkView setAlpha:0];
        }];
        return;
    }
    
    if (self.currentlyPlayingArtworkView.alpha == 0) {
        [UIView animateWithDuration:0.3 animations:^ {
            [self.currentlyPlayingArtworkView setAlpha:1];
        }];
        return;
    }
}

- (void)libraryChangedAction:(id)sender
{
    if (libraryChanged == NO) {
        libraryChanged = YES;
    }
    if (libraryChanged == YES) {
        libraryChanged = NO;
    }
}

#pragma mark - Slider
- (IBAction)sliderChanged:(id)sender {
    //Convert the current time into the minutes and seconds strings and set them as the time elapsed
    [self convertTime:self.musicPlayer.currentPlaybackTime];
    self.currentlyPlayingTimeElapsedLabel.text = [[self.minutesString stringByAppendingString:@":"] stringByAppendingString:self.secondsString];
    
    //Same thing for remaining
    NSNumber *currentlyPlayingTimeTotal = [self.musicPlayer.nowPlayingItem valueForKey:MPMediaItemPropertyPlaybackDuration];
    [self convertTime:(currentlyPlayingTimeTotal.integerValue - self.musicPlayer.currentPlaybackTime)];
    self.currentlyPlayingTimeRemainingLabel.text = [[[@"-" stringByAppendingString:self.minutesString] stringByAppendingString:@":"] stringByAppendingString:self.secondsString];
    
    //Set playback time based on value
    [self.musicPlayer setCurrentPlaybackTime:[NSNumber numberWithFloat:self.currentlyPlayingTimeSlider.value].doubleValue];
}

- (void)updateSliderTime:(NSTimer *)timer {
    //Convert the current time into the minutes and seconds strings and set them as the time elapsed
    [self convertTime:self.musicPlayer.currentPlaybackTime];
    self.currentlyPlayingTimeElapsedLabel.text = [[self.minutesString stringByAppendingString:@":"] stringByAppendingString:self.secondsString];
    
    //Same thing for remaining
    NSNumber *currentlyPlayingTimeTotal = [self.musicPlayer.nowPlayingItem valueForKey:MPMediaItemPropertyPlaybackDuration];
    [self convertTime:(currentlyPlayingTimeTotal.integerValue - self.musicPlayer.currentPlaybackTime)];
    self.currentlyPlayingTimeRemainingLabel.text = [[[@"-" stringByAppendingString:self.minutesString] stringByAppendingString:@":"] stringByAppendingString:self.secondsString];
    
    //Set value based on playback time
    [self.currentlyPlayingTimeSlider setValue:self.musicPlayer.currentPlaybackTime];
    
    //And reschedule the timer
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(updateSliderTime:) userInfo:nil repeats:NO];
}

- (void)convertTime:(NSTimeInterval )theTimeInterval
{
    //Set amount of time to convert
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:theTimeInterval sinceDate:date1]; 
    
    // Get conversion to months, days, hours, minutes
    unsigned int unitFlags =  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit;
    NSDateComponents *conversionInfo = [sysCalendar components:unitFlags fromDate:date1  toDate:date2  options:0];
    
    //Set new value to minutes string
    self.minutesString = [NSString stringWithFormat:@"%i", conversionInfo.minute];
    
    //Same for seconds, but add a zero in front if the length is 1
    self.secondsString = [NSString stringWithFormat:@"%i", conversionInfo.second];
    if (self.secondsString.length == 1) {
        self.secondsString = [@"0" stringByAppendingString:[NSString stringWithFormat:@"%i", conversionInfo.second]];
    }    
}

#pragma mark - Accelerometer
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
	//If the accelerometer option is set, show the next question if above level, else, nothing
    float accelLevel = 1.6;
    if (acceleration.x >= accelLevel || acceleration.y >= accelLevel || acceleration.z >= accelLevel) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"OPTION_ACCELEROMETER"]) {
            //Dismiss the artwork
            if (self.currentlyPlayingArtworkView.alpha == 1) {
                [self artworkTapped:self];
            }
            
            //Show next question
            [self performSelector:@selector(showNextQuestion:) withObject:nil];
        }

    }
}

#pragma mark - Questions

- (IBAction)showNextQuestion:(id)sender
{
    //If artwork is showing, hide it first
    if (self.currentlyPlayingArtworkView.alpha == 1) {
        [self artworkTapped:self];
    }
    
    //Otherwise, do what the button should do
    else {
        //Vibrate Device if enabled
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"OPTION_VIBRATION"]) {
            AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
        }
        
        //Refresh the question number label
        [self refreshQuestionNumberLabel];
        
        //Stop the music
        [self.musicPlayer stop];
        
        //Disable background and artwork interaction to prevent blank artwork from showing up
        [self.backgroundView setUserInteractionEnabled:NO];
        [self.currentlyPlayingArtworkView setUserInteractionEnabled:NO];
        
        //Slide down the play bar and disable
        [self hideSongInfoWithDuration:0.3];
        
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
        [self.nextQuestionButton setAdjustsImageWhenDisabled:NO];
        [self.nextQuestionButton setEnabled:NO];
        [self resignFirstResponder];
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(enableNextQuestionButton:) userInfo:nil repeats:NO];
    }
}

- (void)enableNextQuestionButton:(id)sender
{
    [self becomeFirstResponder];
    self.nextQuestionButton.enabled = YES;
    [self.nextQuestionButton setAdjustsImageWhenDisabled:YES];
}

- (void)refreshQuestionNumberLabel 
{
    
    
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

- (void)updateQuestionText:(id)sender
{
    
    if (numQuestions == 0) {
        self.questionLabel.text = nil;
        self.questionLabel.text = @"No more questions! Start a new game below.";
        [self.nextQuestionButton setImage:[UIImage imageNamed:@"NewGameButton"] forState:UIControlStateNormal];
        [self.chooseSongButton setEnabled:NO];
        numQuestions = [self.questionArray count];
        
        [prefs setValue:nil forKey:@"CURRENT_QUESTION"];
    }
    else {
        self.questionLabel.text = nil;
        int randNum;
        randNum = arc4random() % (numQuestions);
        self.questionLabel.text = [self.questionArray objectAtIndex:randNum];
        
        [self.nextQuestionButton setImage:[UIImage imageNamed:@"NextQuestionButton"] forState:UIControlStateNormal];
        
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

#pragma mark - Handles

- (void)handle_PlaybackStateChanged:(id)notification
{
    if (self.musicPlayer.playbackState == MPMusicPlaybackStatePlaying) {
        [self setPlayPauseButtonImage:@"Pause" enabled:YES];
    }
    if (self.musicPlayer.playbackState == MPMusicPlaybackStatePaused) {
        [self setPlayPauseButtonImage:@"Play" enabled:YES];
    }
    if (self.musicPlayer.playbackState == MPMusicPlaybackStateStopped) {
        [self setPlayPauseButtonImage:@"Play" enabled:NO];
    }
}

- (void)handle_NowPlayingItemChanged:(id)notification
{
    
}

- (void)handle_VolumeChanged:(id)notification
{
    
}

- (void)handle_DidEnterForeground:(NSNotification*)sender;
{
    self.currentlyPlayingTitle.text = self.currentlyPlayingTitle.text;
    self.currentlyPlayingArtist.text = self.currentlyPlayingArtist.text;
    self.currentlyPlayingAlbum.text = self.currentlyPlayingAlbum.text;
}


#pragma mark - MediaPlayerNotifications

- (void)registerForMediaPlayerNotifications {
    // Register for music player notifications
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [self.musicPlayer beginGeneratingPlaybackNotifications];
    
    [notificationCenter addObserver:self selector:@selector(handle_NowPlayingItemChanged:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:self.musicPlayer];
    [notificationCenter addObserver:self selector:@selector(handle_PlaybackStateChanged:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:self.musicPlayer];
    [notificationCenter addObserver:self selector:@selector(handle_VolumeChanged:) name:MPMusicPlayerControllerVolumeDidChangeNotification object:self.musicPlayer];
}

- (void)unregisterForMediaPlayerNotifications {
    
    [self.musicPlayer endGeneratingPlaybackNotifications];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:self.musicPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:self.musicPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMusicPlayerControllerVolumeDidChangeNotification object:self.musicPlayer];
}

#pragma mark - MUSIC ACTIONS: FIX!

- (void)setupSongInfo {    
    //Set play/pause button to show the pause image
    [self setPlayPauseButtonImage:@"Pause" enabled:YES];

    //Use the artwork on the current media item and set that if it exists
    MPMediaItemArtwork *artworkItem = [self.musicPlayer.nowPlayingItem valueForProperty: MPMediaItemPropertyArtwork];
    if ([artworkItem imageWithSize:CGSizeMake(320, 320)]) {
        [self.currentlyPlayingArtworkImage setImage:[artworkItem imageWithSize:CGSizeMake (320, 320)]];
    }
}

- (void)displaySongInfoWithDuration:(double)duration {    
    //Set button to pause image
    [self setPlayPauseButtonImage:@"Pause" enabled:YES];
    
    //Animate in artwork with a fade
    [UIView animateWithDuration:duration animations:^ {
        [self.currentlyPlayingArtworkView setAlpha:1];
    }];
    
    //Make sure title, artist, and album are set to latest
    self.currentlyPlayingTitle.text = [self.musicPlayer.nowPlayingItem valueForKey:MPMediaItemPropertyTitle];
    self.currentlyPlayingArtist.text = [self.musicPlayer.nowPlayingItem valueForKey:MPMediaItemPropertyArtist];
    self.currentlyPlayingAlbum.text = [self.musicPlayer.nowPlayingItem valueForKey:MPMediaItemPropertyAlbumTitle];
    
    //Get value for playback duration and set as max, then zero it out
    
    [self.currentlyPlayingTimeSlider setMaximumValue:[[self.musicPlayer.nowPlayingItem valueForKey:MPMediaItemPropertyPlaybackDuration] floatValue]];
    self.currentlyPlayingTimeSlider.value = 0.0;
    
    //Slide up the play bar view, assuming everything is already there
    [self slidePlayBarWithDuration:duration inDirection:@"up"];
}

- (void)hideSongInfoWithDuration:(double)duration {
    //Slide down the play bar view
    [self slidePlayBarWithDuration:duration inDirection:@"down"];
    
    //Set button to play image
    [self setPlayPauseButtonImage:@"Play" enabled:NO];
    
    //Animate out artwork with a fade
    [UIView animateWithDuration:duration animations:^ {
        [self.currentlyPlayingArtworkView setAlpha:0];
    }];
    
    //Make sure title, artist, and album are set to nothing
    self.currentlyPlayingTitle.text = @"";
    self.currentlyPlayingArtist.text = @"";
    self.currentlyPlayingAlbum.text = @"";
}

- (void)resetMusicPlayer { 
#if TARGET_OS_IPHONE
    self.musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    [self.musicPlayer setShuffleMode: MPMusicShuffleModeOff];
    [self.musicPlayer setRepeatMode: MPMusicRepeatModeNone];
#endif
}

- (void)setPlayPauseButtonImage:(NSString *)image enabled:(BOOL)enabled {    
    if (image) {
        NSString *imageTitle = [image stringByAppendingString:@"IconButton"];
        [self.playPauseButton setImage:[UIImage imageNamed:imageTitle] forState:UIControlStateNormal];
    }
    
    [self.playPauseButton setEnabled:enabled];
}

- (void)slidePlayBarWithDuration:(double)duration inDirection:(NSString*)direction {
    //If the user has said up, move it up
    if (direction == @"up") {
        //Move bar view up with animation
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
            self.playBarView.frame = CGRectMake(0, 364, 320, 96);
        } completion:^ (BOOL finished) {
            self.currentlyPlayingArtworkView.dynamic = YES;
        }];
    }
    
    //If the user has said down, move it down
    if (direction == @"down") {
        //Move bar view down with animation
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
            self.playBarView.frame = CGRectMake(0, 460, 320, 96);
        } completion:^ (BOOL finished) {
            self.currentlyPlayingArtworkView.dynamic = YES;
        }];
    }
}

@end
