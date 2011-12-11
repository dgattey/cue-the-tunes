//
//  DGOptionItem.h
//  DGOptionsDropdown
//
//  Created by Dylan Gattey on 8/12/11.
//  Copyright 2010 Dylan Gattey. All rights reserved.
//
//	Code adapted from ScaryBugs programming tutorial
//

#import <Foundation/Foundation.h>

@interface DGOptionItem : NSObject
{
	NSString *_itemTitleText;
	NSString *_itemDetailText;
	UISwitch *_itemSwitch;
}

@property (strong) NSString *itemTitleText;
@property (strong) NSString *itemDetailText;
@property (strong) UISwitch *itemSwitch;

- (id)initOptionWithTitle:(NSString*)titleText withDetail:(NSString*)detailText withSwitch:(UISwitch*)optionSwitch;

@end
