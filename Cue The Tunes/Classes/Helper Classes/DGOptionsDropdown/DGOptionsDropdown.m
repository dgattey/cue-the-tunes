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

@implementation DGOptionsDropdown

+ (void)resetOptions
{
    [prefs setInteger:0 forKey:@"NUMBER_OPTION_ITEMS"];
    [prefs setInteger:0 forKey:@"OPTIONS_HEIGHT_TO_SHOW"];
    [prefs setBool:YES forKey:@"OPTIONS_HIDDEN"];
}

+ (void)setupOptionsViewsWithAnchorView:(UIView *)anchorView overlay:(UIView *)overlay optionView:(UIImageView *)optionsView backgroundImage:(UIImage *)backgroundImage
{
    //Overlay
    overlay.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
    overlay.backgroundColor = [UIColor blackColor];
    overlay.userInteractionEnabled = YES;
    overlay.exclusiveTouch = YES;
    overlay.alpha = 0.0;
    
    //Options view
    CGFloat originalY = anchorView.frame.origin.y + anchorView.frame.size.height - backgroundImage.size.height - 4;
    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    CGFloat originalHeight = backgroundImage.size.height;
    optionsView.frame = CGRectMake(0, originalY, screenWidth, originalHeight);
    optionsView.contentMode = UIViewContentModeTop;
    
    //Prefs
    [prefs setBool:YES forKey:@"OPTIONS_HIDDEN"];
}

+ (void)addOptionItem:(DGOptionItem *)optionItem toView:(UIView *)theView
{    
    //Increase option items number by one, and set that NSInteger for future use
    
    [prefs setInteger:[prefs integerForKey:@"NUMBER_OPTION_ITEMS"] + 1 forKey:@"NUMBER_OPTION_ITEMS"];
    NSInteger numberOptionItems = [prefs integerForKey:@"NUMBER_OPTION_ITEMS"];
    
    //Set Option view showing height to 60 initially, then increase in sets of 50 for each additional item - set to integer for use later
    [prefs setInteger:(64 + ((numberOptionItems - 1) * 50)) forKey:@"OPTIONS_HEIGHT_TO_SHOW"];
    
    //Title label setup
    UILabel *newOptionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(theView.bounds.origin.x + 26, theView.bounds.size.height + theView.bounds.origin.y - 10, 170, 30)];
    [newOptionTitleLabel setFont:[UIFont fontWithName:@"Gotham Medium" size:20]];
    [newOptionTitleLabel setTextColor:[UIColor whiteColor]];
    [newOptionTitleLabel setBackgroundColor:[UIColor clearColor]];
    [newOptionTitleLabel setTextAlignment:UITextAlignmentLeft];
    [newOptionTitleLabel setText:optionItem.itemTitleText];
    
    //Detail label setup
    UILabel *newOptionDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(theView.bounds.origin.x + 26, theView.bounds.size.height + theView.bounds.origin.y + 20, 170, 10)];    
    [newOptionDetailLabel setFont:[UIFont fontWithName:@"Gotham Medium" size:11]];
    [newOptionDetailLabel setTextColor:[UIColor colorWithRed:.749019608 green:.749019608 blue:.749019608 alpha:1.0]];
    [newOptionDetailLabel setBackgroundColor:[UIColor clearColor]];
    [newOptionDetailLabel setTextAlignment:UITextAlignmentLeft];
    [newOptionDetailLabel setText:optionItem.itemDetailText];
    
    //Switch setup
    [optionItem.itemSwitch setFrame:CGRectMake
     (theView.bounds.origin.x + 202, 
      theView.bounds.size.height + theView.bounds.origin.y - 2, 
      optionItem.itemSwitch.frame.size.width, 
      optionItem.itemSwitch.frame.size.height)];
    [optionItem.itemSwitch setUserInteractionEnabled:YES];
    
    //Set switch on or off based on name of option
    NSString *boolTitle = [@"OPTION_" stringByAppendingString:[optionItem.itemTitleText uppercaseString]]; //Set title to OPTION_ with the title appended in uppercase
    if ([prefs boolForKey:boolTitle]) {[optionItem.itemSwitch setOn:YES];}
    if (![prefs boolForKey:boolTitle]) {[optionItem.itemSwitch setOn:NO];}
    
    //If an option item already exists, add move up all items from bottom of view by setting frames
    if (!numberOptionItems == 0) {
        newOptionTitleLabel.frame = CGRectMake(
                                               newOptionTitleLabel.frame.origin.x,
                                               newOptionTitleLabel.frame.origin.y - (numberOptionItems * 50), 
                                               newOptionTitleLabel.frame.size.width,
                                               newOptionTitleLabel.frame.size.height);
        newOptionDetailLabel.frame = CGRectMake(
                                                newOptionDetailLabel.frame.origin.x,
                                                newOptionDetailLabel.frame.origin.y - (numberOptionItems * 50), 
                                                newOptionDetailLabel.frame.size.width,
                                                newOptionDetailLabel.frame.size.height);
         optionItem.itemSwitch.frame = CGRectMake(
                                                 optionItem.itemSwitch.frame.origin.x,
                                                 optionItem.itemSwitch.frame.origin.y - (numberOptionItems * 50), 
                                                 optionItem.itemSwitch.frame.size.width,
                                                 optionItem.itemSwitch.frame.size.height);
    }
    
    //Set tags using algebra to get continuous numbers if needed in future
    newOptionTitleLabel.tag = (3 * numberOptionItems) + 1;
    newOptionDetailLabel.tag = newOptionTitleLabel.tag + 1;
    optionItem.itemSwitch.tag = newOptionDetailLabel.tag + 1;
    
    //Add all items to theView and enable it for touches
    [theView setUserInteractionEnabled:YES];
    [theView addSubview:newOptionTitleLabel];
    [theView addSubview:newOptionDetailLabel];
    [theView addSubview:optionItem.itemSwitch];
}

