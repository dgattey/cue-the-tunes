//
//  DGOptionsDropdown.m
//  DGOptionsDropdown
//
//  Created by Dylan Gattey on 8/12/11.
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

#import "DGOptionsDropdown.h"

/* ----------------------------------------------- */
   # pragma mark - Internal (Private) Implementation
/* ----------------------------------------------- */


@interface DGOptionsDropdown (Hidden)
/* -------------------------------------------------------
 *  Private methods used internally but not shown publicly
 *  ------------------------------------------------------ */
- (void)addOptionItem:(DGOptionItem*)optionItem;
- (void)optionsToggled:(id)sender;
- (void)commonInit;
- (void)refreshLayout;
- (void)overlayTapped:(id)sender;

@end

@implementation DGOptionsDropdown (Hidden)

- (void)commonInit {
    /* -------------------------------------------------------------------
      *  Internal method used to set default values and create common views
      *  ------------------------------------------------------------------- */
    numberOfOptionItems = 0;
    heightToShow = 0;
    if (!kOptionItemHeight) {
        kOptionItemHeight = 50;
    }
    if (!kOptionItemPrimaryHeight) {
        kOptionItemPrimaryHeight = 64;
    }
    if (!kOptionItemLeftInset) {
        kOptionItemLeftInset = 26;
    }
    optionsHidden = YES;
    
    /* ----------------------------------------------------
      *  Set properties for overlay and it's gesture recognizer
      *  ---------------------------------------------------- */
    self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
    self.overlay.backgroundColor = [UIColor blackColor];
    self.overlay.userInteractionEnabled = YES;
    self.overlay.exclusiveTouch = YES;
    self.overlay.alpha = 0.0;
    
    self.overlayTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(overlayTapped:)];
    [self.overlay addGestureRecognizer:self.overlayTapGestureRecognizer];
    
    /* --------------------------------------------------------------
      *  Set up the main options view and add the background view to it
      *  -------------------------------------------------------------- */
    self.userInteractionEnabled = YES;
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    self.contentMode = UIViewContentModeBottom;
    [self addSubview:self.backgroundView];
    DLog(@"Common init done");
}

- (void)addOptionItem:(DGOptionItem*)optionItem {
    /* ----------------------------------------------------------------------------
      *  Internal method used to add individual option items to the view
      *  Only used after setting the main optionsItems array
      *  Start out by increasing numberOfOptionItems by one and refreshing the layout
      *  ---------------------------------------------------------------------------- */
    numberOfOptionItems = (numberOfOptionItems + 1);
    DLog(@"Number of option items: %f", numberOfOptionItems);
    [self refreshLayout];
    
    /* ------------------------------------------------------------------
      *  Create the title label, detail label, and switch
      *  Set the properties and text, and the tag to the numberOfOptionItems
      *  ------------------------------------------------------------------ */
    FXLabel *titleLabel = [[FXLabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x + kOptionItemLeftInset, self.bounds.size.height + self.bounds.origin.y - 10, 170, 30)];
    setOptionsMainStyleUsingLabel(titleLabel)
    [titleLabel setText:optionItem.itemTitleText];
    [titleLabel setTag:numberOfOptionItems];
    
    FXLabel *detailLabel = [[FXLabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x + kOptionItemLeftInset, self.bounds.size.height + self.bounds.origin.y + 20, 170, 10)];
    setOptionsDetailStyleUsingLabel(detailLabel)
    [detailLabel setText:optionItem.itemDetailText];
    
    UISwitch *aSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.bounds.origin.x + kOptionItemLeftInset + 176, self.bounds.size.height + self.bounds.origin.y - 2, aSwitch.frame.size.width, aSwitch.frame.size.height)];
    [aSwitch setUserInteractionEnabled:YES];
    [aSwitch setTag:numberOfOptionItems];
    [aSwitch addTarget:self action:@selector(optionsToggled:) forControlEvents:UIControlEventValueChanged];
    
    /* ---------------------------------------------------
      *  Based on the title text, set the switch on or off
      *  Data stored in NSUserDefaults with name as follows:
      *  OPTION_TITLEOFPREFERENCE
      *  --------------------------------------------------- */
    NSString *boolTitle = [@"OPTION_" stringByAppendingString:[optionItem.itemTitleText uppercaseString]];
    if ([prefs boolForKey:boolTitle]) {
        [aSwitch setOn:YES];
    }    
    else if (![prefs boolForKey:boolTitle]) {
        [aSwitch setOn:NO];
    }
    
    /* ----------------------------------------------------------------------------
      *  If an option item already exists, move the labels and switch up to compensate
      *  Finally, add them all to the main options view
      *  ---------------------------------------------------------------------------- */
    if (numberOfOptionItems > 0) {
        titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y - (numberOfOptionItems * kOptionItemHeight), titleLabel.frame.size.width, titleLabel.frame.size.height);
        detailLabel.frame = CGRectMake(detailLabel.frame.origin.x, detailLabel.frame.origin.y - (numberOfOptionItems * kOptionItemHeight), detailLabel.frame.size.width, detailLabel.frame.size.height);
        aSwitch.frame = CGRectMake(aSwitch.frame.origin.x, aSwitch.frame.origin.y - (numberOfOptionItems * kOptionItemHeight), aSwitch.frame.size.width, aSwitch.frame.size.height);
    }
    
    [self addSubview:titleLabel];
    [self addSubview:detailLabel];
    [self addSubview:aSwitch];
}

