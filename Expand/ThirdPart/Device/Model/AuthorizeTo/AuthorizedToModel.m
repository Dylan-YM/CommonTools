//
//  AuthorizedToModel.m
//  HomePlatform
//
//  Created by BobYang on 16/04/2018.
//  Copyright © 2018 Honeywell. All rights reserved.
//

#import "AuthorizedToModel.h"

@implementation AuthorizedToModel

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        [self updateWithDictionary:dictionary];
    }
    return self;
}

- (void)updateWithDictionary:(NSDictionary *)dictionary {
    NSArray *keys = [dictionary allKeys];
    if ([keys containsObject:@"userId"]) {
        self.userId = [dictionary[@"userId"]integerValue];
    }
    if ([keys containsObject:@"userName"]) {
        self.username = dictionary[@"userName"];
    }
    if ([keys containsObject:@"userGender"]) {
        self.gender = [dictionary[@"userGender"]integerValue];
    }
    if ([keys containsObject:@"phoneNumber"]) {
        self.phoneNumber = dictionary[@"phoneNumber"];
    }
    if ([keys containsObject:@"status"]) {
        self.status = [dictionary[@"status"]integerValue];
    }
    if ([keys containsObject:@"authorizedType"]) {
        self.authorizedType = [dictionary[@"authorizedType"]integerValue];
    }
}

@end
