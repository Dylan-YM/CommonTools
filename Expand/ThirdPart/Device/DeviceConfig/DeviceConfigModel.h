//
//  DeviceConfigModel.h
//  HomePlatform
//
//  Created by Honeywell on 2018/9/7.
//  Copyright © 2018 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceConfigModel : NSObject

@property (nonatomic, strong) NSString *renamePlaceholder;
@property (nonatomic, strong) NSString *deviceCategoryString;
@property (nonatomic, assign) BOOL onlineAsParent;
@property (nonatomic, assign) BOOL powerAsParent;
@property (nonatomic, strong) NSDictionary *sku;
@property (nonatomic, strong) NSString *controlPageName;

- (id)initWithDictionary:(NSDictionary *)params;

@end
