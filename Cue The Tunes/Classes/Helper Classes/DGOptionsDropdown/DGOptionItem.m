//
//  DGOptionItem.m
//  DGOptionsDropdown
//
//  Created by Dylan Gattey on 8/12/11.
//  Copyright (c) 2011 Dylan Gattey. All rights reserved.
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
//  Class used to create a DGOptionItem for use in a DGOptionsDropdown

#import "DGOptionItem.h"

@implementation DGOptionItem

@synthesize itemTitleText = _itemTitleText, itemDetailText = _itemDetailText;

- (id)initOptionWithTitle:(NSString*)titleText withDetail:(NSString*)detailText {
	if ((self = [super init])) 
	{
		self.itemTitleText = titleText;
		self.itemDetailText = detailText;
	}
	return self;
}


@end
