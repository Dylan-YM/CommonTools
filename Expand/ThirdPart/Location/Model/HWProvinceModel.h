//
//  HWProvinceModel.h
//  Platform
//
//  Created by Honeywell on 2017/10/25.
//

#import <Foundation/Foundation.h>

@interface HWProvinceModel : NSObject

@property (nonatomic, copy) NSString *name;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
