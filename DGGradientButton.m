//
//  DGGradientButton.m
//  Cue The Tunes
//
//  Created by Dylan Gattey on 12/15/11.
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

#import "DGGradientButton.h"

@implementation DGGradientButton

+ (UIImage *) newImageFromMaskImage:(UIImage *)mask inColor:(UIColor *) color {
    CGImageRef maskImage = mask.CGImage;
    CGFloat width = mask.size.width;
    CGFloat height = mask.size.height;
    CGRect bounds = CGRectMake(0,0,width,height);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL, width, height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
    CGContextClipToMask(bitmapContext, bounds, maskImage);
    
    CGImageRef mainViewContentBitmapContext = CGBitmapContextCreateImage(bitmapContext);
    CGContextRelease(bitmapContext);
    
    UIImage *result = [UIImage imageWithCGImage:mainViewContentBitmapContext];

    CGRect rect = (CGRect){ .size = mask.size};
    
    UIGraphicsBeginImageContext( mask.size );
        {
        CGContextRef X = UIGraphicsGetCurrentContext();
        
        // draw image
        [mask drawInRect: rect];
        
        // overlay a rectangle
        CGContextSetBlendMode( X, kCGBlendModeOverlay ) ;
        const float *array = CGColorGetComponents([color CGColor]);
        CGContextSetRGBFillColor (X, array[0], array[1], array[2], array[3]);
        CGContextFillRect ( X, rect );
        
        // redraw gem 
        [mask drawInRect: rect
                blendMode: kCGBlendModeDestinationIn
                    alpha: 1. ];
        
        result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    }
    
    return result;
}

@end
