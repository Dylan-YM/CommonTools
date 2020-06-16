//
//  UIView+ScreenShot.m
//  AirTouch
//
//  Created by Devin on 6/3/15.
//  Copyright (c) 2015 Honeywell. All rights reserved.
//

#import "UIView+ScreenShot.h"

@implementation UIView (ScreenShot)

- (UIImage *)snapshot
{
    CGSize size;
    if ([self isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self;
        size = scrollView.contentSize;
    } else {
        size = self.bounds.size;
    }
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    if ([self isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self;
        for (UIView *view in [scrollView subviews]) {
            CGRect frame = view.frame;
            [view drawViewHierarchyInRect:frame afterScreenUpdates:NO];
        }
    } else {
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
