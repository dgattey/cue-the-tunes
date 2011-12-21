//
//  UIView+Recursion.m
//  Cue The Tunes
//
//  Created by Dylan Gattey on 12/21/11.
//  Copyright (c) 2011 Dylan Gattey. All rights reserved.
//

#import "UIView+Recursion.h"

@implementation UIView (Recursion)

- (NSMutableArray *)allSubviews {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:self];
    for (UIView *subview in self.subviews) {
        [array addObjectsFromArray:(NSArray*)[subview allSubviews]];
    }
         return array;
}

@end
