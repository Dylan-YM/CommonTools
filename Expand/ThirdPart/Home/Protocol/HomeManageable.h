//
//  HomeManageable.h
//  Services
//
//  Created by Liu, Carl on 21/12/2016.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeConfig.h"

typedef void(^HomeBlock)(id object, NSError *error);

@class HomeModel;

@protocol HomeManageable <NSObject>

- (HomeLoadingStatus)homeLoadingStatus;

- (NSArray *)getRealHomes;

- (NSArray *)getDashboardTabHomes;

- (NSArray *)getDevicesTabHomes;
- (void)addLocation:(NSString *)name  completion:(HomeBlock)completion;
- (void)addLocation:(NSString *)name city:(NSString *)city state:(NSString *)state district:(NSString *)district street:(NSString *)street completion:(HomeBlock)completion;

- (void)editLocation:(HomeModel *)homeModel withNewName:(NSString *)newName city:(NSString *)city state:(NSString *)state district:(NSString *)district street:(NSString *)street completion:(HomeBlock)completion;

- (void)deleteLocation:(HomeModel *)homeModel completion:(HomeBlock)completion;

- (void)setDefaultLocation:(HomeModel *)homeModel completion:(HomeBlock)completion;

@end
