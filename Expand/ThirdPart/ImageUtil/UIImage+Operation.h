//
//  UIImage+Operation.h
//  AirTouch
//
//  Created by Liu, Carl on 8/15/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Operation)

- (UIImage *)scale:(CGFloat)scale;

- (UIImage *)scaleToSize:(CGSize)size;

- (UIImage *)clipWithFrame:(CGRect)frame;

/**
 *  overlay another image onto this image.
 *
 *  @param image overlay image
 *  @param frame rect to overlay image
 *  @return image after overlay
 */
- (UIImage *)overlayImage:(UIImage *)image frame:(CGRect)frame;

/**
 *  concat this image with another image.
 *
 *  @param image bottom image
 *  -----
 *  | 1 |
 *  | 2 |
 *  -----
 *  @return image after concat
 */
- (UIImage *)concatImage:(UIImage *)image;

@end
