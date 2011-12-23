//
//  MusicPlayerViewController.m
//  Cue The Tunes
//
//  Created by Dylan Gattey on 12/11/11.
//  Copyright (c) 2011 Dylan Gattey. All rights reserved.
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

#import "MusicPlayerViewController.h"
#import "GameViewController.h"
#import "MainViewController.h"

@implementation MusicPlayerViewController

@synthesize musicPlayer = _musicPlayer,
        currentlyPlayingArtworkView = _currentlyPlayingArtworkView,
        currentlyPlayingTitle = _currentlyPlayingTitle,
        currentlyPlayingArtist = _currentlyPlayingArtist,
        currentlyPlayingAlbum = _currentlyPlayingAlbum,
        currentlyPlayingTimeSlider = _currentlyPlayingTimeSlider,
        timePopup = _timePopup,
        timeLabel = _timeLabel,
        playPauseButton = _playPauseButton,
        secondsString = _secondsString,
        minutesString = _minutesString,
        titleLabel = _titleLabel,
        optionsButtonLabel = _optionsButtonLabel,
        optionsButton = _optionsButton,
        hideButtonLabel = _hideButtonLabel,
        hideButton = _hideButton,
        optionsTopBarBackground = _optionsTopBarBackground,
        optionsOverlay = _optionsOverlay,
        optionsView = _optionsView,
        optionsAccelerometerSwitch = _optionsAccelerometerSwitch,
        optionsVibrationSwitch = _optionsVibrationSwitch,
        optionItemAccelerometer = _optionItemAccelerometer,
        optionItemVibration = _optionItemVibration,
        timer = _timer;

