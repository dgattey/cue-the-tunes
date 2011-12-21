//
//  DGAlertView.m
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

#import "DGAlertView.h"

@implementation DGAlertView

+ (void)setupAlertView:(UIView*)alertView overlay:(UIView*)overlay newGameButton:(UIButton*)newGameButton continueGameButton:(UIButton*)continueGameButton cancelButton:(UIButton*)cancelButton inView:(UIView*)theView {
    //Clear bools
    [prefs setInteger:0 forKey:@"NUMBER_BUTTONS"];
    [prefs setBool:NO forKey:@"ACTION_SHEET_SHOWING"];
    
    //Main view configuration
    alertView.backgroundColor = [UIColor clearColor];
    alertView.userInteractionEnabled = YES;
        
    //Overlay view configuration
    overlay.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
    overlay.backgroundColor = [UIColor blackColor];
    overlay.userInteractionEnabled = YES;
    overlay.alpha = 0.0;

    //Hide Alert View
    [alertView setAlpha:0.0];
}

+ (void)displayAlertView:(UIView*)alertView overlay:(UIView*)overlay afterDelay:(float)delay {        
    //Fade in overlay and alert view
    [UIView animateWithDuration:0.4 delay:delay options:UIViewAnimationCurveEaseInOut animations:^{
        overlay.alpha = 0.4;
        alertView.alpha = 1.0;
    } completion:^ (BOOL finished) {
        if (finished) {
            [prefs setBool:YES forKey:@"ACTION_SHEET_SHOWING"];
        }
    }];
}

+ (void)dismissAlertView:(UIView*)alertView overlay:(UIView*)overlay {    
    //Fade out overlay and alert view
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
        alertView.alpha = 0.0;
        overlay.alpha = 0.0;
    } completion:^ (BOOL finished) {
        if (finished) {
            [prefs setBool:NO forKey:@"ACTION_SHEET_SHOWING"];
        }
    }];
}

@end
