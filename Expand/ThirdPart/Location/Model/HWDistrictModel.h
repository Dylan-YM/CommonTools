//
//  HWDistrictModel.h
//  Platform
//
//  Created by Honeywell on 2017/10/25.
//

#import <Foundation/Foundation.h>
#import "HWCityModel.h"

@interface HWDistrictModel : NSObject

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) HWCityModel *cityModel;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
