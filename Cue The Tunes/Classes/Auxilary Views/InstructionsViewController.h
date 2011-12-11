//
//  InstructionsViewController.h
//  Cue The Tunes
//
//  Created by Dylan Gattey on 6/8/11.
//  Copyright 2011 Gattey/Azinger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstructionsViewController : UIViewController
{
    UILabel *_titleLabelInstructions;
    UIButton *_backButton;
}

@property (nonatomic, strong) IBOutlet UILabel *titleLabelInstructions;
@property (nonatomic, strong) IBOutlet UIButton *backButton;

- (IBAction)doneInstructionsView:(id)sender;

@end
