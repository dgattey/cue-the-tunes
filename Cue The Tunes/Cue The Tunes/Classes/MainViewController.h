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

#import "DGAlertView.h"
#import "DGOptionsDropdown.h"

@interface MainViewController : UIViewController {
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
    UIView *_notesView;
    UIImage *_noteImage1;
    UIImage *_noteImage2;
    BOOL noteImageNumber;
    NSTimer *_spawnTimer;
    DGAlertView *_alertView;
}

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
@property (nonatomic, strong) IBOutlet UIView *notesView;
@property (nonatomic, strong) UIImage *noteImage1;
@property (nonatomic, strong) UIImage *noteImage2;
@property (nonatomic, strong) NSTimer *spawnTimer;
@property (nonatomic, strong) DGAlertView *alertView;

- (IBAction)showGameView:(id)sender;
- (IBAction)showOptionsDropdown:(id)sender;
- (IBAction)showInstructionsView:(id)sender;
- (IBAction)showAboutView:(id)sender;
- (void)animateTitleInWithDuration:(double )duration;
- (void)animateTitleOutWithViewController:(UIViewController *)theViewController withDuration:(double )duration;
- (void)animateButtonIn:(id)sender;
- (void)spawnNoteOnTimer;
- (void)refreshNotesView;
- (void)alertViewTopBottomTapped:(id)sender;
- (void)alertViewMiddleButtonTapped:(id)sender;
- (void)alertViewBottomButtonTapped:(id)sender;

@end
