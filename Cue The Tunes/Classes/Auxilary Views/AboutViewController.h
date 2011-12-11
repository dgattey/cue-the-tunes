//
//  AboutViewController.h
//  Cue The Tunes
//
//  Created by Dylan Gattey on 6/8/11.
//  Copyright 2011 Gattey/Azinger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController
{
    UILabel *_titleLabelAbout;
    UIButton *_backButton;
    UIImageView *_aboutTitleDropdown;
}

@property (nonatomic, strong) IBOutlet UILabel *titleLabelAbout;
@property (nonatomic, strong) IBOutlet UIButton *backButton;
@property (nonatomic, strong) IBOutlet UIImageView *aboutTitleDropdown;

- (IBAction)doneAboutView:(id)sender;
- (void)animateTitleInWithDuration:(double )duration;
- (void)animateTitleOutWithDuration:(double )duration;

@end
