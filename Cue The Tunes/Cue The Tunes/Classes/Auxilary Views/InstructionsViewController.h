//
//  InstructionsViewController.h
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

#import <UIKit/UIKit.h>

@interface InstructionsViewController : UIViewController {
    FXLabel *_titleLabelInstructions;
    FXLabel *_backButtonLabel;
    UIButton *_backButton;
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    UIImageView *_arrowRight;
    UIImageView *_arrowLeft;
    BOOL pageControlUsed;
}

@property (nonatomic, strong) IBOutlet FXLabel *titleLabelInstructions;
@property (nonatomic, strong) IBOutlet FXLabel *backButtonLabel;
@property (nonatomic, strong) IBOutlet UIButton *backButton;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) IBOutlet UIImageView *arrowRight;
@property (nonatomic, strong) IBOutlet UIImageView *arrowLeft;

- (IBAction)doneInstructionsView:(id)sender;
- (IBAction)changePage:(id)sender;
- (void)changeAlphaArrows;
- (void)repositionSubviews:(NSArray *)subviews;

@end