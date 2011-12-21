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
#import "DGActionSheet.h"

@implementation MainViewController

@synthesize gameButton = _gameButton,
        optionsButton = _optionsButton,
        instructionsButton = _instructionsButton,
        aboutButton = _aboutButton,
        titleLabel = _titleLabel,
        titleBar = _titleBar,
        actionSheetNewGameButton = _actionSheetNewGameButton,
        actionSheetContinueGameButton = _actionSheetContinueGameButton,
        actionSheetCancelButton = _actionSheetCancelButton,
        actionSheetMainView = _actionSheetMainView,
        actionSheetOverlay = _actionSheetOverlay,
        optionsOverlay = _optionsOverlay,
        optionsView = _optionsView,
        optionsAccelerometerSwitch = _optionsAccelerometerSwitch,
        optionItemAccelerometer = _optionItemAccelerometer,
        optionsVibrationSwitch = _optionsVibrationSwitch,
        optionItemVibration = _optionItemVibration;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    //Setup animation/prefs for title
    [self animateTitleInWithDuration:0.3];
    
    //Set up options view
    [self refreshOptionsView];
    
    //Action sheet setup
    [DGActionSheet 
     setupActionSheet:self.actionSheetMainView
     overlay:self.actionSheetOverlay
     newGameButton:self.actionSheetNewGameButton 
     continueGameButton:self.actionSheetContinueGameButton 
     cancelButton:self.actionSheetCancelButton 
     inView:self.view];
    UITapGestureRecognizer *overlayTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionSheetCancelButtonTapped:)];
    [self.actionSheetOverlay addGestureRecognizer:overlayTapGestureRecognizer];
    
    //Set button styles
    
    //Animate in buttons
    [self performSelector:@selector(animateButtonIn:) withObject:self.gameButton afterDelay:0.4];
    [self performSelector:@selector(animateButtonIn:) withObject:self.optionsButton afterDelay:0.55];
    [self performSelector:@selector(animateButtonIn:) withObject:self.instructionsButton afterDelay:0.7];
    [self performSelector:@selector(animateButtonIn:) withObject:self.aboutButton afterDelay:0.85];
    
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
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[DGOptionsDropdown refreshOptionView:self.optionsView withOptionItem:self.optionItemAccelerometer withOverlay:self.optionsOverlay];
    [DGOptionsDropdown refreshOptionView:self.optionsView withOptionItem:self.optionItemVibration withOverlay:self.optionsOverlay];
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
        self.gameButton.alpha = 1.0;
        self.optionsButton.alpha = 1.0;
        self.instructionsButton.alpha = 1.0;
        self.aboutButton.alpha = 1.0;
    } completion:^ (BOOL finished) {
        //Enable Buttons
        self.gameButton.enabled = YES;
        self.optionsButton.enabled = YES;
        self.instructionsButton.enabled = YES;
        self.aboutButton.enabled = YES;
        
        //Refresh options view
        [DGOptionsDropdown refreshOptionView:self.optionsView withOptionItem:self.optionItemAccelerometer withOverlay:self.optionsOverlay];
        [DGOptionsDropdown refreshOptionView:self.optionsView withOptionItem:self.optionItemVibration withOverlay:self.optionsOverlay];
        [self refreshOptionsView];
    }];
}

- (void)animateTitleOutWithViewController:(UIViewController *)theViewController withDuration:(double )duration {
    //Get rid of option views
    [self.optionsView removeFromSuperview];
    [self.optionsOverlay removeFromSuperview];
    
    //Disable Buttons
    self.gameButton.enabled = NO;
    self.optionsButton.enabled = NO;
    self.instructionsButton.enabled = NO;
    self.aboutButton.enabled = NO;
    
    //Move title background up & fade out title
    [UIView animateWithDuration:duration animations:^{
        [self.titleBar setFrame:CGRectMake(0, 0, 320, 42)];
        self.titleLabel.alpha = 0.0;
        self.gameButton.alpha = 0.0;
        self.optionsButton.alpha = 0.0;
        self.instructionsButton.alpha = 0.0;
        self.aboutButton.alpha = 0.0;
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
    
    //And display the DGActionSheet if there's a game to continue, otherwise just continue with a new game
    if ([prefs valueForKey:@"CURRENT_QUESTION"]) {
        [DGActionSheet displayActionSheet:self.actionSheetMainView overlay:self.actionSheetOverlay];
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
            self.gameButton.alpha = 0.0;
            self.optionsView.alpha = 0.0;
            self.instructionsButton.alpha = 0.0;
            self.aboutButton.alpha = 0.0;
        } completion:^ (BOOL finished) {}];
    }
    
    else {
        [self actionSheetNewButtonTapped:self];
    }
}

