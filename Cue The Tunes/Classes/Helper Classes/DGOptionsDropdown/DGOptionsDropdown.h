//
//  DGOptionsDropdown.h
//  DGOptionsDropdown
//
//  Created by Dylan Gattey on 8/12/11.
//  Copyright 2011 Dylan Gattey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DGOptionItem.h"

@interface DGOptionsDropdown : UIView

+ (void)resetOptions;

+ (void)slideOptionsWithDuration:(double)duration
                 viewController:(UIViewController*)viewController
                     anchorView:(UIView*)anchorView
                 theOptionsView:(UIImageView*)theOptionsView
                        overlay:(UIView*)overlay
                backgroundImage:(UIImage*)backgroundImage
                  overlayAmount:(double)overlayAmount
                  optionsButton:(UIButton*)optionsButton
                     backButton:(UIButton*)backButton;

+ (void)addOptionItem:(DGOptionItem*)optionItem toView:(UIView*)theView;

+ (void)setupOptionsViewsWithAnchorView:(UIView*)anchorView overlay:(UIView*)overlay optionView:(UIImageView*)optionsView backgroundImage:(UIImage*)backgroundImage;

+ (void)optionsToggledWithSwitch:(UISwitch*)theSwitch withTitle:(NSString*)title;

+ (void)refreshOptionView:(UIView*)optionView withOptionItem:(DGOptionItem*)optionItem withOverlay:(UIView*)overlay;

@end