- (void)optionsToggled:(id)sender {
    /* ----------------------------------------------------------------
      *  Internal method used to set NSUserDefaults for toggling of a switch
      *  Find all FXLabels in allSubviews
      *  If the label tag is the same as the sender's (the switch toggled) tag:
      *  Set the bool in NSUserDefaults to the appropriate value
      *  ---------------------------------------------------------------- */
    if (sender && [sender isKindOfClass:[UISwitch class]]) {
        for (FXLabel *label in [self allSubviews]) {
            if ([label isKindOfClass:[FXLabel class]] && label.tag == [sender tag]) {
                NSString *boolTitle = [@"OPTION_" stringByAppendingString:[label.text uppercaseString]];
                if ([sender isOn] == YES) {
                    [prefs setBool:YES forKey:boolTitle];
                }
                else if ([sender isOn] == NO) {
                    [prefs setBool:NO forKey:boolTitle];
                }
            }
        }
    }
}

- (void)refreshLayout {
    /* ------------------------------------------------------
      *  Internal method used to layout the views after a change
      *  Start out by calculating the height to show
      *  ------------------------------------------------------ */
    heightToShow = kOptionItemPrimaryHeight + ((numberOfOptionItems - 1) * kOptionItemHeight);
    DLog(@"Height to show: %f", heightToShow);
    
    /* ----------------------------------------------
      *  Set a new frame for the main options view
      *  Based on the background and anchor views
      *  ---------------------------------------------- */
    CGFloat originalHeight = self.backgroundView.frame.size.height;
    CGFloat originalY = self.anchor.frame.origin.y + self.anchor.frame.size.height - originalHeight - 4;
    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    self.frame = CGRectMake(0, originalY, screenWidth, originalHeight);
    
    /* --------------------------------------------------------------
      *  Re-layout the labels and switches with the new (or not) left inset
      *  -------------------------------------------------------------- */
    for (FXLabel *label in [self allSubviews]) {
        if ([label isKindOfClass:[FXLabel class]]) {
            [label setFrame:CGRectMake(kOptionItemLeftInset, label.frame.origin.y, label.frame.size.width, label.frame.size.height)];
        }
    }
    
    for (UISwitch *aSwitch in [self allSubviews]) {
        if ([aSwitch isKindOfClass:[UISwitch class]]) {
            [aSwitch setFrame:CGRectMake(kOptionItemLeftInset + 176, aSwitch.frame.origin.y, aSwitch.frame.size.width, aSwitch.frame.size.height)];
        }
    }
}

