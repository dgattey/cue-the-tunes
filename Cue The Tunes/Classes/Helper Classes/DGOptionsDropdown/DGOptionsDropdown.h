//
//  DGOptionsDropdown.h
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
                    viewsToHide:(NSArray*)array;

+ (void)addOptionItem:(DGOptionItem*)optionItem toView:(UIView*)theView;

+ (void)setupOptionsViewsWithAnchorView:(UIView*)anchorView overlay:(UIView*)overlay optionView:(UIImageView*)optionsView backgroundImage:(UIImage*)backgroundImage;

+ (void)optionsToggledWithSwitch:(UISwitch*)theSwitch withTitle:(NSString*)title;

+ (void)refreshOptionView:(UIView*)optionView withOptionItem:(DGOptionItem*)optionItem withOverlay:(UIView*)overlay;

@end
