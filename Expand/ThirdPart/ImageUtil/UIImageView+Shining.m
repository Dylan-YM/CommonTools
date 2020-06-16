//
//  UIImageView+Shining.m
//  AirTouch
//
//  Created by kenny on 15/6/12.
//  Copyright (c) 2015年 Honeywell. All rights reserved.
//

#import "UIImageView+Shining.h"
#import "CryptoUtil.h"

CGFloat const lowerPeriodBound = 3;
CGFloat const upperPeriodBound = 5;

@implementation UIImageView (Shining)

-(void)shineFromOpacity:(CGFloat)originAlpha
{
    CGFloat period = [self period];
    CABasicAnimation * fadeAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnim.fromValue = @(originAlpha);
    fadeAnim.toValue = @(0.3);
    fadeAnim.duration = period;
    fadeAnim.repeatCount = HUGE_VALF;
    fadeAnim.autoreverses = YES;
    
    [self.layer addAnimation:fadeAnim forKey:@"alpha"];
}

-(void)stopShinning
{
    [self.layer removeAnimationForKey:@"alpha"];
}

-(void)shineByHalosEffect
{
    if ([self.layer.animationKeys containsObject:@"halos"]) {
        return;
    }
    CABasicAnimation * fadeAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnim.fromValue = @(0);
    fadeAnim.toValue = @(1);
    fadeAnim.duration = 0.5;
    fadeAnim.repeatCount = 1;
    fadeAnim.autoreverses = YES;
    fadeAnim.fillMode = kCAFillModeForwards;
    fadeAnim.removedOnCompletion = YES;
    
    [self.layer addAnimation:fadeAnim forKey:@"halos"];
}

-(void)stopShinningByHalosEffect
{
    [self.layer removeAnimationForKey:@"halos"];
}

/**
 *  闪烁周期 3-5s
 *
 *  @return time
 */
-(CGFloat)period
{
    return lowerPeriodBound + [self randomNumber] * (upperPeriodBound - lowerPeriodBound);
}

-(double)randomNumber
{
    return (double)([CryptoUtil randomInt])/0x100000000;
}

@end
