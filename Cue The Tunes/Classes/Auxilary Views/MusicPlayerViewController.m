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
        timer = _timer,
        timePopupTimer = _timePopupTimer;

- (void)viewDidLoad {
    //Reset music player and create idle timer
    [self resetMusicPlayer];
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(resetIdleTimer) userInfo:nil repeats:YES];
    
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
    self.currentlyPlayingTitle.bufferSpaceBetweenLabels = 30;
    self.currentlyPlayingTitle.scrollSpeed = 20;
    self.currentlyPlayingTitle.pauseInterval = 3.5;
    self.currentlyPlayingTitle.textColor = [UIColor whiteColor];
    [self.currentlyPlayingTitle setText:@""];
    
    //And artist label
    [self.currentlyPlayingArtist setFont:interstateRegular(12)];
    self.currentlyPlayingArtist.bufferSpaceBetweenLabels = 30;
    self.currentlyPlayingArtist.scrollSpeed = 24;
    self.currentlyPlayingArtist.pauseInterval = 3.5;
    self.currentlyPlayingArtist.textColor = [UIColor whiteColor];
    [self.currentlyPlayingArtist setText:@""];
    
    //And album label
    [self.currentlyPlayingAlbum setFont:interstateRegular(12)];
    self.currentlyPlayingAlbum.bufferSpaceBetweenLabels = 30;
    self.currentlyPlayingAlbum.scrollSpeed = 24;
    self.currentlyPlayingAlbum.pauseInterval = 3.5;
    self.currentlyPlayingAlbum.textColor = [UIColor whiteColor];
    [self.currentlyPlayingAlbum setText:@""];
    
    //Hide everything so animation is smooth later
    self.currentlyPlayingTitle.alpha = 0.0;
    self.currentlyPlayingArtist.alpha = 0.0;
    self.currentlyPlayingAlbum.alpha = 0.0;
    self.currentlyPlayingArtworkView.alpha = 0.0;
    self.currentlyPlayingTimeSlider.alpha = 0.0;
    self.playPauseButton.alpha = 0.0;
    
    //Set default image
    [self.currentlyPlayingArtworkView setImage:[UIImage imageNamed:@"NoArtworkImage"]];
    
    //Sets real image
    MPMediaItemArtwork *artworkItem = [self.musicPlayer.nowPlayingItem valueForProperty: MPMediaItemPropertyArtwork];
    if ([artworkItem imageWithSize:CGSizeMake(320, 320)]) {
        [self.currentlyPlayingArtworkView setImage:[artworkItem imageWithSize:CGSizeMake (320, 320)]];
    }
    
    //Register for notifications
    [self registerForNotifications];
}

- (IBAction)hideMe:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self unregisterForNotifications];
    [self.timer invalidate];
}

