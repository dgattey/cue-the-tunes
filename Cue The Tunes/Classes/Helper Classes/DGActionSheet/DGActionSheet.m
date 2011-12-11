//
//  DGActionSheet.m
//  Cue The Tunes
//
//  Created by Dylan Gattey on 8/15/11.
//  Copyright 2011 Dylan Gattey. All rights reserved.
//

#import "DGActionSheet.h"

@implementation DGActionSheet

+ (void)setupActionSheet:(UIView*)actionSheet overlay:(UIView*)overlay newGameButton:(UIButton*)newGameButton continueGameButton:(UIButton*)continueGameButton cancelButton:(UIButton*)cancelButton inView:(UIView*)theView
{
    //Clear bools
    [prefs setInteger:0 forKey:@"NUMBER_BUTTONS"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ACTION_SHEET_SHOWING"];
    
    //Main view configuration
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ActionSheetBackground"]];
    actionSheet.backgroundColor = [UIColor clearColor];
    actionSheet.userInteractionEnabled = YES;
    actionSheet.frame = CGRectMake(0, UIScreen.mainScreen.bounds.size.height - backgroundImageView.frame.size.height, backgroundImageView.frame.size.width, backgroundImageView.frame.size.height); //Moves it so bottom edge is at bottom of the screen
    
    //Overlay view configuration
    overlay.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
    overlay.backgroundColor = [UIColor blackColor];
    overlay.userInteractionEnabled = YES;
    overlay.alpha = 0.0;

    //Move action sheet down offscreen
    [actionSheet setFrame:CGRectMake(actionSheet.frame.origin.x, actionSheet.frame.origin.y + actionSheet.frame.size.height, actionSheet.frame.size.width, actionSheet.frame.size.height)];
}

+ (void)displayActionSheet:(UIView*)actionSheet overlay:(UIView*)overlay
{    
    //Fade in overlay
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
        overlay.alpha = 0.6;
    } completion:^ (BOOL finished) {
    }];
    
    //Move action sheet up
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
        actionSheet.frame = CGRectMake(actionSheet.frame.origin.x, actionSheet.frame.origin.y - actionSheet.frame.size.height, actionSheet.frame.size.width, actionSheet.frame.size.height);
    } completion:^ (BOOL finished) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ACTION_SHEET_SHOWING"];
    }];
}

+ (void)dismissActionSheet:(UIView*)actionSheet overlay:(UIView*)overlay
{
    //Fade out overlay
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
        overlay.alpha = 0.0;
    } completion:^ (BOOL finished) {
    }];
    
    //Move action sheet down offscreen
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
        actionSheet.frame = CGRectMake(actionSheet.frame.origin.x, actionSheet.frame.origin.y + actionSheet.frame.size.height, actionSheet.frame.size.width, actionSheet.frame.size.height);
    } completion:^ (BOOL finished) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ACTION_SHEET_SHOWING"];
    }];
}

@end
