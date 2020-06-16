//
//  HWNotificationObject.m
//  AirTouch
//
//  Created by Carl on 3/30/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "HWNotificationObject.h"
#import "IContainerViewControllerDelegate.h"
#import "WebSocketConfig.h"
#import "LogUtil.h"

@implementation HWNotificationObject

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        [LogUtil Debug:@"push object" message:dictionary];
        self.isKnownType = YES;
        self.isNeedCheckDevice = NO;
        self.jumpPages = nil;
        NSArray * allKeys = [dictionary allKeys];
        if ([allKeys containsObject:@"aps"]) {
            if ([dictionary[@"aps"][@"alert"] isKindOfClass:[NSString class]]) {
                self.alert = dictionary[@"aps"][@"alert"];
            }
        }
        if ([allKeys containsObject:@"msgType"]) {
            self.messageType = dictionary[@"msgType"];
        }
        if ([allKeys containsObject:@"msgData"]) {
            if ([dictionary[@"msgData"] isKindOfClass:[NSDictionary class]]) {
                self.msgData = dictionary[@"msgData"];
            } else if ([dictionary[@"msgData"] isKindOfClass:[NSString class]]) {
                NSString *jsonString = dictionary[@"msgData"];
                id object = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:NULL];
                if (object && [object isKindOfClass:[NSDictionary class]]) {
                    self.msgData = (NSDictionary *)object;
                }
            }
            
            if (self.msgData) {
                if ([[self.msgData allKeys] containsObject:@"id"]) {
                    self.messageID = [self.msgData[@"id"] longLongValue];
                }
                if ([[self.msgData allKeys] containsObject:@"content"]) {
                    self.messageContent = self.msgData[@"content"];
                }
            }
        }
    }
    return self;
}

- (void)setMessageType:(NSString *)messageType {
    _messageType = messageType;
    self.jumpPages = @[@(HWPageMessageDetail)];
    
    if ([[self authorizeMessageType] containsObject:self.messageType]) {
        self.messageCategory = 1;
    } else if ([self.messageType isEqualToString:kWebSocketMessageTypeText]) {
        self.jumpPages = @[@(HWPageMessageCenter)];
        self.messageCategory = 9;
    } else if ([self.messageType isEqualToString:kWebSocketMessageTypeAlarmNotify]) {
        self.jumpPages = @[@(HWPageLocation),@(HWPageShowAlarm)];
        self.messageCategory = 9;
    } else if ([self.messageType isEqualToString:kWebSocketMessageTypeAlarmDelete]
               || [self.messageType isEqualToString:kWebSocketMessageTypeUserLogin]) {
        self.jumpPages = @[];
    }
    else if ([[self createEventMessageType] containsObject:self.messageType]) {
        self.jumpPages = @[];
    }
    else if ([self.messageType isEqualToString:kWebsocketMessageTypeEventNew]) {
        self.jumpPages = @[@(HWPageLocation),@(HWPageShowEvent)];
        self.messageCategory = 9;
    }
    else {
        self.isKnownType = NO;
        self.isNeedCheckDevice = NO;
    }
}

- (NSArray *)authorizeMessageType {
    return @[kWebSocketMessageTypeAuthorityAccept,
             kWebSocketMessageTypeAuthorityGrant,
             kWebSocketMessageTypeAuthorityReject,
             kWebSocketMessageTypeAuthorityRemove,
             kWebSocketMessageTypeAuthorityRevoke,
             kWebSocketMessageTypeAuthorityEdit];
}

- (NSArray *)alarmMessageType {
    return @[kWebSocketMessageTypeAlarmNotify,
             kWebSocketMessageTypeAlarmDelete];
}

- (NSArray *)createEventMessageType {
    return @[kWebSocketMessageTypeLocationScenarioSwitched];
}

@end
