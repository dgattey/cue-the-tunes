//
//  OptionsViewController.m
//  Cue The Tunes
//
//  Created by Dylan Gattey on 6/8/11.
//  Copyright 2011 Gattey/Azinger. All rights reserved.
//

#import "OptionsViewController.h"
#import "InstructionsViewController.h"
#import "AboutViewController.h"

@implementation OptionsViewController

@synthesize titleLabelOptions = _titleLabelOptions, backButton = _backButton, multiplayerSwitch = _multiplayerSwitch, soundsSwitch = _soundsSwitch, shakeSwitch = _shakeSwitch, aboutButton = _aboutButton, instructionsButton = _instructionsButton;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Actions

- (IBAction)doneOptionsView:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"TITLE_NEEDS_ANIMATION"];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Instructions View

- (IBAction)showInstructionsView:(id)sender
{
    InstructionsViewController *instructionsViewController = [[InstructionsViewController alloc] initWithNibName:@"InstructionsViewController" bundle:nil];
    [self.navigationController pushViewController:instructionsViewController animated:YES];    
}

#pragma mark - About View

- (IBAction)showAboutView:(id)sender
{
    AboutViewController *aboutViewController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
    [self.navigationController pushViewController:aboutViewController animated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self.titleLabelOptions setFont:[UIFont fontWithName:GOTHAM size:20]];
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