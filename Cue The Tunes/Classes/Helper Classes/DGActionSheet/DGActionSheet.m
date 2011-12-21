//
//  DGActionSheet.m
//  Cue The Tunes
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

#import "DGActionSheet.h"

@implementation DGActionSheet

+ (void)setupActionSheet:(UIView*)actionSheet overlay:(UIView*)overlay newGameButton:(UIButton*)newGameButton continueGameButton:(UIButton*)continueGameButton cancelButton:(UIButton*)cancelButton inView:(UIView*)theView {
    //Clear bools
    [prefs setInteger:0 forKey:@"NUMBER_BUTTONS"];
    [prefs setBool:NO forKey:@"ACTION_SHEET_SHOWING"];
    
    //Main view configuration
    actionSheet.backgroundColor = [UIColor clearColor];
    actionSheet.userInteractionEnabled = YES;
        
    //Overlay view configuration
    overlay.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
    overlay.backgroundColor = [UIColor blackColor];
    overlay.userInteractionEnabled = YES;
    overlay.alpha = 0.0;

    //Hide Action sheet
    [actionSheet setAlpha:0.0];
}

+ (void)displayActionSheet:(UIView*)actionSheet overlay:(UIView*)overlay {        
    //Fade in overlay and action sheet
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
        overlay.alpha = 0.4;
        actionSheet.alpha = 1.0;
    } completion:^ (BOOL finished) {
        if (finished) {
            [prefs setBool:YES forKey:@"ACTION_SHEET_SHOWING"];
        }
    }];
}

+ (void)dismissActionSheet:(UIView*)actionSheet overlay:(UIView*)overlay {    
    //Fade out overlay and action sheet
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
        actionSheet.alpha = 0.0;
        overlay.alpha = 0.0;
    } completion:^ (BOOL finished) {
        if (finished) {
            [prefs setBool:NO forKey:@"ACTION_SHEET_SHOWING"];
        }
    }];
}

@end
