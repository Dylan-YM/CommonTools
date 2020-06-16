//
//  ColorImageUtil.m
//  EnrollmentDemo
//
//  Created by liunan on 1/10/15.
//  Copyright (c) 2015 honeywell. All rights reserved.
//

#import "ColorImageUtil.h"

@implementation ColorImageUtil

+ (UIImage*) createImageWithColor: (UIColor*) color
{
    CGFloat r,g,b,a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextSetAlpha(UIGraphicsGetCurrentContext(), a);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
