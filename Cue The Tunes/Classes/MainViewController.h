//
//  MainViewController.h
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

#import "DGOptionItem.h"
#import "DGOptionsDropdown.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MainViewController : UIViewController {
    //Main
    UIView *_gameButtonView;
    UIButton *_gameButton;
    FXLabel *_gameButtonLabel;
    
    UIView *_optionsButtonView;
    UIButton *_optionsButton;
    FXLabel *_optionsButtonLabel;
    
    UIView *_instructionsButtonView;
    UIButton *_instructionsButton;
    FXLabel *_instructionsButtonLabel;
    
    UIView *_aboutButtonView;
    UIButton *_aboutButton;
    FXLabel *_aboutButtonLabel;
    
    UIImageView *_titleLabel;
    UIImageView *_titleBar;
    
    //Custom alert view replacement
    UIButton *_alertViewNewGameButton;
    FXLabel *_alertViewNewGameButtonLabel;
    
    UIButton *_alertViewContinueGameButton;
    FXLabel *_alertViewContinueGameButtonLabel;
    
    UIButton *_alertViewCancelButton;
    FXLabel *_alertViewCancelButtonLabel;
    
    UIView *_alertViewMainView;
    UIView *_alertViewOverlay;
    
    //Options
    UIView *_optionsOverlay;
    UIImageView *_optionsView;
    UISwitch *_optionsAccelerometerSwitch;
    DGOptionItem *_optionItemAccelerometer;
    UISwitch *_optionsVibrationSwitch;
    DGOptionItem *_optionItemVibration;
}

//Main properties
@property (nonatomic, strong) IBOutlet UIView *gameButtonView;
@property (nonatomic, strong) IBOutlet UIButton *gameButton;
@property (nonatomic, strong) IBOutlet FXLabel *gameButtonLabel;
@property (nonatomic, strong) IBOutlet UIView *optionsButtonView;
@property (nonatomic, strong) IBOutlet UIButton *optionsButton;
@property (nonatomic, strong) IBOutlet FXLabel *optionsButtonLabel;
@property (nonatomic, strong) IBOutlet UIView *instructionsButtonView;
@property (nonatomic, strong) IBOutlet UIButton *instructionsButton;
@property (nonatomic, strong) IBOutlet FXLabel *instructionsButtonLabel;
@property (nonatomic, strong) IBOutlet UIView *aboutButtonView;
@property (nonatomic, strong) IBOutlet UIButton *aboutButton;
@property (nonatomic, strong) IBOutlet FXLabel *aboutButtonLabel;
@property (nonatomic, strong) IBOutlet UIImageView *titleLabel;
@property (nonatomic, strong) IBOutlet UIImageView *titleBar;

//Custom alert view replacement properties
@property (nonatomic, strong) IBOutlet UIButton *alertViewNewGameButton;
@property (nonatomic, strong) IBOutlet FXLabel *alertViewNewGameButtonLabel;
@property (nonatomic, strong) IBOutlet UIButton *alertViewContinueGameButton;
@property (nonatomic, strong) IBOutlet FXLabel *alertViewContinueGameButtonLabel;
@property (nonatomic, strong) IBOutlet UIButton *alertViewCancelButton;
@property (nonatomic, strong) IBOutlet FXLabel *alertViewCancelButtonLabel;
@property (nonatomic, strong) IBOutlet UIView *alertViewMainView;
@property (nonatomic, strong) IBOutlet UIView *alertViewOverlay;

//Options properties
@property (nonatomic, strong) UIView *optionsOverlay;
@property (nonatomic, strong) UIImageView *optionsView;
@property (nonatomic, strong) UISwitch *optionsAccelerometerSwitch;
@property (nonatomic, strong) DGOptionItem *optionItemAccelerometer;
@property (nonatomic, strong) UISwitch *optionsVibrationSwitch;
@property (nonatomic, strong) DGOptionItem *optionItemVibration;

//Main methods
- (IBAction)showGameView:(id)sender;
- (IBAction)showOptionsDropdown:(id)sender;
- (IBAction)showInstructionsView:(id)sender;
- (IBAction)showAboutView:(id)sender;
- (void)animateTitleInWithDuration:(double )duration;
- (void)animateTitleOutWithViewController:(UIViewController *)theViewController withDuration:(double )duration;
- (void)animateButtonIn:(id)sender;

//Options methods
- (void)optionsToggledAccelerometer:(id)sender;
- (void)optionsToggledVibration:(id)sender;
- (void)overlayTapped:(id)sender;
- (void)refreshOptionsView;

//Alert view methods
- (IBAction)alertViewNewButtonTapped:(id)sender;
- (IBAction)alertViewContinueButtonTapped:(id)sender;
- (IBAction)alertViewCancelButtonTapped:(id)sender;

@end