- (void)viewWillAppear:(BOOL)animated {
    /* ----------------------------------------------
      *  Setup current options view
      *  ---------------------------------------------- */
    [[DGOptionsDropdown sharedInstance] refreshOptionsView];
    [[DGOptionsDropdown sharedInstance] setAnchor:self.optionsTopBarBackground];
    [[DGOptionsDropdown sharedInstance] setOptionsButton:self.optionsButton];
    [[DGOptionsDropdown sharedInstance] setOptionsButtonLabel:self.optionsButtonLabel];
    [[DGOptionsDropdown sharedInstance] setViewsToHide:[[NSArray alloc] initWithObjects:self.hideButton, self.hideButtonLabel, nil]];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    
    //No more timer
    [self unregisterForNotifications];
    [self.timer invalidate];
    [self.timePopupTimer invalidate];
    [self.timer setFireDate:[NSDate distantFuture]];
    [NSTimer cancelPreviousPerformRequestsWithTarget:self];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.currentlyPlayingTitle setText:[self.musicPlayer.nowPlayingItem valueForKey:MPMediaItemPropertyTitle]];
    [self.currentlyPlayingArtist setText:[self.musicPlayer.nowPlayingItem valueForKey:MPMediaItemPropertyArtist]];
    [self.currentlyPlayingAlbum setText:[self.musicPlayer.nowPlayingItem valueForKey:MPMediaItemPropertyAlbumTitle]];
    
    [self.currentlyPlayingTimeSlider setMaximumValue:[[self.musicPlayer.nowPlayingItem valueForKey:MPMediaItemPropertyPlaybackDuration] intValue]];
    //Setup images for UISlider (for song progress) & length
    [self.currentlyPlayingTimeSlider setThumbImage:[UIImage imageNamed:@"SliderThumb"] forState:UIControlStateNormal];
    [self.currentlyPlayingTimeSlider setThumbImage:[UIImage imageNamed:@"SliderThumb"] forState:UIControlStateHighlighted];
    [self.currentlyPlayingTimeSlider setMinimumTrackImage:[[UIImage imageNamed:@"SliderBlueTrack"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [self.currentlyPlayingTimeSlider setMaximumTrackImage:[[UIImage imageNamed:@"SliderWhiteTrack"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [self updateSliderTime:self.timer];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.currentlyPlayingTitle.alpha = 1.0;
        self.currentlyPlayingArtist.alpha = 1.0;
        self.currentlyPlayingAlbum.alpha = 1.0;
        self.currentlyPlayingArtworkView.alpha = 1.0;
        self.currentlyPlayingTimeSlider.alpha = 1.0;
        self.playPauseButton.alpha = 1.0;
    }];
}

#pragma mark - Options

- (IBAction)showOptionsViewFromGameView:(id)sender {
    //Show the options dropdown
    [[DGOptionsDropdown sharedInstance] slideOptionsWithDuration:0.3];
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
    [self.timePopupTimer invalidate];
}

- (IBAction)sliderValueChanged:(id)sender {        
    //Set playback time based on value
    [self.musicPlayer setCurrentPlaybackTime:[NSNumber numberWithFloat:self.currentlyPlayingTimeSlider.value].doubleValue];
    
    //Convert the current time into the minutes and seconds strings and set them as the time elapsed
    [self performSelectorOnMainThread:@selector(convertTime) withObject:nil waitUntilDone:YES];
    self.timeLabel.text = [[self.minutesString stringByAppendingString:@":"] stringByAppendingString:self.secondsString];
    
    //Move time slider
    [self updateTimePopupPosition];
    
    //Cancel previous timer
    [self.timePopupTimer invalidate];
    
    //Done? Set sliding to no so timer can keep updating, and reschedule timer, and hide time popup after a 2.2 second delay, and play music
    if (!self.currentlyPlayingTimeSlider.isTracking && sliding) {
        DLog(@"Sliding done");
        sliding = NO;
        
        //Show updated time label, hiding after 4 seconds
        self.timeLabel.text = [[self.minutesString stringByAppendingString:@":"] stringByAppendingString:self.secondsString];
        [self showTimePopup];
        self.timePopupTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(hideTimePopupWithDelay:) userInfo:nil repeats:NO];
        
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
        [self performSelectorOnMainThread:@selector(convertTime) withObject:nil waitUntilDone:YES];
        self.timeLabel.text = [[self.minutesString stringByAppendingString:@":"] stringByAppendingString:self.secondsString];
        
        //Set value based on playback time
        [self.currentlyPlayingTimeSlider setValue:self.musicPlayer.currentPlaybackTime];
        
        //Update time popup position
        [self updateTimePopupPosition];
        
        //And reschedule the timer
        if (self.musicPlayer.playbackState == MPMusicPlaybackStatePlaying) {
            self.timer = [NSTimer timerWithTimeInterval:0.45 target:self selector:@selector(updateSliderTime:) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
    }
}

- (void)convertTime {
    //Set amount of time to convert
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:self.musicPlayer.currentPlaybackTime sinceDate:date1]; 
    
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
    if (self.timePopup.alpha == 0.0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.timePopup.alpha = 1.0;
        }];
    }
    DLog(@"Popup shown");
}

- (void)hideTimePopupWithDelay:(float)delay {
    if (!delay) {
        delay = 0;
    }
    [UIView animateWithDuration:0.3 delay:delay options:UIViewAnimationCurveEaseOut animations:^{
        self.timePopup.alpha = 0.0;
    } completion:^(BOOL finished) {}];
    DLog(@"Popup hidden");
}

- (void)updateTimePopupPosition {
    //Set a new x position for the time popup by taking the offset of the slider (18) and adding the percent progress * 284 (the full width)
    float newX = roundf(30 + (260 * (self.currentlyPlayingTimeSlider.value / self.currentlyPlayingTimeSlider.maximumValue)));
    DLog(@"New x: %f", newX);
    self.timePopup.center = CGPointMake(newX, self.timePopup.center.y);
}

#pragma mark - Music Actions

- (void)resetIdleTimer {
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)resetMusicPlayer {
    self.musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    [self.musicPlayer setShuffleMode: MPMusicShuffleModeOff];
    [self.musicPlayer setRepeatMode: MPMusicRepeatModeNone];
}

- (IBAction)playPauseMusic:(id)sender {
    if (self.musicPlayer.playbackState == MPMusicPlaybackStatePlaying) {
        [self.musicPlayer pause];
        [self setPlayPauseButtonImage:@"Play"enabled:YES];
    }
    else if (self.musicPlayer.playbackState == MPMusicPlaybackStatePaused) {
        [self.musicPlayer play];
        [self setPlayPauseButtonImage:@"Pause" enabled:YES];
    }
    else {
        [self.musicPlayer pause];
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
        self.timer = [NSTimer timerWithTimeInterval:0.45 target:self selector:@selector(updateSliderTime:) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    if (self.musicPlayer.playbackState == MPMusicPlaybackStatePaused) {
        [self setPlayPauseButtonImage:@"Play" enabled:YES];
        
        //Timer and time popup work
        [self showTimePopup];
        [self.timePopupTimer invalidate];
        self.timePopupTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(hideTimePopupWithDelay:) userInfo:nil repeats:NO];
        [self.timer invalidate];
    }
    if (self.musicPlayer.playbackState == MPMusicPlaybackStateStopped) {
        [self setPlayPauseButtonImage:@"Play" enabled:NO];
        [self hideMe:self];
        [self.timer invalidate];
    }
}

- (void)handle_CurrentlyPlayingSongChanged:(id)notification {
    if (self.musicPlayer.playbackState == MPMusicPlaybackStateInterrupted) {
        [self hideMe:self];
        [self.musicPlayer stop];
    }
}

#pragma mark - MediaPlayerNotifications

- (void)registerForNotifications {
    // Register for music player notifications
    [self.musicPlayer beginGeneratingPlaybackNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handle_PlaybackStateChanged:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:self.musicPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handle_CurrentlyPlayingSongChanged:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:self.musicPlayer];
}

- (void)unregisterForNotifications {
    [self.musicPlayer endGeneratingPlaybackNotifications];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:self.musicPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:self.musicPlayer];
}

@end