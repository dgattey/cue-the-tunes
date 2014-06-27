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
    /* -----------------------------------------------
      *  Reset music player and register for notifications
      *  Show play or pause button depending on state
      *  ----------------------------------------------- */
    [self resetMusicPlayer];
    [self registerForNotifications];
    if (self.musicPlayer.playbackState == MPMusicPlaybackStatePaused) {
        [self setPlayPauseButtonImage:@"Play" enabled:YES];
    }
    
    if (self.musicPlayer.playbackState == MPMusicPlaybackStatePlaying) {
        [self setPlayPauseButtonImage:@"Pause" enabled:YES];
    }
    
    /* ------------------------------------------------------------
      *  Set FXLabel, AutoScroll label styles (title/artist/album different)
      *  Hide all dynamic elements to fade in later
      *  ------------------------------------------------------------ */
    setTitleStyleUsingLabel(self.titleLabel);
    setTitleButtonStyleUsingLabel(self.hideButtonLabel);
    setTitleButtonStyleUsingLabel(self.optionsButtonLabel);
    for (AutoScrollLabel *label in self.view.allSubviews) {
        if ([label class] == [AutoScrollLabel class]) {
            [label setFont:interstateRegular(12)];
            label.bufferSpaceBetweenLabels = 30;
            label.scrollSpeed = 24;
            label.pauseInterval = 3.5;
            label.textColor = [UIColor whiteColor];
            label.text = @"";
            label.alpha = 0;
        }
    }
    [self.currentlyPlayingTitle setFont:interstateBold(15)];
    self.currentlyPlayingTitle.scrollSpeed = 20;
    self.currentlyPlayingArtworkView.alpha = 0.0;
    self.currentlyPlayingTimeSlider.alpha = 0.0;
    self.playPauseButton.alpha = 0.0;
    
    /* ----------------------------------------------
      *  Set a default image for the artwork view
      *  If there is an artwork item, make that the image
      *  ---------------------------------------------- */
    [self.currentlyPlayingArtworkView setImage:[UIImage imageNamed:@"NoArtworkImage"]];
    MPMediaItemArtwork *artworkItem = [self.musicPlayer.nowPlayingItem valueForProperty: MPMediaItemPropertyArtwork];
    if ([artworkItem imageWithSize:CGSizeMake(320, 320)]) {
        [self.currentlyPlayingArtworkView setImage:[artworkItem imageWithSize:CGSizeMake (320, 320)]];
    }
}

- (void)viewDidUnload {
    /* -----------------------------------------------
      *  Stop recieving notifications and disable the timer
      *  ----------------------------------------------- */
    [self unregisterForNotifications];
    [self.timer invalidate];
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
    [[DGOptionsDropdown sharedInstance] setViewsToHide:[[NSArray alloc] initWithObjects:self.hideButton, self.hideButtonLabel, nil]];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    /* ----------------------------------------------
      *  Disable all timers, stop recieving notifications
      *  ---------------------------------------------- */
    [self unregisterForNotifications];
    [self.timer invalidate];
    [self.timePopupTimer invalidate];
    [self.timer setFireDate:[NSDate distantFuture]];
    [NSTimer cancelPreviousPerformRequestsWithTarget:self];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    /* --------------------------------------------
      *  Call the changed song handle to update info
      *  Fade in all dynamic elements
      *  -------------------------------------------- */
    [self handle_CurrentlyPlayingSongChanged:nil];
    [UIView animateWithDuration:0.25 animations:^{
        self.currentlyPlayingTitle.alpha = 1.0;
        self.currentlyPlayingArtist.alpha = 1.0;
        self.currentlyPlayingAlbum.alpha = 1.0;
        self.currentlyPlayingArtworkView.alpha = 1.0;
        self.currentlyPlayingTimeSlider.alpha = 1.0;
        self.playPauseButton.alpha = 1.0;
    }completion:^(BOOL finished) {
        if (finished) {
            [self showTimePopup];
            self.timePopupTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(hideTimePopupWithDelay:) userInfo:nil repeats:NO];
        }
    }];
}

/* ------------------------------------ */
   # pragma mark - Show/hide views
/* ------------------------------------ */

- (IBAction)hideMe:(id)sender {
    /* -------------------------------------------------
      *  Hides the view, transitions back to the game view
      *  ------------------------------------------------- */
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)showOptionsViewFromGameView:(id)sender {
    /* ----------------------------------------------
      *  Sllide the global options view up or down
      *  ---------------------------------------------- */
    [[DGOptionsDropdown sharedInstance] slideOptionsWithDuration:0.3];
}

/* ------------------------------------ */
   # pragma mark - Slider/time popup
/* ------------------------------------ */

- (IBAction)sliderTouchesBegun:(id)sender {
    /* ---------------------------------------------------
      *  Touches have begun on the slider
      *  If the music player was playing, pause it and set bool
      *  Set the sliding bool for use in other methods
      *  --------------------------------------------------- */
    if (self.musicPlayer.playbackState == MPMusicPlaybackStatePlaying) {
        [self.musicPlayer pause];
        wasPlaying = YES;
    }
    sliding = YES;
    DLog(@"Start sliding");
    
    /* ----------------------------------------------
      *  Show the time popup and cancel the timers
      *  ---------------------------------------------- */
    [self showTimePopup];
    [self.timer invalidate];
    [self.timePopupTimer invalidate];
}

