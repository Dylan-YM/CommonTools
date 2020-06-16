//
//  HWVersonModel.m
//  AirTouch
//
//  Created by Honeywell on 2016/11/9.
//  Copyright © 2016年 Honeywell. All rights reserved.
//

#import "HWVersionModel.h"
#import "AppMarco.h"
#import "DateTimeUtil.h"
#import "AppConfig.h"
#import "UserConfig.h"
#import "WhatsNewAPIRequest.h"
#import "NetworkUtil.h"

#define kLastClickedUserDefaultVerson @"kLastClickedUserDefaultVerson"

NSString * const NOTIFICATION_VERSON_STRING = @"NOTIFICATION_VERSON_STRING";

@interface HWVersionModel ()

@property (nonatomic, assign) BOOL checked;
@property (nonatomic, assign) BOOL forceUpdate;
@property (nonatomic, strong) NSString *nextV;
@property (nonatomic, strong) NSString *nextBuild;
@property (nonatomic, strong) NSString *nowVersion;
@property (nonatomic, strong) NSString *displayversion;
@property (nonatomic, strong) NSString *minVersion;
@property (nonatomic, strong) NSString *appURL;
@property (nonatomic, strong) NSString *releasenotescn;
@property (nonatomic, strong) NSString *releasenotesen;
@property (nonatomic, strong) NSArray *needToUpdateList;

@property (nonatomic, strong) WhatsNewAPIRequest *whatsNewsAPIRequest;

@end

@implementation HWVersionModel

+(HWVersionModel *)instance
{
    static HWVersionModel *sharedInstance = nil;
    if (sharedInstance == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedInstance = [[HWVersionModel alloc]init];
        });
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        sharedInstance.nowVersion = [infoDict objectForKey:@"CFBundleVersion"];
    }
    return sharedInstance;
}

- (void)updateWithDictionary:(NSDictionary *)dictionary {
    if ([dictionary.allKeys containsObject:@"displayversion"]) {
        self.nextV = [dictionary objectForKey:@"displayversion"];
    }
    if ([dictionary.allKeys containsObject:@"version"]) {
        self.nextBuild = [dictionary objectForKey:@"version"];
    }
    if ([dictionary.allKeys containsObject:@"appURL"]) {
        self.appURL = [dictionary objectForKey:@"appURL"];
    }
    if ([dictionary.allKeys containsObject:kUpdateForceUpdate]) {
        self.forceUpdate = [[dictionary objectForKey:kUpdateForceUpdate] boolValue];
    }
    if ([dictionary.allKeys containsObject:kUpdateMinVersion]) {
        self.minVersion = [dictionary objectForKey:kUpdateMinVersion];
    }
    if ([dictionary.allKeys containsObject:kUpdateNeedUpdaeList]) {
        self.needToUpdateList = [dictionary objectForKey:kUpdateNeedUpdaeList];
    }
    if ([dictionary.allKeys containsObject:kUpdateReleasenotescn]) {
        self.releasenotescn = [dictionary objectForKey:kUpdateReleasenotescn];
    }
    if ([dictionary.allKeys containsObject:kUpdateReleasenotesen]) {
        self.releasenotesen = [dictionary objectForKey:kUpdateReleasenotesen];
    }
}

