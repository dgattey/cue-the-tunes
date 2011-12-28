//
//  DGAlertView.h
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
//
//  Class used to present a custom stlyed alert view on top of the current view

#import "FXLabel.h"

@interface DGAlertView : UIView {
    UIViewController *_parentViewController;
    UIView *_overlay;
    float overlayOpacity;
    
    UIButton *_topButton;
    FXLabel *_topButtonLabel;
    UIButton *_middleButton;
    FXLabel *_middleButtonLabel;
    UIButton *_bottomButton;
    FXLabel *_bottomButtonLabel;
}

@property (nonatomic, strong) UIViewController *parentViewController;
@property (nonatomic, strong) UIView *overlay;

@property (nonatomic, strong) UIButton *topButton;
@property (nonatomic, strong) FXLabel *topButtonLabel;
@property (nonatomic, strong) UIButton *middleButton;
@property (nonatomic, strong) FXLabel *middleButtonLabel;
@property (nonatomic, strong) UIButton *bottomButton;
@property (nonatomic, strong) FXLabel *bottomButtonLabel;


- (void)setupAlertViewWithSender:(id)sender;
- (void)setOverlayOpacity:(float)newOpacity;
- (void)setTopButtonText:(NSString *)text;
- (void)setMiddleButtonText:(NSString *)text;
- (void)setBottomButtonText:(NSString *)text;

- (void)topButtonTapped:(id)sender;
- (void)middleButtonTapped:(id)sender;
- (void)bottomButtonTapped:(id)sender;

- (void)displayAlertViewWithDelay:(float)delay;
- (void)dismissAlertView;

@end
