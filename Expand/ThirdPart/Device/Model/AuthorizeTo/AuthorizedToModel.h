//
//  AuthorizedToModel.h
//  HomePlatform
//
//  Created by BobYang on 16/04/2018.
//  Copyright © 2018 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthorizedToModel : NSObject

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString * username;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, assign) NSString * phoneNumber;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger authorizedType;

- (id)initWithDictionary:(NSDictionary *)dictionary;

- (void)updateWithDictionary:(NSDictionary *)dictionary;

@end