+ (void)slideOptionsWithDuration:(double)duration
                 viewController:(UIViewController*)viewController
                     anchorView:(UIView*)anchorView
                 theOptionsView:(UIImageView*)theOptionsView
                        overlay:(UIView*)overlay
                backgroundImage:(UIImage*)backgroundImage
                  overlayAmount:(double)overlayAmount
                  optionsButton:(UIButton*)optionsButton
                     backButton:(UIButton*)backButton
{
    
    //Get options view height for use later
    NSInteger optionsViewHeight = [prefs integerForKey:@"OPTIONS_HEIGHT_TO_SHOW"];
    
    //Do work
    if ([prefs boolForKey:@"OPTIONS_HIDDEN"]) { 
        //Disable buttons, but change images so it's a smooth transition
        [optionsButton setImage:[UIImage imageNamed:@"DoneButtonNormal"] forState:UIControlStateDisabled];
        [backButton setImage:[UIImage imageNamed:@"BackButtonNormal"] forState:UIControlStateDisabled];
        optionsButton.enabled = NO;
        backButton.enabled = NO;
        
        //Insert overlay
        [viewController.view insertSubview:overlay belowSubview:anchorView];
        
        //Setup options view
        theOptionsView.image = backgroundImage;
        [viewController.view insertSubview:theOptionsView aboveSubview:overlay];
        
        //Switch the original options image and the done image on the button
        [optionsButton setImage:[UIImage imageNamed:@"DoneButtonNormal"] forState:UIControlStateNormal];
        
        //Fade in overlay
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationCurveLinear animations:^{
            overlay.alpha = overlayAmount;
        } completion:^ (BOOL finished) {
        }];
        
        //Fade out back button
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationCurveLinear animations:^{
            backButton.alpha = 0.0;
        } completion:^ (BOOL finished) {
            backButton.enabled = YES;
            [backButton setImage:nil forState:UIControlStateDisabled];
        }];
        
        //Move options view down
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
            theOptionsView.frame = CGRectMake(theOptionsView.frame.origin.x, theOptionsView.frame.origin.y + optionsViewHeight, theOptionsView.frame.size.width, theOptionsView.frame.size.height);
        } completion:^ (BOOL finished) {
            [prefs setBool:NO forKey:@"OPTIONS_HIDDEN"];
            optionsButton.enabled = YES;
            [optionsButton setImage:nil forState:UIControlStateDisabled];
        }];
    }
    else {
        //Disable buttons, but change images so it's a smooth transition
        [optionsButton setImage:[UIImage imageNamed:@"OptionsButtonNormal"] forState:UIControlStateDisabled];
        [backButton setImage:[UIImage imageNamed:@"BackButtonNormal"] forState:UIControlStateDisabled];
        optionsButton.enabled = NO;
        backButton.enabled = NO;
        
        //Insert overlay
        [viewController.view insertSubview:overlay belowSubview:anchorView];
        
        //Setup options view
        theOptionsView.image = backgroundImage;
        [viewController.view insertSubview:theOptionsView aboveSubview:overlay];
        
        //Switch the original options image and the done image on the button
        [optionsButton setImage:[UIImage imageNamed:@"OptionsButtonNormal"] forState:UIControlStateNormal];
        
        //Fade out overlay
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationCurveLinear animations:^{
            overlay.alpha = 0.0;
        } completion:^ (BOOL finished) {
        }];
        
        //Fade in back button
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationCurveLinear animations:^{
            backButton.alpha = 1.0;
        } completion:^ (BOOL finished) {
            backButton.enabled = YES;
            [backButton setImage:nil forState:UIControlStateDisabled];
        }];
        
        //Move options view up
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
            theOptionsView.frame = CGRectMake(theOptionsView.frame.origin.x, theOptionsView.frame.origin.y - optionsViewHeight, theOptionsView.frame.size.width, theOptionsView.frame.size.height);
        } completion:^ (BOOL finished) {
            [prefs setBool:YES forKey:@"OPTIONS_HIDDEN"];
            optionsButton.enabled = YES;
            [optionsButton setImage:nil forState:UIControlStateDisabled];
        }];
    }
}

+ (void)optionsToggledWithSwitch:(UISwitch*)theSwitch withTitle:(NSString *)title
{
    //Create key title for saving option based on title passed in
    NSString *boolTitle = [@"OPTION_" stringByAppendingString:[title uppercaseString]]; //Set title to OPTION_ with the option item title appended in uppercase
    
    if (theSwitch.on == YES) {
        [prefs setBool:YES forKey:boolTitle];
    }
    if (theSwitch.on == NO) {
        [prefs setBool:NO forKey:boolTitle];
    }
}

+ (void)refreshOptionView:(UIView *)optionView withOptionItem:(DGOptionItem *)optionItem withOverlay:(UIView *)overlay
{
    [optionView removeFromSuperview];
    [overlay removeFromSuperview];
    
    //Set switch on or off based on name of option
    NSString *boolTitle = [@"OPTION_" stringByAppendingString:[optionItem.itemTitleText uppercaseString]]; //Set title to OPTION_ with the title appended in uppercase
    if ([[NSUserDefaults standardUserDefaults] boolForKey:boolTitle]) {[optionItem.itemSwitch setOn:YES];}
    if (![[NSUserDefaults standardUserDefaults] boolForKey:boolTitle]) {[optionItem.itemSwitch setOn:NO];}

}

@end













