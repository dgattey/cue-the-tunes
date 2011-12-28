//
//  DGAlertView.m
//  DGAlertView
//
//  Created by Dylan Gattey on 8/15/11.
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

#import "DGAlertView.h"

@implementation DGAlertView

/* ----------------------------------------------
 *  Set up constant sizes used throughout
 *  ---------------------------------------------- */

#define kButtonWidth 160
#define kButtonHeight 40
#define kFramePoint CGPointMake(50, 164)
#define kFrameSize CGSizeMake(220, 220)

@synthesize overlay = _overlay, parentViewController = _parentViewController, topButton = _topButton, topButtonLabel = _topButtonLabel, middleButton = _middleButton, middleButtonLabel = _middleButtonLabel, bottomButton = _bottomButton, bottomButtonLabel = _bottomButtonLabel;

/* ------------------------------------ */
   # pragma mark - Setup and Display
/* ------------------------------------ */

- (void)setupAlertViewWithSender:(id)sender {
    /* --------------------------------------------------------
      *  Take the sender & make it the parent view
      *  Set up the main view and background view inside it
      *  Also initiate the overlay and set up a gesture recognizer
      *  -------------------------------------------------------- */
    DLog(@"Start setting up alert view");
    if (sender) {
        self.parentViewController = sender;
        DLog(@"Sender: %@", sender);
    }
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    self.frame = CGRectMake(kFramePoint.x, kFramePoint.y, kFrameSize.width, kFrameSize.height);
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ActionSheetBackground"]];
    backgroundImageView.frame = CGRectMake(0, 0, kFrameSize.width, kFrameSize.height);
    [self addSubview:backgroundImageView];
    
    self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
    self.overlay.backgroundColor = [UIColor blackColor];
    self.overlay.userInteractionEnabled = YES;
    UITapGestureRecognizer *overlayTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomButtonTapped:)];
    [self.overlay addGestureRecognizer:overlayTapGestureRecognizer];
    
    /* ----------------------------------------------------------
      *  Set up sizes, tags, images, label styles for all three buttons
      *  Add targets and selectors for all three too
      *  ---------------------------------------------------------- */
    self.topButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 30, kButtonWidth, kButtonHeight)];
    [self.topButton setBackgroundImage:[UIImage imageNamed:@"ActionSheetRedButton"] forState:UIControlStateNormal];
    [self.topButton setTag:1];
    self.topButtonLabel = [[FXLabel alloc] initWithFrame:self.topButton.frame];
    setDefaultStyleUsingLabel(self.topButtonLabel);
    [self.topButtonLabel setTag:1];
    
    self.middleButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 90, kButtonWidth, kButtonHeight)];
    [self.middleButton setBackgroundImage:[UIImage imageNamed:@"ActionSheetGreenButton"] forState:UIControlStateNormal];
    [self.middleButton setTag:2];
    self.middleButtonLabel = [[FXLabel alloc] initWithFrame:self.middleButton.frame];
    setDefaultStyleUsingLabel(self.middleButtonLabel);
    [self.middleButtonLabel setTag:2];
    
    self.bottomButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 150, kButtonWidth, kButtonHeight)];
    [self.bottomButton setBackgroundImage:[UIImage imageNamed:@"ActionSheetBlueButton"] forState:UIControlStateNormal];
    [self.bottomButton setTag:3];
    self.bottomButtonLabel = [[FXLabel alloc] initWithFrame:self.bottomButton.frame];
    setDefaultStyleUsingLabel(self.bottomButtonLabel);
    [self.bottomButtonLabel setTag:3];
    
    [self.topButton addTarget:self action:@selector(topButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.middleButton addTarget:self action:@selector(middleButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomButton addTarget:self action:@selector(bottomButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    /* ------------------------------------------------------------
      *  If there's actually a parent view controller, add the views to it
      *  ------------------------------------------------------------ */
    if (self.parentViewController) {
        DLog(@"Views being added to %@", self.parentViewController);
        [self.parentViewController.view addSubview:self.overlay];
        [self addSubview:self.topButton];
        [self addSubview:self.topButtonLabel];
        [self addSubview:self.middleButton];
        [self addSubview:self.middleButtonLabel];
        [self addSubview:self.bottomButton];
        [self addSubview:self.bottomButtonLabel];
        [self.parentViewController.view addSubview:self];
    }
    
    /* ----------------------------------------------
      *  And finally, hide the views for later
      *  ---------------------------------------------- */
    self.alpha = 0.0;
    self.overlay.alpha = 0.0;
}

- (void)displayAlertViewWithDelay:(float)delay {        
    /* ----------------------------------------------------------------
     *  Fade in the alert view over 0.4 seconds with the passed-in delay
     *  Set overlay opacity to 0.6 if not already set
     *  ---------------------------------------------------------------- */
    if (!delay) {
        delay = 0;
    }
    DLog(@"Delay: %f", delay);
    
    [UIView animateWithDuration:0.4 delay:delay options:UIViewAnimationCurveEaseInOut animations:^{
        if (overlayOpacity) {
            self.overlay.alpha = overlayOpacity;
            DLog(@"Overlay opacity: %f", overlayOpacity);
        }
        else {
            self.overlay.alpha = 0.6;
            DLog(@"Overlay opacity: %f", self.overlay.alpha);
        }
        self.alpha = 1.0;
    } completion:^ (BOOL finished) {DLog(@"Everything shown");}];
}

- (void)dismissAlertView {    
    /* ----------------------------------------------------------------
     *  Fade out the alert view over 0.4 seconds with no delay
     *  ---------------------------------------------------------------- */
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
        self.alpha = 0.0;
        self.overlay.alpha = 0.0;
    } completion:^ (BOOL finished) {DLog(@"Everything hidden");}];
}

/* -------------------------------------- */
   # pragma mark - Convenience Setters
/* -------------------------------------- */

- (void)setTopButtonText:(NSString *)text {
    /* -----------------------------------------------------
      *  Convenience method to set the top button's label text
      *  ----------------------------------------------------- */
    self.topButtonLabel.text = text;
    DLog(@"Top button text set to %@", text);
}

- (void)setMiddleButtonText:(NSString *)text {
    /* -------------------------------------------------------
      *  Convenience method to set the middle button's label text
      *  ------------------------------------------------------- */
    self.middleButtonLabel.text = text;
    DLog(@"Middle button text set to %@", text);
}

- (void)setBottomButtonText:(NSString *)text {
    /* -------------------------------------------------------
      *  Convenience method to set the bottom button's label text
      *  ------------------------------------------------------- */
    self.bottomButtonLabel.text = text;
    DLog(@"Bottom button text set to %@", text);
}

- (void)setOverlayOpacity:(float)newOpacity {
    /* ----------------------------------------------
     *  Convenience method to set the overlay opacity
     *  ---------------------------------------------- */
    overlayOpacity = newOpacity;
    DLog(@"Overlay opacity: %f", overlayOpacity);
}

/* ------------------------------------ */
   # pragma mark - Buttons Tapped
/* ------------------------------------ */

- (void)topButtonTapped:(id)sender {
    /* --------------------------------------------------------------------
      *  Selector for top button, sending to the parent view controller
      *  Implement willChangeValueForKey on parent view and compare to text
      *  -------------------------------------------------------------------- */
    [self.parentViewController willChangeValueForKey:@"DGAlertViewTopButtonTapped"];
    DLog(@"Top button tapped");
}

- (void)middleButtonTapped:(id)sender {
    /* --------------------------------------------------------------------
      *  Selector for middle button, sending to the parent view controller
      *  Implement willChangeValueForKey on parent view and compare to text
      *  -------------------------------------------------------------------- */
    [self.parentViewController willChangeValueForKey:@"DGAlertViewMiddleButtonTapped"];
    DLog(@"Middle button tapped");
}

- (void)bottomButtonTapped:(id)sender {
    /* --------------------------------------------------------------------
      *  Selector for bottom button, sending to the parent view controller
      *  Implement willChangeValueForKey on parent view and compare to text
      *  -------------------------------------------------------------------- */
    [self.parentViewController willChangeValueForKey:@"DGAlertViewBottomButtonTapped"];
    DLog(@"Bottom button tapped");
}

@end
