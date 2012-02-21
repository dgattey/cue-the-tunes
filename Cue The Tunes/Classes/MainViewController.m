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
#import <CoreGraphics/CoreGraphics.h>

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
        alertView = _alertView,
        notesView = _notesView,
        noteImage1 = _noteImage1,
        noteImage2 = _noteImage2,
        spawnTimer = _spawnTimer;

- (void)didReceiveMemoryWarning {
    /* --------------------------------------------------
      *  Invalidate the timer if a memory warning is recieved
      *  -------------------------------------------------- */
    [self.spawnTimer invalidate];
    [super didReceiveMemoryWarning];
}

/* ------------------------------------ */
   # pragma mark - View lifecycle
/* ------------------------------------ */


- (void)viewDidLoad {
    /* -------------------------------------------------------
      *  Load the two different note images and set bool to begin
      *  Begin animation in of the title
      *  ------------------------------------------------------- */
	self.noteImage1 = [UIImage imageNamed:@"Note1"];
    self.noteImage2 = [UIImage imageNamed:@"Note2"];
    noteImageNumber = NO;
    [self animateTitleInWithDuration:0.3];
    
    /* ----------------------------------------------
      *  Create a DGAlertView
      *  Set properties and titles relative to view
      *  Set default style for all FXLabels
      *  ---------------------------------------------- */
    self.alertView = [[DGAlertView alloc] init];
    [self.alertView setupAlertViewWithSender:self];
    [self.alertView setOverlayOpacity:0.4];
    [self.alertView setTopButtonText:@"New Game"];
    [self.alertView setMiddleButtonText:@"Continue Game"];
    [self.alertView setBottomButtonText:@"Back"];
    
    for (FXLabel *label in [self.view allSubviews]) {
        if ([label isKindOfClass:[FXLabel class]]) {
            setDefaultStyleUsingLabel(label);
        }
    }
    
    /* ------------------------------------------------------------------
      *  Finally, animate in each button, with a progressive delay of 0.15 secs
      *  ------------------------------------------------------------------ */
    [self performSelector:@selector(animateButtonIn:) withObject:self.gameButtonView afterDelay:0.4];
    [self performSelector:@selector(animateButtonIn:) withObject:self.optionsButtonView afterDelay:0.55];
    [self performSelector:@selector(animateButtonIn:) withObject:self.instructionsButtonView afterDelay:0.7];
    [self performSelector:@selector(animateButtonIn:) withObject:self.aboutButtonView afterDelay:0.85];
    
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    /* --------------------------------------------------------------
      *  Animate the title in with a 0.3 sec delay
      *  Make the notes view opaque and set the timer to spawn notes
      *  Call the global instance to refresh the options view
      *  Add observer to refresh the notes view when foreground
      *  -------------------------------------------------------------- */
    [self performSelector:@selector(animateTitleInWithDuration:) withObject:nil afterDelay:0.3];
    self.notesView.alpha = 1.0;
    self.spawnTimer = [NSTimer scheduledTimerWithTimeInterval:(0.2) target:self selector:@selector(spawnNoteOnTimer) userInfo:nil repeats:YES];
    [[DGOptionsDropdown sharedInstance] refreshOptionsView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNotesView) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	/* -------------------------------------------------
      *  Call the global instance to refresh the options view
      *  Remove observer
      *  ------------------------------------------------- */
    [[DGOptionsDropdown sharedInstance] refreshOptionsView];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    /* ----------------------------------------------
      *  Only allow rotation to portrait orientation
      *  ---------------------------------------------- */
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)refreshNotesView {
    /* ----------------------------------------------
      *  Refreshes the notes view to prevent pause
      *  ---------------------------------------------- */
    self.notesView.alpha = 0;
    [UIView animateWithDuration:0.4 animations:^{
        self.notesView.alpha = 1;
    }];
}

/* ------------------------------------ */
   # pragma mark - Animation
/* ------------------------------------ */


