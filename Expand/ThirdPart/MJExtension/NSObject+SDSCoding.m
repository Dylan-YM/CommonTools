//
//  NSObject+SDSCoding.m
//  SFShopDistributionSystem
//
//  Created by 春香焦 on 2017/6/22.
//  Copyright © 2017年 SFBest. All rights reserved.
//

#import "NSObject+SDSCoding.h"
#import "NSObject+MJCoding.h"

@implementation NSObject (SDSCoding)

- (void)sds_decodeWithCoder:(NSCoder *)decoder {
    
    [self mj_decode:decoder];
}

- (void)sds_encodeWithCoder:(NSCoder *)encoder {
    
    [self mj_encode:encoder];
}

@end
