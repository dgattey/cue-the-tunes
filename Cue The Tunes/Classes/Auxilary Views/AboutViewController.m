//
//  AboutViewController.m
//  Cue The Tunes
//
//  Created by Dylan Gattey on 6/8/11.
//  Copyright 2011 Gattey/Azinger. All rights reserved.
//

#import "AboutViewController.h"
#import "MainViewController.h"

@implementation AboutViewController

@synthesize titleLabelAbout = _titleLabelAbout, backButton = _backButton, aboutTitleDropdown = _aboutTitleDropdown;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Actions

- (IBAction)doneAboutView:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"TITLE_NEEDS_ANIMATION"];
    [self animateTitleOutWithDuration:0.3];
}

- (void)animateTitleInWithDuration:(double )duration
{    
    //Move title background down
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
        self.aboutTitleDropdown.center = CGPointMake(self.aboutTitleDropdown.center.x, self.aboutTitleDropdown.center.y + 66);
    } completion:^ (BOOL finished) {
    }];
}

- (void)animateTitleOutWithDuration:(double )duration
{
    //Move title background up
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
        self.aboutTitleDropdown.center = CGPointMake(self.aboutTitleDropdown.center.x, self.aboutTitleDropdown.center.y -66);
    } completion:^ (BOOL finished) {
    }];
    [NSThread sleepForTimeInterval:0.1];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self.titleLabelAbout setFont:gothamMedium20];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self animateTitleInWithDuration:0.3];
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end