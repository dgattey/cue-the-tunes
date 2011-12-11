//
//  DGOptionItem.m
//  DGOptionsDropdown
//
//  Created by Dylan Gattey on 8/12/11.
//  Copyright 2010 Dylan Gattey. All rights reserved.
//
//	Code adapted from ScaryBugs programming tutorial
//

#import "DGOptionItem.h"

@implementation DGOptionItem

@synthesize itemTitleText = _itemTitleText, itemDetailText = _itemDetailText, itemSwitch = _itemSwitch;

- (id)initOptionWithTitle:(NSString*)titleText withDetail:(NSString*)detailText withSwitch:(UISwitch*)optionSwitch
{
	if ((self = [super init])) 
	{
		_itemTitleText = titleText;
		_itemDetailText = detailText;
		_itemSwitch = optionSwitch;
	}
	return self;
}


@end
