//
//  InstructionsViewController.m
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

#import "InstructionsViewController.h"
#import "MainViewController.h"

@implementation InstructionsViewController

@synthesize titleLabelInstructions = _titleLabelInstructions, backButtonLabel = _backButtonLabel, backButton = _backButton, scrollView = _scrollView, pageControl = _pageControl, arrowLeft = _arrowLeft, arrowRight = _arrowRight;

/* ------------------------------------ */
   # pragma mark - View lifecycle
/* ------------------------------------ */

/* ----------------------------------------------
 *  Set default height and width for scrollView
 *  ---------------------------------------------- */
const CGFloat kScrollObjHeight	= 334;
const CGFloat kScrollObjWidth	= 274;

- (void)viewDidLoad {
    /* --------------------------------------------------
      *  Set default FXLabel styles based on label's tag
      *  Reposition the scrollView subviews for side by side
      *  Set page control properties
      *  -------------------------------------------------- */
    setTitleStyleUsingLabel(self.titleLabelInstructions);
    setTitleButtonStyleUsingLabel(self.backButtonLabel);
    for (FXLabel *label in [self.view allSubviews]) {
        if ([label isKindOfClass:[FXLabel class]]) {
            if (label.tag == 0) {
                setDefaultStyleUsingLabel(label);
                [label setFont:interstateRegular(14)];
            }
            if (label.tag == 2) {
                setDefaultStyleUsingLabel(label);
                [label setFont:interstateBold(19)];
            }
            if (label.tag == 3) {
                setDefaultStyleUsingLabel(label);
                [label setFont:interstateBold(22)];
            }
        }
    }
    [self repositionSubviews:self.scrollView.subviews];
    [self.pageControl setCurrentPage:0];
    [self.pageControl setNumberOfPages:[self.scrollView.subviews count]];
    
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    /* ----------------------------------------------
      *  Rotate only to portrait
      *  ---------------------------------------------- */
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/* ------------------------------------ */
   # pragma mark - Custom methods
/* ------------------------------------ */

- (IBAction)doneInstructionsView:(id)sender {
    /* -----------------------------------------------
      *  When done with the view, pop to the main menu
      *  ----------------------------------------------- */
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)changePage:(id)sender {
    /* -------------------------------------------------------------
      *  Scroll to the appropriate page's view with an animation
      *  Reset bool for pageControl to show it's been used
      *  ------------------------------------------------------------- */
    [self.scrollView scrollRectToVisible:CGRectMake(kScrollObjWidth * self.pageControl.currentPage, 0, kScrollObjWidth, kScrollObjHeight) animated:YES];
    pageControlUsed = YES;
    DLog(@"%f", (kScrollObjWidth * self.pageControl.currentPage));
    [self changeAlphaArrows];
}

- (void)changeAlphaArrows {
    /* --------------------------------------------------------------
      *  Change alpha so that the arrows are correctly enabled/disabled
      *  -------------------------------------------------------------- */
    self.arrowLeft.alpha = 1;
    self.arrowRight.alpha = 1;
    if (self.pageControl.currentPage == 0) {
        self.arrowLeft.alpha = 0.5;
        self.arrowRight.alpha = 1;
    }
    else if (self.pageControl.currentPage == 2) {
        self.arrowRight.alpha = 0.5;
        self.arrowLeft.alpha = 1;
    }
    DLog();
}

/* ------------------------------------------------------- */
# pragma mark - Scroll view delegate (+ more) methods
/* ------------------------------------------------------- */

- (void)repositionSubviews:(NSArray *)subviews {
	/* ------------------------------------------------------------------------
     *  Reposition all subviews of self.scrollView horizontally for imageViews in view
     *  Recalculate content size of scrollView to compensate
     *  ------------------------------------------------------------------------ */
	CGFloat currentPage = 0;
	for (UIView *view in [self.view allSubviews]) {
		if (view.tag == 2000) {
			[view setFrame:CGRectOffset(view.frame, currentPage * kScrollObjWidth, 0)];
            currentPage = currentPage+1;
        }
    }
    [self.scrollView setContentSize:CGSizeMake(([self.scrollView.subviews count] * kScrollObjWidth), [self.scrollView bounds].size.height)];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    if (pageControlUsed) {
        /* ---------------------------------------------------------------------
         *  If the pageControl was used to scroll do nothing to avoid feedback loop
         *  --------------------------------------------------------------------- */
        return;
    }
    
    /* -------------------------------------------------------------------------
     *  If more than 50% of the next or previous page is visible, change pageControl
     *  ------------------------------------------------------------------------- */
    int page = floor((self.scrollView.contentOffset.x - kScrollObjWidth / 2) / kScrollObjWidth) + 1;
    self.pageControl.currentPage = page;
    [self changeAlphaArrows];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    /* -------------------------------------------------------------
     *  Reset bool for pageControl at beginning of scrolling
     *  ------------------------------------------------------------- */
    pageControlUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    /* -------------------------------------------------------------
     *  Reset bool for pageControl at end of scrolling
     *  ------------------------------------------------------------- */
    pageControlUsed = NO;
}

@end