- (void)viewDidLoad {
    //Reset music player
    [self resetMusicPlayer];
    
    //Show the correct button
    if (self.musicPlayer.playbackState == MPMusicPlaybackStatePaused) {
        [self setPlayPauseButtonImage:@"Play" enabled:YES];
    }
    
    if (self.musicPlayer.playbackState == MPMusicPlaybackStatePlaying) {
        [self setPlayPauseButtonImage:@"Pause" enabled:YES];
    }
    
    //SetFXLabel styles
    setTitleStyleUsingLabel(self.titleLabel);
    setTitleButtonStyleUsingLabel(self.hideButtonLabel);
    setTitleButtonStyleUsingLabel(self.optionsButtonLabel);

    //Set default styles for AutoScroll title label
    [self.currentlyPlayingTitle setFont:interstateBold(15)];
    self.currentlyPlayingTitle.bufferSpaceBetweenLabels = 24.0;
    self.currentlyPlayingTitle.scrollSpeed = 19;
    self.currentlyPlayingTitle.pauseInterval = 3;
    self.currentlyPlayingTitle.textColor = [UIColor whiteColor];
    [self.currentlyPlayingTitle setText:@""];
    [self.currentlyPlayingTitle setText:[self.musicPlayer.nowPlayingItem valueForKey:MPMediaItemPropertyTitle]];
    
    //And artist label
    [self.currentlyPlayingArtist setFont:interstateRegular(12)];
    self.currentlyPlayingArtist.bufferSpaceBetweenLabels = 24.0;
    self.currentlyPlayingArtist.scrollSpeed = 25;
    self.currentlyPlayingArtist.pauseInterval = 3;
    self.currentlyPlayingArtist.textColor = [UIColor whiteColor];
    [self.currentlyPlayingArtist setText:@""];
    [self.currentlyPlayingArtist setText:[self.musicPlayer.nowPlayingItem valueForKey:MPMediaItemPropertyArtist]];
    
    //And album label
    [self.currentlyPlayingAlbum setFont:interstateRegular(12)];
    self.currentlyPlayingAlbum.bufferSpaceBetweenLabels = 24.0;
    self.currentlyPlayingAlbum.scrollSpeed = 23;
    self.currentlyPlayingAlbum.pauseInterval = 3;
    self.currentlyPlayingAlbum.textColor = [UIColor whiteColor];
    [self.currentlyPlayingAlbum setText:@""];
    [self.currentlyPlayingAlbum setText:[self.musicPlayer.nowPlayingItem valueForKey:MPMediaItemPropertyAlbumTitle]];
    
    //Set default image
    [self.currentlyPlayingArtworkView setImage:[UIImage imageNamed:@"NoArtworkImage"]];
    
    //Sets real image
    MPMediaItemArtwork *artworkItem = [self.musicPlayer.nowPlayingItem valueForProperty: MPMediaItemPropertyArtwork];
    if ([artworkItem imageWithSize:CGSizeMake(320, 320)]) {
        [self.currentlyPlayingArtworkView setImage:[artworkItem imageWithSize:CGSizeMake (320, 320)]];
    }
    
    //Setup images for UISlider (for song progress) & length
    [self.currentlyPlayingTimeSlider setMaximumValue:[[self.musicPlayer.nowPlayingItem valueForKey:MPMediaItemPropertyPlaybackDuration] intValue]];
    [self.currentlyPlayingTimeSlider setThumbImage:[UIImage imageNamed:@"SliderThumb"] forState:UIControlStateNormal];
    [self.currentlyPlayingTimeSlider setThumbImage:[UIImage imageNamed:@"SliderThumb"] forState:UIControlStateHighlighted];
    [self.currentlyPlayingTimeSlider setMinimumTrackImage:[[UIImage imageNamed:@"SliderBlueTrack"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [self.currentlyPlayingTimeSlider setMaximumTrackImage:[[UIImage imageNamed:@"SliderWhiteTrack"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0] forState:UIControlStateNormal];
    
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
    
    //Register for notifications
    [self registerForNotifications];
    [self updateSliderTime:self.timer];
}

- (IBAction)hideMe:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self unregisterForNotifications];
    [self.timer invalidate];
}

- (void)viewWillAppear:(BOOL)animated {
    [DGOptionsDropdown refreshOptionView:self.optionsView withOptionItem:self.optionItemAccelerometer withOverlay:self.optionsOverlay];
    [DGOptionsDropdown refreshOptionView:self.optionsView withOptionItem:self.optionItemVibration withOverlay:self.optionsOverlay];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    
    //No more timer?
    [self unregisterForNotifications];
    [self.timer invalidate];
    
    [super viewWillDisappear:animated];
}

#pragma mark - Options

- (IBAction)showOptionsViewFromGameView:(id)sender {
    //Show the options dropdown
    NSArray *array = [[NSArray alloc] initWithObjects:self.hideButton, self.hideButtonLabel, nil];
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

- (void)optionsToggledAccelerometer:(id)sender {
    [DGOptionsDropdown optionsToggledWithSwitch:self.optionsAccelerometerSwitch withTitle:@"Accelerometer"];
}

- (void)optionsToggledVibration:(id)sender {
    [DGOptionsDropdown optionsToggledWithSwitch:self.optionsVibrationSwitch withTitle:@"Vibration"];
}

- (void)overlayTapped:(id)sender {
    [self showOptionsViewFromGameView:self];
}

#pragma mark - Slider
- (IBAction)sliderTouchesBegun:(id)sender {
    if (self.musicPlayer.playbackState == MPMusicPlaybackStatePlaying) {
        [self.musicPlayer pause];
        wasPlaying = YES;
    }
    
    //Set global bool for use
    sliding = YES;
    DLog(@"Start sliding");
    
    //Show time popup
    [self showTimePopup];
    
    [self.timer invalidate];
}

- (IBAction)sliderValueChanged:(id)sender {        
    //Set playback time based on value
    [self.musicPlayer setCurrentPlaybackTime:[NSNumber numberWithFloat:self.currentlyPlayingTimeSlider.value].doubleValue];
    
    //Convert the current time into the minutes and seconds strings and set them as the time elapsed
    [self convertTime:self.musicPlayer.currentPlaybackTime];
    self.timeLabel.text = [[self.minutesString stringByAppendingString:@":"] stringByAppendingString:self.secondsString];
    
    //Done? Set sliding to no so timer can keep updating, and reschedule timer, and hide time popup after a 2.2 second delay, and play music
    if (!self.currentlyPlayingTimeSlider.isTracking) {
        DLog(@"Sliding done");
        sliding = NO;
        
        //Show updated time label, hiding after 3 seconds
        [self showTimePopup];
        [self hideTimePopupWithDelay:3];
        
        //Play the music if it was already playing
        if (wasPlaying) {
            [self.musicPlayer play];
            wasPlaying = NO;
        }
    }
}

- (void)updateSliderTime:(NSTimer *)timer {
    //Only if the slider isn't being slid currently
    if (!sliding) {
        DLog(@"Update slider time");
        
        //Convert the current time into the minutes and seconds strings and set them as the time elapsed
        [self convertTime:self.musicPlayer.currentPlaybackTime];
        self.timeLabel.text = [[self.minutesString stringByAppendingString:@":"] stringByAppendingString:self.secondsString];
        
        //Set value based on playback time
        [self.currentlyPlayingTimeSlider setValue:self.musicPlayer.currentPlaybackTime];
        
        //And reschedule the timer
        if (self.musicPlayer.playbackState == MPMusicPlaybackStatePlaying) {
            self.timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(updateSliderTime:) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
    }
}

- (void)convertTime:(NSTimeInterval )theTimeInterval {
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

- (void)showTimePopup {
    [UIView animateWithDuration:0.3 animations:^{
        self.timePopup.alpha = 1.0;
    }];
}

- (void)hideTimePopupWithDelay:(float)delay {
    [UIView animateWithDuration:0.3 delay:delay options:UIViewAnimationCurveEaseOut animations:^{
        self.timePopup.alpha = 0.0;
    } completion:^(BOOL finished) {}];
}

#pragma mark - Music Actions

- (void)resetMusicPlayer {
    self.musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    [self.musicPlayer setShuffleMode: MPMusicShuffleModeOff];
    [self.musicPlayer setRepeatMode: MPMusicRepeatModeNone];
}

- (IBAction)playPauseMusic:(id)sender {
    if (self.musicPlayer.playbackState == MPMusicPlaybackStatePlaying) {
        [self.musicPlayer pause];
        [self setPlayPauseButtonImage:@"Play"enabled:YES];
    }
    if (self.musicPlayer.playbackState == MPMusicPlaybackStatePaused) {
        [self.musicPlayer play];
        [self setPlayPauseButtonImage:@"Pause" enabled:YES];
    }
}

- (void)setPlayPauseButtonImage:(NSString *)image enabled:(BOOL)enabled {    
    if (image) {
        NSString *imageTitle = [image stringByAppendingString:@"IconButton"];
        [self.playPauseButton setImage:[UIImage imageNamed:imageTitle] forState:UIControlStateNormal];
    }
    
    [self.playPauseButton setEnabled:enabled];
}

#pragma mark - Handles

- (void)handle_PlaybackStateChanged:(id)notification {
    if (self.musicPlayer.playbackState == MPMusicPlaybackStatePlaying) {
        [self setPlayPauseButtonImage:@"Pause" enabled:YES];
        self.timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(updateSliderTime:) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    if (self.musicPlayer.playbackState == MPMusicPlaybackStatePaused) {
        [self setPlayPauseButtonImage:@"Play" enabled:YES];
        [self.timer invalidate];
    }
    if (self.musicPlayer.playbackState == MPMusicPlaybackStateStopped) {
        [self setPlayPauseButtonImage:@"Play" enabled:NO];
        [self hideMe:self];
        [self.timer invalidate];
    }
}

#pragma mark - MediaPlayerNotifications

- (void)registerForNotifications {
    // Register for music player notifications
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [self.musicPlayer beginGeneratingPlaybackNotifications];
    
    [notificationCenter addObserver:self selector:@selector(handle_PlaybackStateChanged:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:self.musicPlayer];
}

- (void)unregisterForNotifications {
    [self.musicPlayer endGeneratingPlaybackNotifications];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:self.musicPlayer];
}

@end