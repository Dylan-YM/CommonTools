//
//  BaseConfig.h
//  AirTouch
//
//  Created by Devin on 1/16/15.
//  Copyright (c) 2015 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BaseConfig : NSObject
+(void)setValue:(NSString *)value withKey:(id)key;
+(NSString *)getValueString:(NSString *)key;
+(NSInteger)getValueInterger:(NSString *)key;
+(BOOL)getValueBool:(NSString *)key;
+(void)setInteger:(NSInteger)value withKey:(id)key;
+(void)setBool:(BOOL)value withKey:(id)key;

+(void)setDictionaryValue:(NSDictionary *)value withKey:(id)key;
+(NSDictionary *)getDictionaryValue:(NSString *)key;
+(void)clearValueObject:(NSString *)key;

@end