- (void)overlayTapped:(id)sender {
    /* ------------------------------------------------------------
      *  Internal method to slide the options after the overlay is tapped
      *  ------------------------------------------------------------ */
    [self.optionsButtonLabel setText:@""];
    [self.optionsButtonLabel setText:@"Options"];

    [self slideOptionsWithDuration:0.3];
}

@end

/* -------------------------------------- */
   # pragma mark - Public implementation
/* -------------------------------------- */

@implementation DGOptionsDropdown

@synthesize overlay = _overlay, overlayTapGestureRecognizer = _overlayTapGestureRecognizer, backgroundView = _backgroundView, optionItems = _optionItems, anchor = _anchor, optionsButton = _optionsButton, optionsButtonLabel = _optionsButtonLabel, viewsToHide = _viewsToHide;

/* ---------------------------------------------------------------------------
 *  Create a shared instance to reference from various classes within application
 *  Initiated when first accessed. Easy to set from app delegate
 *  --------------------------------------------------------------------------- */
static DGOptionsDropdown *sharedInstance = nil;

+ (DGOptionsDropdown *)sharedInstance {
	if (sharedInstance == nil) {
		sharedInstance = [[DGOptionsDropdown alloc] init];
        DLog(@"Options shared instance initiated");
    }
	return sharedInstance;
}

- (void)setItemHeight:(CGFloat)itemHeight withPrimaryHeight:(CGFloat)primaryItemHeight leftItemInset:(CGFloat)leftItemInset {
    /* -----------------------------------------------------------
      *  Convenience method to set values, triggering the common init
      *  ----------------------------------------------------------- */
    kOptionItemHeight = itemHeight;
    kOptionItemPrimaryHeight = primaryItemHeight;
    kOptionItemLeftInset = leftItemInset;
    
    [self commonInit];
}

- (void)slideOptionsWithDuration:(double)duration {
    /* ---------------------------------------------------------
      *  Used to slide the options up or down with a given duration
      *  If not given, duration is 0.3 sec
      *  --------------------------------------------------------- */
    DLog(@"Start sliding options");
    
    if (!duration) {
        duration = 0.3;
    }
    
    if (self.viewsToHide) {
        /* ----------------------------------------------------------------
            *  If there are views to hide, change the button label text and images
            *  ---------------------------------------------------------------- */
        if (!optionsHidden) {
            [self.optionsButtonLabel setText:@""];
            [self.optionsButton setBackgroundImage:[UIImage imageNamed:@"OptionsButtonNormal"] forState:UIControlStateNormal];
            [self.optionsButtonLabel setText:@"Options"];
        }
        
        else {
            [self.optionsButtonLabel setText:@""];
            [self.optionsButton setBackgroundImage:[UIImage imageNamed:@"DoneButtonNormal"] forState:UIControlStateNormal];
            [self.optionsButtonLabel setText:@"Done"];
        }
        
        /* -------------------------------------------------------------------
            *  Loop to find all views in the view to hide and show/hide appropriately
            *  ------------------------------------------------------------------- */
        NSUInteger i;
        for (i=0; i < [self.viewsToHide count]; i++) {
            [[self.viewsToHide objectAtIndex:i] setEnabled:NO];
            [UIView animateWithDuration:duration animations:^{
                if (!optionsHidden) {
                    [[self.viewsToHide objectAtIndex:i] setAlpha:1];
                }
                else {
                    [[self.viewsToHide objectAtIndex:i] setAlpha:0];
                }
            } completion:^(BOOL finished) {
                if (finished) {
                    [[self.viewsToHide objectAtIndex:i] setEnabled:YES];
                }
            }];
            DLog(@"Extra option view hidden");
        }
    }
        
    /* ----------------------------------------------------------
      *  If the options are hidden and there's a button and an anchor
      *  Move the options down starting with a change in bool
      *  ---------------------------------------------------------- */
    if (optionsHidden && self.optionsButton && self.anchor) { 
        DLog(@"Options are already hidden, so show the view");
        optionsHidden = NO;
        
        /* ------------------------------------------------------------
            *  Last minute layout refresher and add views below the anchor
            *  Disable the options button to prevent multiple animations
            *  ------------------------------------------------------------ */
        [self refreshLayout];
        [self.anchor.superview insertSubview:self.overlay belowSubview:self.anchor];
        [self.anchor.superview insertSubview:self aboveSubview:self.overlay];
        [self.optionsButton setEnabled:NO];
        
        /* ----------------------------------------------
            *  Animate with the passed in duration
            *  Set a new frame for self and overlay opacity
            *  When completed, re-enable the button
            *  ---------------------------------------------- */
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + heightToShow, self.frame.size.width, self.frame.size.height);
            self.overlay.alpha = 0.6;
            DLog(@"Start sliding down");
        } completion:^ (BOOL finished) {
            [self.optionsButton setEnabled:YES];
            DLog(@"Done sliding down");
        }];
    }
    
    /* --------------------------------------------------------------
      *  If the options arenn't hidden and there's a button and an anchor
      *  Move the options up starting with a change in bool
      *  -------------------------------------------------------------- */
    else if (!optionsHidden && self.optionsButton && self.anchor) {
        DLog(@"Options already showing so hide the view");
        optionsHidden = YES;
        
        /* ------------------------------------------------------------
            *  Disable the options button to prevent multiple animations
            *  ------------------------------------------------------------ */
        [self.optionsButton setEnabled:NO];
        
        /* ------------------------------------------------------------------------------
            *  Animate with the passed in duration
            *  Set a new frame for self and overlay opacity
            *  When completed, re-enable the button and remove the views from the superview
            *  ------------------------------------------------------------------------------ */
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y - heightToShow, self.frame.size.width, self.frame.size.height);
            self.overlay.alpha = 0.0;
            DLog(@"Start sliding up");
        } completion:^ (BOOL finished) {
            if (finished) {
                //Remove it from the view
                [self removeFromSuperview];
                [self.overlay removeFromSuperview];
            }
            [self.optionsButton setEnabled:YES];
            DLog(@"Done sliding up");
        }];
    }    
}

