//
//  Cue_The_TunesAppDelegate.m
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

#import "Cue_The_TunesAppDelegate.h"
#import "MainViewController.h"
#import "GameViewController.h"
#import "UIDevice+Hardware.h"

@implementation Cue_The_TunesAppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /* ----------------------------------------------------------------
      *  Create string with version and build number, e.g. "Version 1.0 (23)"
      *  And save the version string to prefs as CURRENT_VERSION
      *  ---------------------------------------------------------------- */
    [prefs setObject:[[[[@"Version " stringByAppendingString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]] stringByAppendingString:@" ("] stringByAppendingString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]] stringByAppendingString:@")"] forKey:@"CURRENT_VERSION"];
    DLog(@"%@", [prefs objectForKey:@"CURRENT_VERSION"]);
    
    /* ----------------------------------------------------------------------------------
      *  Create audio session of category playback to cut out iPod/other audio
      *  Set it active to gracefully fade out the other audio and prepare for playing music later
      *  ---------------------------------------------------------------------------------- */
    [[AVAudioSession sharedInstance] setDelegate:self];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    DLog(@"Audio session created and activated");
    [[MPMusicPlayerController iPodMusicPlayer] stop];
    
    /* -------------------------------------------------------------
      *  Create global option items for vibration and accelerometer
      *  Add them to the global options instance and set default values
      *  ------------------------------------------------------------- */
    DGOptionItem *accelerometer = [[DGOptionItem alloc] initOptionWithTitle:@"Accelerometer" withDetail:@"Shake device for next prompt" ];
    DGOptionItem *vibration = [[DGOptionItem alloc] initOptionWithTitle:@"Vibration" withDetail:@"Next question vibrates device"];
    [[DGOptionsDropdown sharedInstance] setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"OptionsBackground"]]];
    [[DGOptionsDropdown sharedInstance] setItemHeight:50 withPrimaryHeight:64 leftItemInset:26];
    
    if ([[UIDevice currentDevice].platform rangeOfString:@"iPhone"].location == NSNotFound) {
        [[DGOptionsDropdown sharedInstance] addOptionItems:[[NSArray alloc] initWithObjects:accelerometer, nil]];
    }
    
    else {
        [[DGOptionsDropdown sharedInstance] addOptionItems:[[NSArray alloc] initWithObjects:accelerometer, vibration, nil]];
    }
    
    /* ----------------------------------------------------------------------------------------
      *  Initialize the main view controller as a navigation view controller without the navigation bar
      *  Set the root view controller of the window to be the navigation controller
      *  Set a portrait orientation for the whole application
      *  ---------------------------------------------------------------------------------------- */
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:[[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil]];
    self.navigationController.navigationBarHidden = YES;
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /* ------------------------------------------------------------------------
      *  Sent when the application is about to move from active to inactive state.
      *  This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
      *  Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates.
      *  Games should use this method to pause the game.
      *  ------------------------------------------------------------------------ */
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /* ------------------------------------------------------------------------
      *  Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
      *  If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
      *  ------------------------------------------------------------------------ */
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /* -------------------------------------------------------------------------
      *  Called as part of the transition from the background to the inactive state
      *  You can undo many of the changes made on entering the background here
      *  ------------------------------------------------------------------------- */
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /* ---------------------------------------------------------------------------------------
      *  Restart any tasks that were paused (or not yet started) while the application was inactive.
      *  If the application was previously in the background, optionally refresh the user interface.
      *  --------------------------------------------------------------------------------------- */
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /* ------------------------------------------------
      *  Called when the application is about to terminate
      *  Save data if appropriate
      *  ------------------------------------------------ */
}


@end
