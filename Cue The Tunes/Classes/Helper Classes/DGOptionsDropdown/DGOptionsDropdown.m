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

/* ---------------------------------------- */
   # pragma mark - Private Implementation
/* ---------------------------------------- */


@interface DGOptionsDropdown (hidden)

- (void)addOptionItem:(DGOptionItem*)optionItem;
- (void)optionsToggled:(id)sender;
- (void)commonInit;
- (void)refreshLayout;
- (void)overlayTapped:(id)sender;

@end

@implementation DGOptionsDropdown (hidden)

- (void)commonInit {
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
    
    //Create overlay
    self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
    self.overlay.backgroundColor = [UIColor blackColor];
    self.overlay.userInteractionEnabled = YES;
    self.overlay.exclusiveTouch = YES;
    self.overlay.alpha = 0.0;
    
    self.overlayTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(overlayTapped:)];
    [self.overlay addGestureRecognizer:self.overlayTapGestureRecognizer];
    
    //Self properties
    self.userInteractionEnabled = YES;
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    self.contentMode = UIViewContentModeBottom;
    [self addSubview:self.backgroundView];
    DLog(@"Common init done");
}

- (void)addOptionItem:(DGOptionItem*)optionItem {
    //Increase option items number by one, and set that NSInteger for future use
    numberOfOptionItems = (numberOfOptionItems + 1);
    DLog(@"Number of option items: %f", numberOfOptionItems);
    
    [self refreshLayout];
    
    //Title label setup
    FXLabel *titleLabel = [[FXLabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x + kOptionItemLeftInset, self.bounds.size.height + self.bounds.origin.y - 10, 170, 30)];
    setOptionsMainStyleUsingLabel(titleLabel)
    [titleLabel setText:optionItem.itemTitleText];
    [titleLabel setTag:numberOfOptionItems];
    
    //Detail label setup
    FXLabel *detailLabel = [[FXLabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x + kOptionItemLeftInset, self.bounds.size.height + self.bounds.origin.y + 20, 170, 10)];
    setOptionsDetailStyleUsingLabel(detailLabel)
    [detailLabel setText:optionItem.itemDetailText];
    
    //Switch setup
    UISwitch *aSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.bounds.origin.x + kOptionItemLeftInset + 176, self.bounds.size.height + self.bounds.origin.y - 2, aSwitch.frame.size.width, aSwitch.frame.size.height)];
    [aSwitch setUserInteractionEnabled:YES];
    [aSwitch setTag:numberOfOptionItems];
    [aSwitch addTarget:self action:@selector(optionsToggled:) forControlEvents:UIControlEventValueChanged];
    
    //Set switch on or off based on name of option
    NSString *boolTitle = [@"OPTION_" stringByAppendingString:[optionItem.itemTitleText uppercaseString]]; //Set title to OPTION_ with the title appended in uppercase
    if ([prefs boolForKey:boolTitle]) {[aSwitch setOn:YES];}
    else if (![prefs boolForKey:boolTitle]) {[aSwitch setOn:NO];}
    
    //If an option item already exists, move up all items from bottom of view by setting frames
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
    //Sender is the switch that was toggled, which has a tag & when compared to the labels, should match one
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
    //Set the heightToShow to the primary height + the number of option items * that height
    heightToShow = kOptionItemPrimaryHeight + ((numberOfOptionItems - 1) * kOptionItemHeight);
    DLog(@"Height to show: %f", heightToShow);
    
    //Set frame for self
    CGFloat originalHeight = self.backgroundView.frame.size.height;
    CGFloat originalY = self.anchor.frame.origin.y + self.anchor.frame.size.height - originalHeight - 4;
    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    self.frame = CGRectMake(0, originalY, screenWidth, originalHeight);
    
    //Re layout labels and switches with new left offset
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

//Shared instance work
static DGOptionsDropdown *sharedInstance = nil;

+ (DGOptionsDropdown *)sharedInstance {
	if (sharedInstance == nil)
        {
		sharedInstance = [[DGOptionsDropdown alloc] init];
        }
	return sharedInstance;
    DLog(@"Options shared instance initiated");
}

//Sliding views
- (void)slideOptionsWithDuration:(double)duration {
    DLog(@"Start sliding options");
    
    if (!duration) {
        duration = 0.3;
    }
    
    if (self.viewsToHide) {
        //Switch the original options image and the done image on the button if not main menu
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
        
    //Do work
    if (optionsHidden && self.optionsButton && self.anchor) { 
        DLog(@"Options are already hidden, so show the view");
        optionsHidden = NO;
        
        //Add it to the view
        [self refreshLayout];
        [self.anchor.superview insertSubview:self.overlay belowSubview:self.anchor];
        [self.anchor.superview insertSubview:self aboveSubview:self.overlay];
        
        //Move options view down, do fades
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + heightToShow, self.frame.size.width, self.frame.size.height);
            self.overlay.alpha = 0.6;
            DLog(@"Start sliding down");
        } completion:^ (BOOL finished) {
            [self.optionsButton setEnabled:YES];
            DLog(@"Done sliding down");
        }];
    }
    else if (!optionsHidden && self.optionsButton && self.anchor) {
        DLog(@"Options already showing so hide the view");
        optionsHidden = YES;
        
        //Disable buttons, but change images so it's a smooth transition
        [self.optionsButton setEnabled:NO];
        
        //Move options view up
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
    self.optionItems = optionItems;
    
    //Add option items
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
    /* -----------------------------------------------------
     *  Ugly, but it gets the job done
     *  Find all FXLabels and UISwitches
     *  If the tags are the same, find the bool for the title key
     *  And set switch states based on that
     *  ----------------------------------------------------- */
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

#pragma mark - Set properties

- (void)setItemHeight:(CGFloat)itemHeight withPrimaryHeight:(CGFloat)primaryItemHeight leftItemInset:(CGFloat)leftItemInset {
    kOptionItemHeight = itemHeight;
    kOptionItemPrimaryHeight = primaryItemHeight;
    kOptionItemLeftInset = leftItemInset;
    
    [self commonInit];
}

@end