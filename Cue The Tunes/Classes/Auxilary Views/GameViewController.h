//
//  GameViewController.h
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


#import "DGOptionsDropdown.h"

@interface GameViewController : UIViewController <MPMediaPickerControllerDelegate, UIAccelerometerDelegate, UIAlertViewDelegate> {
    FXLabel *_titleLabelGame;
    UIImageView *_background;
    UIButton *_nextQuestionButton;
    UIButton *_chooseSongButton;
    UILabel *_questionLabel;
    UIButton *_backButton;    
    UIButton *_optionsButton;
    UILabel *_questionsLeft;
    
    UIImageView *_musicNotes;
    
    UIImageView *_optionsTopBarBackground;
    UIView *_optionsOverlay;
    UIImageView *_optionsView;
    UISwitch *_optionsAccelerometerSwitch;
    UISwitch *_optionsVibrationSwitch;
    DGOptionItem *_optionItemAccelerometer;
    DGOptionItem *_optionItemVibration;
    
    UILabel *_currentlyPlayingTimeRemainingLabel;
    UILabel *_currentlyPlayingTimeElapsedLabel;
    NSString *_minutesString;
    NSString *_secondsString;
    UITapGestureRecognizer *_artworkTapGestureRecognizer;
    UITapGestureRecognizer *_backgroundTapGestureRecognizer;
    
    NSMutableArray *_questionArray;
    NSUInteger numQuestions;
    MPMusicPlayerController *_musicPlayer;
    MPMediaItemCollection *_musicCollection;
    MPMediaItem *_mediaItem;
}

@property (nonatomic, strong) IBOutlet UILabel *titleLabelGame;

@property (nonatomic, strong) IBOutlet UIView *backgroundView;
@property (nonatomic, strong) IBOutlet UIButton *nextQuestionButton;
@property (nonatomic, strong) IBOutlet UIButton *chooseSongButton;
@property (nonatomic, strong) IBOutlet UILabel *questionLabel;
@property (nonatomic, strong) IBOutlet UIButton *backButton;
@property (nonatomic, strong) IBOutlet UIButton *optionsButton;
@property (nonatomic, strong) IBOutlet UILabel *questionsLeft;

@property (nonatomic, strong) IBOutlet UIImageView *musicNotes;

@property (nonatomic, strong) IBOutlet UIImageView *optionsTopBarBackground;
@property (nonatomic, strong) UIView *optionsOverlay;
@property (nonatomic, strong) UIImageView *optionsView;
@property (nonatomic, strong) UISwitch *optionsAccelerometerSwitch;
@property (nonatomic, strong) UISwitch *optionsVibrationSwitch;
@property (nonatomic, strong) DGOptionItem *optionItemAccelerometer;
@property (nonatomic, strong) DGOptionItem *optionItemVibration;

@property (strong) NSMutableArray *questionArray;
@property (strong) MPMusicPlayerController *musicPlayer;
@property (strong) MPMediaItemCollection *musicCollection;
@property (strong) MPMediaItem *mediaItem;

- (IBAction)doneGameView:(id)sender;
- (IBAction)chooseSong:(id)sender;
- (void)updatePlayerQueueWithCollection:(MPMediaItemCollection*)collection;
- (void)refreshQuestionNumberLabel;

- (IBAction)showOptionsViewFromGameView:(id)sender;
- (IBAction)showNextQuestion:(id)sender;
- (void)enableNextQuestionButton:(id)sender;

- (void)optionsToggledAccelerometer:(id)sender;
- (void)optionsToggledVibration:(id)sender;
- (void)overlayTapped:(id)sender;
- (void)updateQuestionText:(id)sender;

@end
