//
//  MainViewController.m
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

#import "MainViewController.h"
#import "GameViewController.h"
#import "InstructionsViewController.h"
#import "AboutViewController.h"
#import "DGAlertView.h"

@implementation MainViewController

@synthesize gameButtonView = _gameButtonView,
        gameButton = _gameButton,
        gameButtonLabel = _gameLabel,
        optionsButtonView = _optionsButtonView,
        optionsButton = _optionsButton,
        optionsButtonLabel = _optionsLabel,
        instructionsButtonView = _instructionsButtonView,
        instructionsButton = _instructionsButton,
        instructionsButtonLabel = _instructionsLabel,
        aboutButtonView = _aboutButtonView,
        aboutButton = _aboutButton,
        aboutButtonLabel = _aboutLabel,
        titleLabel = _titleLabel,
        titleBar = _titleBar,
        alertView = _alertView;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    //Setup animation/prefs for title
    [self animateTitleInWithDuration:0.3];
    
    //Alert view setup
    self.alertView = [[DGAlertView alloc] init];
    [self.alertView setupAlertViewWithSender:self];
    [self.alertView setOverlayOpacity:0.4];
    [self.alertView setTopButtonText:@"New Game"];
    [self.alertView setMiddleButtonText:@"Continue Game"];
    [self.alertView setBottomButtonText:@"Back"];
    
    //Set default style for all FXLabels in the view
    for (FXLabel *label in [self.view allSubviews]) {
        if ([label isKindOfClass:[FXLabel class]]) {
            setDefaultStyleUsingLabel(label);
        }
    }
    
    //Animate in buttons
    [self performSelector:@selector(animateButtonIn:) withObject:self.gameButtonView afterDelay:0.4];
    [self performSelector:@selector(animateButtonIn:) withObject:self.optionsButtonView afterDelay:0.55];
    [self performSelector:@selector(animateButtonIn:) withObject:self.instructionsButtonView afterDelay:0.7];
    [self performSelector:@selector(animateButtonIn:) withObject:self.aboutButtonView afterDelay:0.85];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [self performSelector:@selector(animateTitleInWithDuration:) withObject:nil afterDelay:0.3];
    
    //Options view setup
    [[DGOptionsDropdown sharedInstance] refreshOptionsView];
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[[DGOptionsDropdown sharedInstance] refreshOptionsView];
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Animation

- (void)animateTitleInWithDuration:(double )duration {
    //If duration hasn't been set (if it's zero), set it to 0.3
    if (!duration || duration < 0.3) {
        duration = 0.3;
    }
    
    //Move title background down & fade in title
    [UIView animateWithDuration:duration animations:^{
        [self.titleBar setFrame:CGRectMake(0, 0, 320, 76)];
        self.titleLabel.alpha = 1.0;
        self.gameButtonView.alpha = 1.0;
        self.optionsButtonView.alpha = 1.0;
        self.instructionsButtonView.alpha = 1.0;
        self.aboutButtonView.alpha = 1.0;
    } completion:^ (BOOL finished) {
        //Enable Buttons
        self.gameButton.enabled = YES;
        self.optionsButton.enabled = YES;
        self.instructionsButton.enabled = YES;
        self.aboutButton.enabled = YES;
        
        //Refresh options view
        [[DGOptionsDropdown sharedInstance] refreshOptionsView];
        [[DGOptionsDropdown sharedInstance] setAnchor:self.titleBar];
        [[DGOptionsDropdown sharedInstance] setOptionsButton:self.optionsButton];
        [[DGOptionsDropdown sharedInstance] setViewsToHide:nil];
    }];
}

- (void)animateTitleOutWithViewController:(UIViewController *)theViewController withDuration:(double )duration {    
    //Disable Buttons
    self.gameButton.enabled = NO;
    self.optionsButton.enabled = NO;
    self.instructionsButton.enabled = NO;
    self.aboutButton.enabled = NO;
    
    //Move title background up & fade out title
    [UIView animateWithDuration:duration animations:^{
        [self.titleBar setFrame:CGRectMake(0, 0, 320, 42)];
        self.titleLabel.alpha = 0.0;
        self.gameButtonView.alpha = 0.0;
        self.optionsButtonView.alpha = 0.0;
        self.instructionsButtonView.alpha = 0.0;
        self.aboutButtonView.alpha = 0.0;
    } completion:^ (BOOL finished) {
        [self.navigationController pushViewController:theViewController animated:YES];
    }];
}

