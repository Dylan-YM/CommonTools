//
//  BaseConfig.m
//  AirTouch
//
//  Created by Devin on 1/16/15.
//  Copyright (c) 2015 Honeywell. All rights reserved.
//

#import "BaseConfig.h"

static NSUserDefaults *userDefault=nil;

@implementation BaseConfig

+(void) initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Once-only initializion
        userDefault =[NSUserDefaults standardUserDefaults];
    });
}

+(NSString *)getValueString:(NSString *)key
{
    return [userDefault stringForKey:key];
}

+(NSInteger)getValueInterger:(NSString *)key
{
    return [userDefault integerForKey:key];
}

+(BOOL)getValueBool:(NSString *)key
{
    return [userDefault boolForKey:key];
}

+(void)setValue:(NSString *)value
        withKey:(id)key
{
    if (value) {
        [userDefault setObject:value forKey:key];
    } else {
        [BaseConfig clearValueObject:key];
    }
    [userDefault synchronize];
}

+(void)setInteger:(NSInteger)value withKey:(id)key
{
    [userDefault setInteger:value forKey:key];
    [userDefault synchronize];
}

+(void)setBool:(BOOL)value withKey:(id)key
{
    [userDefault setBool:value forKey:key];
    [userDefault synchronize];
}

+(void)setDictionaryValue:(NSDictionary *)value withKey:(id)key
{
    if (value) {
        [userDefault setObject:value forKey:key];
    } else {
        [BaseConfig clearValueObject:key];
    }
    [userDefault synchronize];
}

+(NSDictionary *)getDictionaryValue:(NSString *)key
{
    if (key) {
        return [userDefault dictionaryForKey:key];
    }
    return nil;
}

+(void)clearValueObject:(NSString *)key
{
    [userDefault removeObjectForKey:key];
}

@end
