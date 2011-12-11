//
//  DGActionSheet.h
//  Cue The Tunes
//
//  Created by Dylan Gattey on 8/15/11.
//  Copyright 2011 Dylan Gattey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DGActionSheet : UIView
+ (void)setupActionSheet:(UIView*)actionSheet overlay:(UIView*)overlay newGameButton:(UIButton*)newGameButton continueGameButton:(UIButton*)continueGameButton cancelButton:(UIButton*)cancelButton inView:(UIView*)theView;
+ (void)displayActionSheet:(UIView*)actionSheet overlay:(UIView*)overlay;
+ (void)dismissActionSheet:(UIView*)actionSheet overlay:(UIView*)overlay;

@end
