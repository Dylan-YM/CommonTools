//
//  AP20Manager.h
//  HomePlatform
//
//  Created by Honeywell on 13/03/2018.
//  Copyright © 2018 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HWRequestProtocol.h"

typedef enum : NSUInteger {
    AP20TypeCubeC,
    AP20TypeNormal,
} AP20Type;

@interface AP20Manager : NSObject

@property (strong, nonatomic) NSString *macID;
@property (strong, nonatomic) NSString *deviceToken;
@property (assign, nonatomic) AP20Type type;

- (void)connectAPServerWithIpAddress:(NSString *)ipAddress port:(NSInteger)port callback:(HWAPICallBack)callback;

- (void)sendCommond:(NSDictionary *)command callBack:(HWAPICallBack)callBack;

- (void)resetStatus;

@end