- (BOOL)showTabbarBadge {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([self compareV:self.nowVersion newV:self.nextBuild]) {
        NSString *lastV = [userDefault stringForKey:kLastClickedUserDefaultVerson];
        if (!lastV || (lastV && [self compareV:lastV newV:self.nextBuild])) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

- (void)saveNextV {
    [[NSUserDefaults standardUserDefaults] setObject:self.nextBuild forKey:kLastClickedUserDefaultVerson];
}

- (BOOL)showNextV {
    if ([self compareV:self.nowVersion newV:self.nextBuild]) {
        return YES;
    }
    return NO;
}

- (NSString *)nextV {
    return _nextV;
}

- (NSString *)nextBuild {
    return _nextBuild;
}

- (NSString *)nowVersion {
    return _nowVersion;
}

- (NSString *)releasenotes {
    if ([AppConfig isEnglish]) {
        return self.releasenotesen;
    } else {
        return self.releasenotescn;
    }
}

- (void)checkV:(BOOL)isEnterForeground result:(Version)resultBlock
{
    if (!isEnterForeground && self.checked) {
        //如果是启动时的调用或断网后连上网的调用，并且之前有检查过更新，则直接返回
        return;
    }
    runOnBackground(^{
        NSDictionary *localSaveVersionInfo = [UserConfig getCloudVersionInfo];
        NSDate *lastDate = [[DateTimeUtil instance] getDateTimeFromString:[localSaveVersionInfo objectForKey:kUpdateLastTime]];
        NSInteger timeInterval=[[DateTimeUtil instance] compareCurrentTime:lastDate];
        CGFloat timeIntervalDayUnit = timeInterval*1.0/(60*24);
        if (lastDate && (timeIntervalDayUnit <1) && isEnterForeground) {
            //use local data
            [self afterCheck:localSaveVersionInfo isEnterForeground:isEnterForeground resultBlock:resultBlock];
        } else {
            [self.whatsNewsAPIRequest callAPIWithParam:nil completion:^(id object, NSError *error) {
                NSDictionary* compareVersionDict;
                //use cloud data
                if (!object) {
                    compareVersionDict = localSaveVersionInfo;
                } else {
                    compareVersionDict = object;
                    NSMutableDictionary *saveTimeDict = [[NSMutableDictionary alloc] initWithDictionary:compareVersionDict];
                    //添加时间戳，一天一更新
                    NSString *nowTime = [[DateTimeUtil instance] getNowDateTimeString];
                    [saveTimeDict setObject:nowTime forKey:kUpdateLastTime];
                    [UserConfig setCloudVersionInfo:saveTimeDict];
                    self.checked = YES;
                }
                [self afterCheck:compareVersionDict isEnterForeground:isEnterForeground resultBlock:resultBlock];
            }];
        }
    });
}

- (void)afterCheck:(NSDictionary *)compareVersionDict isEnterForeground:(BOOL)isEnterForeground resultBlock:(Version)resultBlock {
    BOOL handleNow = NO;
    if (compareVersionDict) {
        [self updateWithDictionary:compareVersionDict];
        BOOL isForceUpdate = [self isForceUpdate];
        NSDate *lastDate = [[DateTimeUtil instance] getDateTimeFromString:[AppConfig getPopNewVTime]];
        if (!isForceUpdate && lastDate && [[DateTimeUtil instance] compareCurrentTime:lastDate]/(60*24) < 7 && [self compareV:self.nowVersion newV:self.nextBuild]) {
            handleNow = NO;
        } else if (isForceUpdate || !isEnterForeground) {
            if([self compareV:self.nowVersion newV:self.nextBuild])
            {
                handleNow = YES;
            }
        }
    }
    runOnMainThread(^{
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_VERSON_STRING object:self];
        resultBlock(compareVersionDict,[self isForceUpdate],handleNow);
    });
}

/**
 Compare version
 @param nowVersion nowVersion description
 @param newV newV description
 @return need update or not
 */
- (BOOL)compareV:(NSString *)nowVersion newV:(NSString *)newV
{
    if (!newV || !nowVersion) {
        return NO;
    }
    BOOL result = [newV compare:nowVersion options:NSNumericSearch] == NSOrderedDescending;
    return result;
}

- (BOOL)isForceUpdate {
    BOOL needForceUpdate = self.forceUpdate;
    BOOL isSmallerThanMinVersion = NO;
    if ([self.minVersion length] > 0) {
        isSmallerThanMinVersion = [self compareV:self.nowVersion newV:self.minVersion];
    }
    BOOL isNeedUpdaeVersion = NO;
    if (self.needToUpdateList) {
        isNeedUpdaeVersion = [self.needToUpdateList containsObject:self.nowVersion];
    }
    BOOL isForceUpdate = needForceUpdate || isSmallerThanMinVersion || isNeedUpdaeVersion;
    return isForceUpdate;
}

- (WhatsNewAPIRequest *)whatsNewsAPIRequest {
    if (!_whatsNewsAPIRequest) {
        _whatsNewsAPIRequest = [[WhatsNewAPIRequest alloc] init];
    }
    return _whatsNewsAPIRequest;
}

@end
