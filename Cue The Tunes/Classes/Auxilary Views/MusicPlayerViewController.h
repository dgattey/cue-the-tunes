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

@interface MusicPlayerViewController : UIViewController <MPMediaPickerControllerDelegate>
{
    MPMusicPlayerController *_musicPlayer;
    UIView *_playBarView;
    UIImageView *_currentlyPlayingArtworkView;
    UIImageView *_currentlyPlayingArtworkImage;
    AutoScrollLabel *_currentlyPlayingTitle;
    AutoScrollLabel *_currentlyPlayingArtist;
    AutoScrollLabel *_currentlyPlayingAlbum;
    UISlider *_currentlyPlayingTimeSlider;
    UIButton *_playPauseButton;
    NSString *_secondsString;
    NSString *_minutesString;
}

@property (nonatomic, strong) MPMusicPlayerController *musicPlayer;
@property (nonatomic, strong) IBOutlet UIView *playBarView;
@property (nonatomic, strong) IBOutlet UIImageView *currentlyPlayingArtworkView;
@property (nonatomic, strong) IBOutlet UIImageView *currentlyPlayingArtworkImage;
@property (nonatomic, strong) IBOutlet AutoScrollLabel *currentlyPlayingTitle;
@property (nonatomic, strong) IBOutlet AutoScrollLabel *currentlyPlayingArtist;
@property (nonatomic, strong) IBOutlet AutoScrollLabel *currentlyPlayingAlbum;
@property (strong) IBOutlet UISlider *currentlyPlayingTimeSlider;
@property (nonatomic, strong) IBOutlet UIButton *playPauseButton;
@property (nonatomic, strong) IBOutlet UILabel *currentlyPlayingTimeRemainingLabel;
@property (nonatomic, strong) IBOutlet UILabel *currentlyPlayingTimeElapsedLabel;
@property (strong) NSString *secondsString;
@property (strong) NSString *minutesString;

- (IBAction)sliderChanged:(id)sender;
- (void)updateSliderTime:(NSTimer *)timer;
- (void)convertTime:(NSTimeInterval )theTimeInterval;

- (void)registerForMediaPlayerNotifications;
- (void)unregisterForMediaPlayerNotifications;
- (void)handle_NowPlayingItemChanged:(id)notification;
- (void)handle_PlaybackStateChanged:(id)notification;
- (void)handle_VolumeChanged:(id)notification;
- (void)handle_DidEnterForeground:(NSNotification*)sender;

- (void)resetMusicPlayer;
- (void)setupSongInfo;
- (IBAction)playPauseMusic:(id)sender;
- (void)displaySongInfoWithDuration:(double)duration;
- (void)hideSongInfoWithDuration:(double)duration;
- (void)setPlayPauseButtonImage:(NSString *)image enabled:(BOOL)enabled;


@end
