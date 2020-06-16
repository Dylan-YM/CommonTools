//
//  HWCityModel.h
//  Platform
//
//  Created by Honeywell on 2017/10/25.
//

#import <Foundation/Foundation.h>
#import "HWProvinceModel.h"

@interface HWCityModel : NSObject

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) HWProvinceModel *provinceModel;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
