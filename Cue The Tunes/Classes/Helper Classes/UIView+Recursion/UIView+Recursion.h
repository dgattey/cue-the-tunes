//
//  UIView+Recursion.h
//  Cue The Tunes
//
//  Created by Dylan Gattey on 12/21/11.
//  Copyright (c) 2011 Dylan Gattey. All rights reserved.
//
//  Class intended to allow searching of subviews of subviews, etc.

#import <UIKit/UIKit.h>

@interface UIView (Recursion)

- (NSMutableArray *)allSubviews;

@end
