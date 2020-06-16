//
//  CountryModel.h
//  AirTouch
//
//  Created by BobYang on 15/11/13.
//  Copyright © 2015年 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CountryModel : NSObject
@property (nonatomic, strong) NSString *ISOcountryCode;
@property (nonatomic, strong) NSString *countryPhoneNum;
@property (nonatomic, strong) NSString *nationalFlagImageName;
@property (nonatomic, strong) NSString *countryNameLocalKey;
@end
