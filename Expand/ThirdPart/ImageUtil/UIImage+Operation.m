//
//  UIImage+Operation.m
//  AirTouch
//
//  Created by Liu, Carl on 8/15/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "UIImage+Operation.h"

@implementation UIImage (Operation)

- (UIImage *)scale:(CGFloat)scale {
    CGSize size = CGSizeMake(self.size.width*scale, self.size.height*scale);
    return [self scaleToSize:size];
}

- (UIImage *)scaleToSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)clipWithFrame:(CGRect)frame
{
    CGImageRef imageRef = self.CGImage;
    imageRef = CGImageCreateWithImageInRect(imageRef, frame);
    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return sendImage;
}

- (UIImage *)overlayImage:(UIImage *)image frame:(CGRect)frame {
    CGSize size = self.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    [image drawInRect:frame];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)concatImage:(UIImage *)image {
    CGSize size = CGSizeMake(MAX(self.size.width, image.size.width), self.size.height+image.size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    [image drawInRect:CGRectMake(0, self.size.height, image.size.width, image.size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
