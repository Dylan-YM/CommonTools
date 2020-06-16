//
//  HWNotificationObject.h
//  AirTouch
//
//  Created by Carl on 3/30/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWNotificationObject : NSObject

@property (nonatomic, strong) NSString *alert;
@property (nonatomic, strong) NSString *messageType;
@property (nonatomic, assign) long long messageID;
@property (nonatomic, assign) NSInteger messageCategory;
@property (nonatomic, copy) NSString *locationId;
@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, strong) NSString *messageContent;
@property (nonatomic, strong) NSDictionary *msgData;

@property (nonatomic, strong) NSArray *jumpPages;
@property (nonatomic, assign) BOOL isKnownType;
@property (nonatomic, assign) BOOL isNeedCheckDevice;
@property (nonatomic, assign) BOOL clickNotification;

- (id)initWithDictionary:(NSDictionary *)dictionary;
//+ (NSString *)displayTextInDetailPage:(HWNotificationType)type;

@end
