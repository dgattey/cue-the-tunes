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
playBarView = _playBarView,
currentlyPlayingArtworkView = _currentlyPlayingArtworkView,
currentlyPlayingArtworkImage = _currentlyPlayingArtworkImage,
currentlyPlayingTitle = _currentlyPlayingTitle,
currentlyPlayingArtist = _currentlyPlayingArtist,
currentlyPlayingAlbum = _currentlyPlayingAlbum,
currentlyPlayingTimeSlider = _currentlyPlayingTimeSlider,
playPauseButton = _playPauseButton,
currentlyPlayingTimeRemainingLabel = _currentlyPlayingTimeRemainingLabel, 
currentlyPlayingTimeElapsedLabel = _currentlyPlayingTimeElapsedLabel,
secondsString = _secondsString,
minutesString = _minutesString;

- (void)viewDidLoad {
    //Reset music player
    [self resetMusicPlayer];
    
    //Register for notifications
    [self registerForMediaPlayerNotifications];
    
    //Show song info, etc if playing
    self.musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    if (self.musicPlayer.playbackState == MPMusicPlaybackStatePlaying || self.musicPlayer.playbackState == MPMusicPlaybackStatePaused) {
        //Setup the info & display
        [self setupSongInfo];
        [self displaySongInfoWithDuration:0.01];
        
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
    
    //Set default styles for AutoScroll title label
    [self.currentlyPlayingTitle setFont:interstateBold(20)];
    self.currentlyPlayingTitle.bufferSpaceBetweenLabels = 24.0;
    self.currentlyPlayingTitle.scrollSpeed = 19;
    self.currentlyPlayingTitle.pauseInterval = 3;
    self.currentlyPlayingTitle.textColor = [UIColor whiteColor];
    self.currentlyPlayingTitle.text = [self.musicPlayer.nowPlayingItem valueForKey:MPMediaItemPropertyTitle];
    
    //And artist label
    [self.currentlyPlayingArtist setFont:interstateRegular(15)];
    self.currentlyPlayingArtist.bufferSpaceBetweenLabels = 24.0;
    self.currentlyPlayingArtist.scrollSpeed = 25;
    self.currentlyPlayingArtist.pauseInterval = 3;
    self.currentlyPlayingArtist.textColor = [UIColor whiteColor];
    self.currentlyPlayingArtist.text = [self.musicPlayer.nowPlayingItem valueForKey:MPMediaItemPropertyArtist];
    
    //And album label
    [self.currentlyPlayingAlbum setFont:interstateRegular(15)];
    self.currentlyPlayingAlbum.bufferSpaceBetweenLabels = 24.0;
    self.currentlyPlayingAlbum.scrollSpeed = 23;
    self.currentlyPlayingAlbum.pauseInterval = 3;
    self.currentlyPlayingAlbum.textColor = [UIColor whiteColor];
    self.currentlyPlayingAlbum.text = [self.musicPlayer.nowPlayingItem valueForKey:MPMediaItemPropertyAlbumTitle];
    
    //Set UIImageView
    [self.currentlyPlayingArtworkView setOpaque:YES];
    [self.currentlyPlayingArtworkView setExclusiveTouch:YES];
    
    //Set default image
    [self.currentlyPlayingArtworkImage setImage:[UIImage imageNamed:@"NoArtworkImage"]];
    
    //Setup images for UISlider (for song progress)
    [self.currentlyPlayingTimeSlider setThumbImage: [UIImage imageNamed:@"SliderThumb"] forState:UIControlStateNormal];
    [self.currentlyPlayingTimeSlider setMinimumTrackImage:[[UIImage imageNamed:@"SliderBlueTrack"] stretchableImageWithLeftCapWidth:3.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [self.currentlyPlayingTimeSlider setMaximumTrackImage:[[UIImage imageNamed:@"SliderWhiteTrack"] stretchableImageWithLeftCapWidth:3.0 topCapHeight:0.0] forState:UIControlStateNormal];
    
    
    //Set timer to repeat the update every minute
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(updateSliderTime:) userInfo:nil repeats:NO];
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
}

- (void)hideSongInfoWithDuration:(double)duration {    
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
    self.musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    [self.musicPlayer setShuffleMode: MPMusicShuffleModeOff];
    [self.musicPlayer setRepeatMode: MPMusicRepeatModeNone];
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
    }
    if (self.musicPlayer.playbackState == MPMusicPlaybackStatePaused) {
        [self setPlayPauseButtonImage:@"Play" enabled:YES];
    }
    if (self.musicPlayer.playbackState == MPMusicPlaybackStateStopped) {
        [self setPlayPauseButtonImage:@"Play" enabled:NO];
    }
}

- (void)handle_NowPlayingItemChanged:(id)notification {
    
}

- (void)handle_VolumeChanged:(id)notification {
    
}

- (void)handle_DidEnterForeground:(NSNotification*)sender; {
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

@end