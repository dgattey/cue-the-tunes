//
//  UIDevice+Hardware.h
//  Cue The Tunes
//
//  Created by Dylan Gattey on 2/27/12.
//  Copyright (c) 2012 Dylan Gattey. All rights reserved.
//

#define IPHONE_1G_NAMESTRING @"iPhone 1G"
#define IPHONE_3G_NAMESTRING @"iPhone 3G"
#define IPHONE_3GS_NAMESTRING @"iPhone 3GS"
#define IPOD_1G_NAMESTRING @"iPod touch 1G"
#define IPOD_2G_NAMESTRING @"iPod touch 2G"

@interface UIDevice (Hardware)
- (NSString *) platform;
- (NSString *) platformString;
@end