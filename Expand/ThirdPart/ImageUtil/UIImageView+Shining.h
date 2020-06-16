//
//  UIImageView+Shining.h
//  AirTouch
//
//  Created by kenny on 15/6/12.
//  Copyright (c) 2015年 Honeywell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Shining)

-(void)shineFromOpacity:(CGFloat)originAlpha;
-(void)stopShinning;
-(void)shineByHalosEffect;
-(void)stopShinningByHalosEffect;
@end