- (void)animateButtonIn:(id)sender {
    UIButton *button = sender;
    
    [button setAlpha:0.0];
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationCurveEaseOut animations:^{
        [button setFrame:CGRectOffset(button.frame, -320, 0)];
        [button setAlpha:1.0];
    }completion:^(BOOL finished) {}];
}

#pragma mark - Game View

- (IBAction)showGameView:(id)sender {
    //Zeros out bools for new or saved game
    
    [prefs setBool:NO forKey:@"NEW_GAME"];
    [prefs setBool:NO forKey:@"CONTINUE_GAME"];
    
    //And display the DGAlertView if there's a game to continue, otherwise just continue with a new game
    if ([prefs valueForKey:@"CURRENT_QUESTION"]) {
        [self.alertView displayAlertViewWithDelay:0.3];
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
            self.gameButtonView.alpha = 0.0;
            self.optionsButtonView.alpha = 0.0;
            self.instructionsButtonView.alpha = 0.0;
            self.aboutButtonView.alpha = 0.0;
        } completion:^ (BOOL finished) {}];
    }
    
    else {
        [self alertViewTopBottomTapped:self];
    }
}

#pragma mark - Options View

- (IBAction)showOptionsDropdown:(id)sender {
    [[DGOptionsDropdown sharedInstance] slideOptionsWithDuration:0.3];
}


#pragma mark Alert View
- (void)willChangeValueForKey:(NSString *)key {
    if (key == @"DGAlertViewTopButtonTapped") {
        [self alertViewTopBottomTapped:self];
    }
    if (key == @"DGAlertViewMiddleButtonTapped") {
        [self alertViewMiddleButtonTapped:self];
    }
    if (key == @"DGAlertViewBottomButtonTapped") {
        [self alertViewBottomButtonTapped:self];
    }
}

- (void)alertViewTopBottomTapped:(id)sender {    
    //Start new game    
    [prefs setBool:YES forKey:@"NEW_GAME"];
    [prefs setBool:NO forKey:@"CONTINUE_GAME"];
    
    //If there is a value for the current question, dismiss the alert view since that signifies the alert view was shown, and clear the value
    if ([prefs valueForKey:@"CURRENT_QUESTION"]) {
        [self.alertView dismissAlertView];
        [prefs setValue:nil forKey:@"CURRENT_QUESTION"];
    }
    
    //Init a game view controller and call animateTitleOut
    GameViewController *gameViewController = [[GameViewController alloc] initWithNibName:@"GameViewController" bundle:nil];
    [self animateTitleOutWithViewController:gameViewController withDuration:0.3];
}

- (void)alertViewMiddleButtonTapped:(id)sender {
    //Continue game
    [prefs setBool:YES forKey:@"CONTINUE_GAME"];
    [prefs setBool:NO forKey:@"NEW_GAME"];
    [self.alertView dismissAlertView];
    
    //Init a game view controller and call animateTitleOut
    GameViewController *gameViewController = [[GameViewController alloc] initWithNibName:@"GameViewController" bundle:nil];
    [self animateTitleOutWithViewController:gameViewController withDuration:0.3];
}

- (void)alertViewBottomButtonTapped:(id)sender {
    [self.alertView dismissAlertView];
    [UIView animateWithDuration:0.2 delay:0.3 options:UIViewAnimationCurveEaseInOut animations:^{
        self.gameButtonView.alpha = 1.0;
        self.optionsButtonView.alpha = 1.0;
        self.instructionsButtonView.alpha = 1.0;
        self.aboutButtonView.alpha = 1.0;
    } completion:^ (BOOL finished) {}];
}

#pragma mark - Instructions View

- (IBAction)showInstructionsView:(id)sender {
    InstructionsViewController *instructionsViewController = [[InstructionsViewController alloc] initWithNibName:@"InstructionsViewController" bundle:nil];
    
    //Custom method to animate the title and push view controller given
    [self animateTitleOutWithViewController:instructionsViewController withDuration:0.3];    
}

#pragma mark - About View

- (IBAction)showAboutView:(id)sender {
    AboutViewController *aboutViewController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
    
    //Custom method to animate the title and push view controller given
    [self animateTitleOutWithViewController:aboutViewController withDuration:0.3];
}

@end
