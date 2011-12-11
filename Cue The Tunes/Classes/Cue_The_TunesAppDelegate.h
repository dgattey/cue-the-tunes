//
//  Cue_The_TunesAppDelegate.h
//  Cue The Tunes
//
//  Created by Dylan Gattey on 6/8/11.
//  Copyright 2011 Gattey/Azinger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cue_The_TunesAppDelegate : NSObject <UIApplicationDelegate, UIAlertViewDelegate, AVAudioSessionDelegate> {
    NSNumber *_savedPersistantID;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UINavigationController *navigationController;
@property (nonatomic, strong) NSNumber *savedPersistantID;

@end
