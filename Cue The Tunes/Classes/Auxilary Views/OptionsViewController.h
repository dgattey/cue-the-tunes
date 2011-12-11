//
//  OptionsViewController.h
//  Cue The Tunes
//
//  Created by Dylan Gattey on 6/8/11.
//  Copyright 2011 Gattey/Azinger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionsViewController : UIViewController
{
    UILabel *_titleLabelOptions;
    UIButton *_backButton;
    UISwitch *_multiplayerSwitch;
    UISwitch *_soundsSwitch;
    UISwitch *_shakeSwitch;
    UIButton *_aboutButton;
    UIButton *_instructionsButton;
}


@property (nonatomic, retain) IBOutlet UILabel *titleLabelOptions;
@property (nonatomic, retain) IBOutlet UIButton *backButton;
@property (nonatomic, retain) IBOutlet UISwitch *multiplayerSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *soundsSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *shakeSwitch;
@property (nonatomic, retain) IBOutlet UIButton *aboutButton;
@property (nonatomic, retain) IBOutlet UIButton *instructionsButton;

- (IBAction)doneOptionsView:(id)sender;
- (IBAction)showInstructionsView:(id)sender;
- (IBAction)showAboutView:(id)sender;

@end