- (void)animateTitleInWithDuration:(double)duration {
    /* ----------------------------------------------
      *  Method to fade in the title and expand the bar
      *  Set default duration to 0.3 seconds
      *  ---------------------------------------------- */
    if (!duration || duration < 0.3) {
        duration = 0.3;
    }
    
    /* -------------------------------------------------------
      *  With the passed in duration, expand the title background
      *  Also fade in all buttons and the title label
      *  ------------------------------------------------------- */
    [UIView animateWithDuration:duration animations:^{
        [self.titleBar setFrame:CGRectMake(0, 0, 320, 76)];
        self.titleLabel.alpha = 1.0;
        self.gameButtonView.alpha = 1.0;
        self.optionsButtonView.alpha = 1.0;
        self.instructionsButtonView.alpha = 1.0;
        self.aboutButtonView.alpha = 1.0;
    } completion:^ (BOOL finished) {
        /* ----------------------------------------------
            *  Once completed, enable all buttons
            *  ---------------------------------------------- */
        self.gameButton.enabled = YES;
        self.optionsButton.enabled = YES;
        self.instructionsButton.enabled = YES;
        self.aboutButton.enabled = YES;
        
        /* -------------------------------------------------
            *  Call the global instance to refresh the options view
            *  Set all properties for the options instance
            *  ------------------------------------------------- */
        [[DGOptionsDropdown sharedInstance] refreshOptionsView];
        [[DGOptionsDropdown sharedInstance] setAnchor:self.titleBar];
        [[DGOptionsDropdown sharedInstance] setOptionsButton:self.optionsButton];
        [[DGOptionsDropdown sharedInstance] setViewsToHide:nil];
    }];
}

- (void)animateTitleOutWithViewController:(UIViewController *)theViewController withDuration:(double )duration {    
    /* -------------------------------------------------
      *  Method to fade out the title and contract the bar
      *  Disable the buttons to stop multiple calls of method
      *  ------------------------------------------------- */
    self.gameButton.enabled = NO;
    self.optionsButton.enabled = NO;
    self.instructionsButton.enabled = NO;
    self.aboutButton.enabled = NO;
    
    /* -------------------------------------------------------
      *  With the passed in duration, contract the title background
      *  Fade out all buttons, the title label, and the notes view
      *  Also invalidate the note spawning timer
      *  ------------------------------------------------------- */
    [UIView animateWithDuration:duration animations:^{
        [self.titleBar setFrame:CGRectMake(0, 0, 320, 42)];
        self.titleLabel.alpha = 0.0;
        self.gameButtonView.alpha = 0.0;
        self.optionsButtonView.alpha = 0.0;
        self.instructionsButtonView.alpha = 0.0;
        self.aboutButtonView.alpha = 0.0;
        [self.notesView setAlpha:0];
        [self.spawnTimer invalidate];
    } completion:^ (BOOL finished) {
        /* --------------------------------------------------
            *  Once completed, push the passed in view controller
            *  -------------------------------------------------- */
        [self.navigationController pushViewController:theViewController animated:YES];
    }];
}

- (void)animateButtonIn:(id)sender {
    /* ----------------------------------------------------------
      *  Set the alpha of the sender (assuming UIButton) to zero
      *  Over 0.5 seconds, move it left 320 px (onscreen) and fade in
      *  ---------------------------------------------------------- */
    [sender setAlpha:0.0];
    [UIView animateWithDuration:0.5 animations:^{
        [sender setFrame:CGRectOffset([sender frame], -320, 0)];
        [sender setAlpha:1.0];
    }];   
}

- (void)spawnNoteOnTimer {
	/* --------------------------------------------------
      *  Use the screen width to randomize start and end x
      *  Randomize a scale, speed, and rotation too
      *  Scale and speed are between 1.0 and 1.5
      *  Rotation is between -20° and 20°
      *  -------------------------------------------------- */
    int screenWidth = roundf([UIScreen mainScreen].bounds.size.width);
    int startX = round(random() % screenWidth);
    int endX = round(random() % screenWidth);
	double scale = 1 / round(random() % 50) + 1.0f;
	double speed = 1 / round(random() % 100) + 1.0f;
    double rotation = round(arc4random() % 40) - 20;
    DLog(@"Scale: %f, Speed: %f, Rotation: %f", scale, speed, rotation);
    
    /* ---------------------------------------------------------------
      *  Create note view, with image either double or single eighth notes
      *  Set frame based on startX and screen height + 40
      *  Set transformation with the scale
      *  Add the new note to the notes view
      *  --------------------------------------------------------------- */
    __block UIImageView* noteView = [[UIImageView alloc] initWithFrame:CGRectMake(startX, [UIScreen mainScreen].bounds.size.height+ 40, 20, 20)];
    if (noteImageNumber) {
        [noteView setImage:self.noteImage1];
    }
    else {
        [noteView setImage:self.noteImage2];   
    }
    noteImageNumber = !noteImageNumber;
    noteView.transform = CGAffineTransformScale(noteView.transform, scale, scale);
	noteView.alpha = 0.5;
	[self.notesView addSubview:noteView];
    
    /* -----------------------------------------------------
      *  Fade out note over 9*speed sec, with a 2.8 sec delay
      *  Rotate and move note to endX over 12*speed sec
      *  Destroy view once finished
      *  ----------------------------------------------------- */
    [UIView animateWithDuration:9*speed delay:2.8 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        noteView.alpha = 0;
    }completion:^(BOOL finished) {}];
    
	[UIView animateWithDuration:12*speed delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        noteView.transform = CGAffineTransformRotate(CGAffineTransformTranslate(noteView.transform, endX+startX-screenWidth, -[UIScreen mainScreen].bounds.size.height - 40), rotation / 180.0f * M_PI);
    } completion:^(BOOL finished) {
        if (finished) {
            [noteView removeFromSuperview];
            noteView = nil;
        }
    }];
}

