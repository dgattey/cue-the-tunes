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

#import "DGOptionItem.h"
#import "FXLabel.h"

@interface DGOptionsDropdown : UIView {
    /* ----------------------------------------------
      *  Global bools and floats
      *  ---------------------------------------------- */
    BOOL optionsHidden;
    CGFloat numberOfOptionItems;
    CGFloat heightToShow;
    CGFloat kOptionItemHeight;
    CGFloat kOptionItemPrimaryHeight;
    CGFloat kOptionItemLeftInset;
    
    /* ----------------------------------------------
      *  Views and other items
      *  ---------------------------------------------- */
    UIImageView *_backgroundView;
    NSArray *_optionItems;
    UIView *_anchor;
    UIView *_overlay;
    UITapGestureRecognizer *_overlayTapGestureRecognizer;
    UIButton *_optionsButton;
    FXLabel *_optionsButtonLabel;
    NSArray *_viewsToHide;
}

@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) NSArray *optionItems;
@property (nonatomic, strong) UIView *anchor;
@property (nonatomic, strong) UIView *overlay;
@property (nonatomic, strong) UITapGestureRecognizer *overlayTapGestureRecognizer;
@property (nonatomic, strong) UIButton *optionsButton;
@property (nonatomic, strong) FXLabel *optionsButtonLabel;
@property (nonatomic, strong) NSArray *viewsToHide;

+ (DGOptionsDropdown *)sharedInstance;

/* ----------------------------------------------
 *  Main actions
 *  ---------------------------------------------- */
- (void)slideOptionsWithDuration:(double)duration;
- (void)addOptionItems:(NSArray*)optionItems;
- (void)refreshOptionsView;

/* ----------------------------------------------
 *  Property settings
 *  ---------------------------------------------- */
- (void)setItemHeight:(CGFloat)itemHeight withPrimaryHeight:(CGFloat)primaryItemHeight leftItemInset:(CGFloat)leftItemInset;

@end
