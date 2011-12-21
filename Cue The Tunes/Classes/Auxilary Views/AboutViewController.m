//
//  AboutViewController.m
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

#import "AboutViewController.h"
#import "MainViewController.h"

@implementation AboutViewController

@synthesize titleLabelAbout = _titleLabelAbout, backButtonLabel = _backButtonLabel, backButton = _backButton, aboutTitleDropdown = _aboutTitleDropdown, textView = _textView, versionLabel = _versionLabel;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (IBAction)doneAboutView:(id)sender {
    [self animateTitleOutWithDuration:0.3];
}

- (void)animateTitleInWithDuration:(double )duration {    
    //Move title background down
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
        self.aboutTitleDropdown.center = CGPointMake(self.aboutTitleDropdown.center.x, self.aboutTitleDropdown.center.y + 66);
        self.textView.alpha = 1.0;
    } completion:^ (BOOL finished) {
    }];
}

- (void)animateTitleOutWithDuration:(double )duration {
    //Move title background up
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
        self.aboutTitleDropdown.center = CGPointMake(self.aboutTitleDropdown.center.x, self.aboutTitleDropdown.center.y -66);
        self.textView.alpha = 0.0;
    } completion:^ (BOOL finished) {
    }];
    [NSThread sleepForTimeInterval:0.1];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    setTitleStyleUsingLabel(self.titleLabelAbout);
    setTitleButtonStyleUsingLabel(self.backButtonLabel);
    self.textView.alpha = 0.0;
    
    for (FXLabel *label in [self.view allSubviews]) {
        if ([label isKindOfClass:[FXLabel class]]) {
            if (label.tag == 1) {
                //Header style
                setDefaultStyleUsingLabel(label);
                [label setFont:interstateBold(20)];
            }
            if (label.tag == 2) {
                //Subheader style
                setDefaultShadowWithLabel(label);
                [label setTextColor:customGrayColor];
                [label setFont:interstateBold(15)];
                
            }
            if (label.tag == 3) {
                //More info and version label
                setDefaultStyleUsingLabel(label);
                [label setFont:interstateBold(12)];
                [label setOversampling:6];
            }
            if (label.tag == 4) {
                //Copyright
                setDefaultShadowWithLabel(label);
                [label setTextColor:customGrayColor];
                [label setFont:interstateBold(10)];
                [label setOversampling:6];
            }
        }
    }
    
    [self.versionLabel setText:[[NSString alloc] initWithString:[prefs stringForKey:@"CURRENT_VERSION"]]];
    [self.versionLabel setFont:interstateRegular(12)];
    
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [self animateTitleInWithDuration:0.3];
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end