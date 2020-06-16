//
//  HWVersonModel.h
//  AirTouch
//
//  Created by Honeywell on 2016/11/9.
//  Copyright © 2016年 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const NOTIFICATION_VERSON_STRING;

typedef void(^Version)(NSDictionary *updateDic, BOOL isForceUpdate , BOOL handleNow);

@interface HWVersionModel : NSObject

@property (nonatomic, strong, readonly) NSString *nextV;
@property (nonatomic, strong, readonly) NSString *nextBuild;
@property (nonatomic, strong, readonly) NSString *nowVersion;
@property (nonatomic, strong, readonly) NSString *releasenotes;
@property (nonatomic, assign, readonly) BOOL showNextV;
@property (nonatomic, assign, readonly) BOOL isForceUpdate;
@property (nonatomic, assign, readonly) BOOL showTabbarBadge;
@property (nonatomic, strong, readonly) NSString *appURL;

+ (instancetype)instance;

- (void)saveNextV;

- (void)checkV:(BOOL)isEnterForeground result:(Version)resultBlock;

@end