- (IBAction)sliderValueChanged:(id)sender {        
    /* ---------------------------------------------------------------
      *  For dragging the slider: value changed
      *  Set the current playback time based on the value
      *  Covert the current time into the minutes and seconds strings
      *  Move the time slider and update the text, canceling previous timer
      *  --------------------------------------------------------------- */
    [self.musicPlayer setCurrentPlaybackTime:[NSNumber numberWithFloat:self.currentlyPlayingTimeSlider.value].doubleValue];
    [self performSelectorOnMainThread:@selector(convertTime) withObject:nil waitUntilDone:YES];
    self.timeLabel.text = [[self.minutesString stringByAppendingString:@":"] stringByAppendingString:self.secondsString];
    [self updateTimePopupPosition];
    [self.timePopupTimer invalidate];
    
    /* ---------------------------------------------------------
      *  If the user is done sliding, change bool
      *  Update and show the timer label
      *  Hide it after four seconds
      *  Ensure current time is correct and play if previously playing
      *  --------------------------------------------------------- */
    if (!self.currentlyPlayingTimeSlider.isTracking && sliding) {
        sliding = NO;
        [self convertTime];
        self.timeLabel.text = [[self.minutesString stringByAppendingString:@":"] stringByAppendingString:self.secondsString];
        [self showTimePopup];
        self.timePopupTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(hideTimePopupWithDelay:) userInfo:nil repeats:NO];
        if (wasPlaying) {
            [self.musicPlayer play];
            wasPlaying = NO;
        }
        DLog(@"Sliding done");
    }
}

- (void)updateSliderTime:(NSTimer *)timer {
    /* --------------------------------------------------------------------
      *  If the user isn't sliding the timer:
      *  Convert the current playback time and set it as the hr:min string
      *  Set the slider value based on playback time and update popup position
      *  -------------------------------------------------------------------- */
    if (!sliding) {
        DLog(@"Update slider time");
        [self performSelectorOnMainThread:@selector(convertTime) withObject:nil waitUntilDone:YES];
        self.timeLabel.text = [[self.minutesString stringByAppendingString:@":"] stringByAppendingString:self.secondsString];
        [self.currentlyPlayingTimeSlider setValue:self.musicPlayer.currentPlaybackTime];
        [self updateTimePopupPosition];
        
        /* -------------------------------------------------
            *  If the player is currently playing, recreate the timer
            *  ------------------------------------------------- */
        if (self.musicPlayer.playbackState == MPMusicPlaybackStatePlaying) {
            self.timer = [NSTimer timerWithTimeInterval:0.45 target:self selector:@selector(updateSliderTime:) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
    }
}

- (void)convertTime {    
    /* ------------------------------------------------------------------
      *  Create NSDateComponents from the current playback time
      *  Set the minute and second string from that (if <10 sec, add leading 0)
      *  ------------------------------------------------------------------ */
    NSDateComponents *conversionInfo = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit fromDate:[[NSDate alloc] init]  toDate:[[NSDate alloc] initWithTimeInterval:self.musicPlayer.currentPlaybackTime sinceDate:[[NSDate alloc] init]]  options:0];
    self.minutesString = [NSString stringWithFormat:@"%i", conversionInfo.minute];
    self.secondsString = [NSString stringWithFormat:@"%i", conversionInfo.second];
    if (self.secondsString.length == 1) {
        self.secondsString = [@"0" stringByAppendingString:[NSString stringWithFormat:@"%i", conversionInfo.second]];
    }
}

- (void)showTimePopup {
    /* ----------------------------------------------
      *  If time popup hidden, animate it in over 0.3 sec
      *  ---------------------------------------------- */
    if (self.timePopup.alpha == 0.0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.timePopup.alpha = 1.0;
        }];
    }
    DLog(@"Popup shown");
}

- (void)hideTimePopupWithDelay:(float)delay {
    /* ------------------------------------------------
      *  Fade out the time popup with the passed in delay
      *  ------------------------------------------------ */
    if (!delay) {
        delay = 0;
    }
    [UIView animateWithDuration:0.3 delay:delay options:UIViewAnimationCurveEaseOut animations:^{
        self.timePopup.alpha = 0.0;
    } completion:^(BOOL finished) {}];
    DLog(@"Popup hidden");
}

- (void)updateTimePopupPosition {
    /* ------------------------------------------------------------------------------------
      *  Honestly, I don't know why these numbers work
      *  Makes a new x for the time popup by taking offset and multiplying by (almost?) full width
      *  ------------------------------------------------------------------------------------ */
    //Set a new x position for the time popup by taking the offset of the slider (18) and adding the percent progress * 284 (the full width)
    float newX = roundf(30 + (260 * (self.currentlyPlayingTimeSlider.value / self.currentlyPlayingTimeSlider.maximumValue)));
    DLog(@"New x: %f", newX);
    self.timePopup.center = CGPointMake(newX, self.timePopup.center.y);
}

