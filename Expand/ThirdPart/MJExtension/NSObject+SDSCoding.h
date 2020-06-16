//
//  NSObject+SDSCoding.h
//  SFShopDistributionSystem
//
//  Created by 春香焦 on 2017/6/22.
//  Copyright © 2017年 SFBest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SDSCoding)

/// 解码（从文件中解析对象）
- (void)sds_decodeWithCoder:(NSCoder *)decoder;
/// 编码（将对象写入文件中
- (void)sds_encodeWithCoder:(NSCoder *)encoder;

@end
