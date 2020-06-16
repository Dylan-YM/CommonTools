//
//  HomeManager.m
//  AirTouch
//
//  Created by BobYang on 16/1/26.
//  Copyright © 2016年 Honeywell. All rights reserved.
//

#import "HomeManager.h"
#import "AppManager.h"
#import "UserEntity.h"
#import "HomeModel.h"
#import "VirtualHomeModel.h"
#import "UserConfig.h"

@implementation HomeManager

- (HomeLoadingStatus)homeLoadingStatus {
    return [UserEntity instance].homeLoadingStatus;
}

- (NSArray *)getRealHomes {
    UserEntity *entity = [UserEntity instance];
    NSArray *allEntites = [entity allEntites];
    return allEntites;
}

- (NSArray *)getDashboardTabHomes {
    NSMutableArray *newArray = [NSMutableArray array];
    [newArray addObjectsFromArray:[self getRealHomes]];
    
    return newArray;
}

- (NSArray *)getDevicesTabHomes {
    NSMutableArray *newArray = [NSMutableArray array];
    [newArray addObjectsFromArray:[self getRealHomes]];
    
    return newArray;
}

- (void)addLocation:(NSString *)name  completion:(HomeBlock)completion {
    UserEntity * user = [UserEntity instance];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (name) {
        [dict setValue:name forKey:@"name"];
    }

    [user addLocation:dict resultBlock:completion];
}
- (void)addLocation:(NSString *)name city:(NSString *)city state:(NSString *)state district:(NSString *)district street:(NSString *)street completion:(HomeBlock)completion {
    UserEntity * user = [UserEntity instance];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (name) {
        [dict setValue:@"" forKey:@"name"];
    }
    if (city) {
        [dict setValue:city forKey:@"city"];
    }
    if (state) {
        [dict setValue:state forKey:@"state"];
    }
    if (district) {
        [dict setValue:district forKey:@"district"];
    }
    if (street) {
        [dict setValue:street forKey:@"street"];
    }
    [user addLocation:dict resultBlock:completion];
}

- (void)editLocation:(HomeModel *)homeModel withNewName:(NSString *)newName city:(NSString *)city state:(NSString *)state district:(NSString *)district street:(NSString *)street completion:(HomeBlock)completion {
    UserEntity * user = [UserEntity instance];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (newName) {
        [dict setValue:newName forKey:@"newName"];
    }
    if (city) {
        [dict setValue:city forKey:@"city"];
    }
    if (state) {
        [dict setValue:state forKey:@"state"];
    }
    if (district) {
        [dict setValue:district forKey:@"district"];
    }
    if (street) {
        [dict setValue:street forKey:@"street"];
    }
    [user editLocation:homeModel params:dict resultBlock:completion];
}

- (void)deleteLocation:(HomeModel *)homeModel completion:(HomeBlock)completion {
    UserEntity * user = [UserEntity instance];
    [user deleteLocation:homeModel resultBlock:completion];
}

- (void)setDefaultLocation:(HomeModel *)homeModel completion:(HomeBlock)completion {
    UserEntity * user = [UserEntity instance];
    [user setDefaultLocation:homeModel resultBlock:completion];
}

@end