#pragma mark Action Sheet

- (IBAction)actionSheetNewButtonTapped:(id)sender {    
    //Start new game    
    [prefs setBool:YES forKey:@"NEW_GAME"];
    [prefs setBool:NO forKey:@"CONTINUE_GAME"];
    
    //If there is a value for the current question, dismiss the action sheet since that signifies the action sheet was shown, and clear the value
    if ([prefs valueForKey:@"CURRENT_QUESTION"]) {
        [DGActionSheet dismissActionSheet:self.actionSheetMainView overlay:self.actionSheetOverlay];
        [prefs setValue:nil forKey:@"CURRENT_QUESTION"];
    }
    
    //Init a game view controller and call animateTitleOut
    GameViewController *gameViewController = [[GameViewController alloc] initWithNibName:@"GameViewController" bundle:nil];
    [self animateTitleOutWithViewController:gameViewController withDuration:0.3];
}

- (IBAction)actionSheetContinueButtonTapped:(id)sender {
    //Continue game
    [prefs setBool:YES forKey:@"CONTINUE_GAME"];
    [prefs setBool:NO forKey:@"NEW_GAME"];
    [DGActionSheet dismissActionSheet:self.actionSheetMainView overlay:self.actionSheetOverlay];
    
    //Init a game view controller and call animateTitleOut
    GameViewController *gameViewController = [[GameViewController alloc] initWithNibName:@"GameViewController" bundle:nil];
    [self animateTitleOutWithViewController:gameViewController withDuration:0.3];
}

- (IBAction)actionSheetCancelButtonTapped:(id)sender {
    [DGActionSheet dismissActionSheet:self.actionSheetMainView overlay:self.actionSheetOverlay];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
        self.gameButton.alpha = 1.0;
        self.optionsView.alpha = 1.0;
        self.instructionsButton.alpha = 1.0;
        self.aboutButton.alpha = 1.0;
    } completion:^ (BOOL finished) {}];
}

#pragma mark - Options Dropdown

- (void)refreshOptionsView {
    //Reset options
    [DGOptionsDropdown resetOptions];
     
    //Options views setup
    self.optionsOverlay = [[UIView alloc] initWithFrame:CGRectZero];
    self.optionsView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [DGOptionsDropdown setupOptionsViewsWithAnchorView:self.titleBar overlay:self.optionsOverlay optionView:self.optionsView backgroundImage:[UIImage imageNamed:@"OptionsBackground"]];
    
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
}

- (IBAction)showOptionsDropdown:(id)sender {
    [DGOptionsDropdown 
     slideOptionsWithDuration:0.3
     viewController:self 
     anchorView:self.titleBar
     theOptionsView:self.optionsView
     overlay:self.optionsOverlay
     backgroundImage:[UIImage imageNamed:@"OptionsBackground"]
     overlayAmount:0.6
     optionsButton:nil
     backButton:nil];
    
    //Tap gesture recognizers so that anywhere onscreen minus the options view itself will close the options view
    UITapGestureRecognizer *overlayTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(overlayTapped:)];
    UITapGestureRecognizer *titleLabelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(overlayTapped:)];
    UITapGestureRecognizer *titleBarTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(overlayTapped:)];
    
    if ([prefs boolForKey:@"OPTIONS_HIDDEN"]) {
        [self.optionsOverlay addGestureRecognizer:overlayTapGestureRecognizer];
        self.titleLabel.userInteractionEnabled = YES;
        [self.titleLabel addGestureRecognizer:titleLabelTapGestureRecognizer];
        self.titleBar.userInteractionEnabled = YES;
        [self.titleBar addGestureRecognizer:titleBarTapGestureRecognizer];
    }
    else {
        [self.optionsOverlay removeGestureRecognizer:overlayTapGestureRecognizer];
        self.titleLabel.userInteractionEnabled = NO;
        [self.titleLabel removeGestureRecognizer:titleLabelTapGestureRecognizer];
        self.titleBar.userInteractionEnabled = NO;
        [self.titleBar removeGestureRecognizer:titleBarTapGestureRecognizer];
    }
    
}

- (void)optionsToggledAccelerometer:(id)sender {
    [DGOptionsDropdown optionsToggledWithSwitch:self.optionsAccelerometerSwitch withTitle:@"Accelerometer"];
}

- (void)optionsToggledVibration:(id)sender {
    [DGOptionsDropdown optionsToggledWithSwitch:self.optionsVibrationSwitch withTitle:@"Vibration"];
}

- (void)overlayTapped:(id)sender {
    [self showOptionsDropdown:self];
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