/* ------------------------------------ */
   # pragma mark - Music actions
/* ------------------------------------ */

- (void)resetMusicPlayer {
    /* ----------------------------------------------
      *  Sets the music player to the iPodMusicPlayer
      *  Also sets the wanted shuffle and repeat modes
      *  ---------------------------------------------- */
    self.musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    [self.musicPlayer setShuffleMode: MPMusicShuffleModeOff];
    [self.musicPlayer setRepeatMode: MPMusicRepeatModeNone];
    DLog(@"Music player reset");
}

- (IBAction)playPauseMusic:(id)sender {
    /* ----------------------------------------------
      *  Based on playback state, play or pause music
      *  Also set image of play/pause button
      *  ---------------------------------------------- */
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
    /* ----------------------------------------------------------------
      *  Set the play/pause button's image and enabled bool
      *  Take the string "Play" or "Pause" and add the rest of the image title
      *  ---------------------------------------------------------------- */
    if (image) {
        NSString *imageTitle = [image stringByAppendingString:@"IconButton"];
        [self.playPauseButton setImage:[UIImage imageNamed:imageTitle] forState:UIControlStateNormal];
    }
    
    [self.playPauseButton setEnabled:enabled];
}

/* ------------------------------------------ */
   # pragma mark - Notifications and handles
/* ------------------------------------------ */

- (void)handle_PlaybackStateChanged:(id)notification {
    /* ----------------------------------------------
      *  For when the current playback state changes
      *  Based on playback state, set button and timer
      *  Also show the time popup for paused
      *  Hide the whole view if stopped
      *  ---------------------------------------------- */
    if (self.musicPlayer.playbackState == MPMusicPlaybackStatePlaying) {
        [self setPlayPauseButtonImage:@"Pause" enabled:YES];
        self.timer = [NSTimer timerWithTimeInterval:0.45 target:self selector:@selector(updateSliderTime:) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    if (self.musicPlayer.playbackState == MPMusicPlaybackStatePaused) {
        [self setPlayPauseButtonImage:@"Play" enabled:YES];
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
    /* ------------------------------------------------------
      *  For when the currently playing item changes
      *  Set the text of the title/artist/album after nil-ing
      *  Also set max value of slider and artwork item if it exists
      *  Theme the slider with custom images
      *  Finally, update the slider time
      *  ------------------------------------------------------ */
    [self.currentlyPlayingTitle setText:@""];
    [self.currentlyPlayingTitle setText:[self.musicPlayer.nowPlayingItem valueForKey:MPMediaItemPropertyTitle]];
    [self.currentlyPlayingArtist setText:@""];
    [self.currentlyPlayingArtist setText:[self.musicPlayer.nowPlayingItem valueForKey:MPMediaItemPropertyArtist]];
    [self.currentlyPlayingAlbum setText:@""];
    [self.currentlyPlayingAlbum setText:[self.musicPlayer.nowPlayingItem valueForKey:MPMediaItemPropertyAlbumTitle]];
    [self.currentlyPlayingTimeSlider setMaximumValue:[[self.musicPlayer.nowPlayingItem valueForKey:MPMediaItemPropertyPlaybackDuration] intValue]];
    [self.currentlyPlayingTimeSlider setThumbImage:[UIImage imageNamed:@"SliderThumb"] forState:UIControlStateNormal];
    [self.currentlyPlayingTimeSlider setThumbImage:[UIImage imageNamed:@"SliderThumb"] forState:UIControlStateHighlighted];
    [self.currentlyPlayingTimeSlider setMinimumTrackImage:[[UIImage imageNamed:@"SliderBlueTrack"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [self.currentlyPlayingTimeSlider setMaximumTrackImage:[[UIImage imageNamed:@"SliderWhiteTrack"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0] forState:UIControlStateNormal];
    MPMediaItemArtwork *artworkItem = [self.musicPlayer.nowPlayingItem valueForProperty: MPMediaItemPropertyArtwork];
    if ([artworkItem imageWithSize:CGSizeMake(320, 320)]) {
        [self.currentlyPlayingArtworkView setImage:[artworkItem imageWithSize:CGSizeMake (320, 320)]];
    }
    else {
        [self.currentlyPlayingArtworkView setImage:[UIImage imageNamed:@"NoArtworkImage"]];
    }
    [self updateSliderTime:self.timer];
}

- (void)registerForNotifications {
    /* ----------------------------------------------
      *  Register for music player notifications
      *  Add observers to the notification center
      *  ---------------------------------------------- */
    [self.musicPlayer beginGeneratingPlaybackNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handle_PlaybackStateChanged:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:self.musicPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handle_CurrentlyPlayingSongChanged:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:self.musicPlayer];
}

- (void)unregisterForNotifications {
    /* ----------------------------------------------
      *  Unregister for all playback notifications
      *  Remove observers from notification center
      *  ---------------------------------------------- */
    [self.musicPlayer endGeneratingPlaybackNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:self.musicPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:self.musicPlayer];
}

@end