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

@implementation Cue_The_TunesAppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize savedPersistantID = _savedPersistantID;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //Init the main view controller and set it to the root of the navigation controller
    MainViewController *controller = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    self.navigationController.navigationBarHidden = YES;
    
    //Save current app version to prefs by creating string with version and build number, e.g. "Version 1.0 (23)"
    [prefs setObject:[[[[[[NSString alloc] initWithString:@"Version "] stringByAppendingString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]] stringByAppendingString:@" ("] stringByAppendingString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]] stringByAppendingString:@")"] forKey:@"CURRENT_VERSION"];
    
    //Setup Audio Session
    [[AVAudioSession sharedInstance] setDelegate:self];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    DLog(@"Audio session started");
    
    //Set navigation controller to root of window, then show the window
    self.window.rootViewController = self.navigationController;
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
    [self.window makeKeyAndVisible];
    
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    
    /*
     MPMusicPlayerController *musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    if ((musicPlayer.playbackState == MPMusicPlaybackStatePlaying || musicPlayer.playbackState == MPMusicPlaybackStatePaused) && [prefs boolForKey:@"PICKED"]) {
        self.savedPersistantID = [musicPlayer.nowPlayingItem valueForKey:MPMediaItemPropertyPersistentID];
    }
    */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    */     
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    */ 
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    /*
    [[MPMusicPlayerController applicationMusicPlayer] setShuffleMode: MPMusicShuffleModeOff];
    [[MPMusicPlayerController applicationMusicPlayer] setRepeatMode: MPMusicRepeatModeNone];
    
    [prefs setBool:NO forKey:@"PICKED"];
    
    if (self.savedPersistantID) {
        NSNumber *currentPersistantID = [[MPMusicPlayerController applicationMusicPlayer].nowPlayingItem valueForProperty:MPMediaItemPropertyPersistentID];
        if(![currentPersistantID compare:self.savedPersistantID] == NSOrderedSame) {
            [[MPMusicPlayerController applicationMusicPlayer] stop];
        }
    }
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


@end