- (void)addOptionItems:(NSArray *)optionItems {
    /* ------------------------------------------------------------------------------
      *  Convenience method to set the option items array - DO NOT call more than once!
      *  Passed in items are self.optionItems
      *  Loop to find all items in array and call addOptionItem for each one
      *  ------------------------------------------------------------------------------ */
    self.optionItems = optionItems;
    if (self.optionItems) {
        numberOfOptionItems = 0;
        NSUInteger i;
        for (i=0; i < [self.optionItems count]; i++) {
            DLog(@"Index of option item being added: %i", i);
            [self addOptionItem:[self.optionItems objectAtIndex:i]];
        }
    }

}

- (void)refreshOptionsView {    
    /* -------------------------------------------------------------------------------------------
     *  Ugly code, but it gets the job done. Call it when viewDid or viewWillAppear in a presenting view
     *  Find all FXLabels and UISwitches in self and if the label tag is the same as the switch's tag:
     *  Use the bool in NSUserDefaults to set the switch the appropriate value
     *  -------------------------------------------------------------------------------------------- */
    for (FXLabel *label in [self allSubviews]) {
        for (UISwitch *aSwitch in [self allSubviews]) {
            if ([label isKindOfClass:[FXLabel class]] && [aSwitch isKindOfClass:[UISwitch class]] && aSwitch.tag == label.tag) {
                DLog(@"Found switch & label and tags are the same: %i", label.tag);
                NSString *boolTitle = [@"OPTION_" stringByAppendingString:[label.text uppercaseString]];
                if ([prefs boolForKey:boolTitle]) {
                    [aSwitch setOn:YES];
                    DLog(@"Switch on: %@", aSwitch);
                }
                else if (![prefs boolForKey:boolTitle]) {
                    [aSwitch setOn:NO];
                    DLog(@"Switch on: %@", aSwitch);
                }
            }
        }
    }
}

@end