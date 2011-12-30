//
//  MusicPlayerViewController.h
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

#import "AutoScrollLabel.h"

@interface MusicPlayerViewController : UIViewController <MPMediaPickerControllerDelegate, UIScrollViewDelegate>
{
    MPMusicPlayerController *_musicPlayer;
    UIImageView *_currentlyPlayingArtworkView;
    AutoScrollLabel *_currentlyPlayingTitle;
    AutoScrollLabel *_currentlyPlayingArtist;
    AutoScrollLabel *_currentlyPlayingAlbum;
    UISlider *_currentlyPlayingTimeSlider;
    UIView *_timePopup;
    UILabel *_timeLabel;
    UIButton *_playPauseButton;
    NSString *_secondsString;
    NSString *_minutesString;
    FXLabel *_titleLabel;
    FXLabel *_optionsButtonLabel;
    UIButton *_optionsButton;
    FXLabel *_hideButtonLabel;
    UIButton *_hideButton;
    
    UIImageView *_optionsTopBarBackground;

    NSTimer *_timer;
    NSTimer *_timePopupTimer;
    BOOL sliding;
    BOOL wasPlaying;
}

@property (nonatomic, strong) MPMusicPlayerController *musicPlayer;
@property (nonatomic, strong) IBOutlet UIImageView *currentlyPlayingArtworkView;
@property (nonatomic, strong) IBOutlet AutoScrollLabel *currentlyPlayingTitle;
@property (nonatomic, strong) IBOutlet AutoScrollLabel *currentlyPlayingArtist;
@property (nonatomic, strong) IBOutlet AutoScrollLabel *currentlyPlayingAlbum;
@property (nonatomic, strong) IBOutlet UISlider *currentlyPlayingTimeSlider;
@property (nonatomic, strong) IBOutlet UIView *timePopup;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UIButton *playPauseButton;
@property (strong) NSString *secondsString;
@property (strong) NSString *minutesString;
@property (nonatomic, strong) IBOutlet FXLabel *titleLabel;
@property (nonatomic, strong) IBOutlet FXLabel *optionsButtonLabel;
@property (nonatomic, strong) IBOutlet UIButton *optionsButton;
@property (nonatomic, strong) IBOutlet FXLabel *hideButtonLabel;
@property (nonatomic, strong) IBOutlet UIButton *hideButton;

@property (nonatomic, strong) IBOutlet UIImageView *optionsTopBarBackground;

@property (strong) NSTimer *timer;
@property (strong) NSTimer *timePopupTimer;

- (IBAction)hideMe:(id)sender;
- (IBAction)sliderValueChanged:(id)sender;
- (IBAction)sliderTouchesBegun:(id)sender;
- (void)updateSliderTime:(NSTimer *)timer;
- (void)convertTime;

- (void)registerForNotifications;
- (void)unregisterForNotifications;
- (void)handle_PlaybackStateChanged:(id)notification;
- (void)handle_CurrentlyPlayingSongChanged:(id)notification;

- (void)resetIdleTimer;
- (void)resetMusicPlayer;
- (void)showTimePopup;
- (void)hideTimePopupWithDelay:(float)delay;
- (void)updateTimePopupPosition;
- (IBAction)playPauseMusic:(id)sender;
- (void)setPlayPauseButtonImage:(NSString *)image enabled:(BOOL)enabled;

- (IBAction)showOptionsViewFromGameView:(id)sender;

@end