/* ------------------------------------ */
   # pragma mark - Button methods
/* ------------------------------------ */

- (IBAction)showGameView:(id)sender {
    /* ---------------------------------------------------------------------
      *  Method to show the game view from click on play button
      *  Set the continue and new game bools to no
      *  If there's a game already, display DGAlertView and hide buttons
      *  Otherwise, just assume the top button was tapped, and start new game
      *  --------------------------------------------------------------------- */
    [prefs setBool:NO forKey:@"NEW_GAME"];
    [prefs setBool:NO forKey:@"CONTINUE_GAME"];
    
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

- (IBAction)showOptionsDropdown:(id)sender {
    /* -------------------------------------------------
      *  Method to show or hide the DGOptionsDropdown
      *  Call global instance to slide the options up or down
      *  ------------------------------------------------- */
    [[DGOptionsDropdown sharedInstance] slideOptionsWithDuration:0.3];
}

- (IBAction)showInstructionsView:(id)sender {
    /* ----------------------------------------------------------------------
      *  Method to show the instructions view from a tap on the button
      *  Create a view controller and animate the title out with it (custom method)
      *  ---------------------------------------------------------------------- */
    InstructionsViewController *instructionsViewController = [[InstructionsViewController alloc] initWithNibName:@"InstructionsViewController" bundle:nil];
    [self animateTitleOutWithViewController:instructionsViewController withDuration:0.3];    
}

- (IBAction)showAboutView:(id)sender {
    /* ----------------------------------------------------------------------
      *  Method to show the about view from a tap on the button
      *  Create a view controller and animate the title out with it (custom method)
      *  ---------------------------------------------------------------------- */
    AboutViewController *aboutViewController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
    [self animateTitleOutWithViewController:aboutViewController withDuration:0.3];
}

/* ----------------------------------------------- */
   # pragma mark - DGAlertView delegate methods
/* ----------------------------------------------- */

- (void)willChangeValueForKey:(NSString *)key {
    /* ----------------------------------------------
      *  Listen for KVC of DGAlertView keys
      *  Based on button tapped, call relative method
      *  ---------------------------------------------- */
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
    /* ---------------------------------------------------------------------------
      *  Called to begin a new game
      *  Set appropriate bools and nil the current question/hide the alert view if needed
      *  Animate the title out with a game view controller
      *  --------------------------------------------------------------------------- */
    [prefs setBool:YES forKey:@"NEW_GAME"];
    [prefs setBool:NO forKey:@"CONTINUE_GAME"];
    if ([prefs valueForKey:@"CURRENT_QUESTION"]) {
        [self.alertView dismissAlertView];
        [prefs setValue:nil forKey:@"CURRENT_QUESTION"];
    }
    GameViewController *gameViewController = [[GameViewController alloc] initWithNibName:@"GameViewController" bundle:nil];
    [self animateTitleOutWithViewController:gameViewController withDuration:0.3];
}

- (void)alertViewMiddleButtonTapped:(id)sender {
    /* -----------------------------------------------
      *  Called to continue the game
      *  Set appropriate bools and hide the alert view
      *  Animate the title out with a game view controller
      *  ----------------------------------------------- */
    [prefs setBool:YES forKey:@"CONTINUE_GAME"];
    [prefs setBool:NO forKey:@"NEW_GAME"];
    [self.alertView dismissAlertView];
    GameViewController *gameViewController = [[GameViewController alloc] initWithNibName:@"GameViewController" bundle:nil];
    [self animateTitleOutWithViewController:gameViewController withDuration:0.3];
}

- (void)alertViewBottomButtonTapped:(id)sender {
    /* ----------------------------------------------
      *  Called to cancel and hide the alert view
      *  Dismiss the alert view, then animate buttons in
      *  ---------------------------------------------- */
    [self.alertView dismissAlertView];
    [UIView animateWithDuration:0.2 delay:0.3 options:UIViewAnimationCurveEaseInOut animations:^{
        self.gameButtonView.alpha = 1.0;
        self.optionsButtonView.alpha = 1.0;
        self.instructionsButtonView.alpha = 1.0;
        self.aboutButtonView.alpha = 1.0;
    } completion:^ (BOOL finished) {}];
}

 @end
