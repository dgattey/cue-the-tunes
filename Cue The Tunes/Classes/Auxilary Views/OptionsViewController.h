//
//  OptionsViewController.h
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
