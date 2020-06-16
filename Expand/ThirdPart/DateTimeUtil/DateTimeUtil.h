//
//  DateTimeUtil.h
//  AirTouch
//
//  Created by Devin on 1/14/15.
//  Copyright (c) 2015 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateTimeUtil : NSDateFormatter

+(DateTimeUtil *)instance;
-(NSString *)getNowDateTimeString;
-(NSDate *)getDateTimeFromString:(NSString *)dateTimeString;
- (NSInteger)compareCurrentTime:(NSDate*) compareDate;

//kenny add
+ (NSString *)getUTCFormateDate:(NSDate *)localDate;
+ (NSDate *)getDateFromUTCString:(NSString *)time;
//+ (NSDate *)getDateFromLocalString:(NSString *)time;
//+ (NSString *)getLocalStringFromUTCDate:(NSDate *)date;
+ (NSDate *)getDateFromLong:(long long)time;
+ (NSString *)getAuthorizationTimeStringFromUTCDate:(NSDate *)date;
//Xin Zhi 户外天气时间处理
//+ (NSString *)getXinZhiLocalFormateDate:(NSDate *)localDate;
+ (NSDate *)getXinZhiDateFromLocalString:(NSString *)time;
//+ (NSString *)getHourFromXinZhiFormateLocalString:(NSString *)time;
//+ (NSString *)getDayFromXinZhiFormateLocalString:(NSString *)time;
+(BOOL)isNightNow:(NSInteger)firstHour firstMin:(NSInteger)paramFirstMin secondHour:(NSInteger)paramSecondHour secondMin:(NSInteger)paramSecondMin;

+ (NSDate *)date2015;

+ (UInt32)secondsSince2015ForNow;

+ (UInt32)secondsSince2015ForDate:(NSDate *)date;

+ (NSDate *)dateWithTimeIntervalSince2015:(NSTimeInterval)timeIntervalSince2015;

//mad air 获取days天之前的日期数组(不包含今天)
+ (NSArray *)getMadAirDateStringArrayWithDays:(NSInteger)days;

//yyyy-MM-dd 是否是今天
+ (BOOL)madAirDateIsToday:(NSDate *)date;

+ (NSDate *)getLocaleDate;

+ (NSString *)getDateStringWithFormat:(NSDateFormatter *)formatter :(NSDate *)date;

+ (NSString *)getYYMMDDDateString:(NSDate *)date;

+ (NSString *)getYYMMDDHHMMSSDateString:(NSDate *)date;

+ (NSString *)getMMDDDateString:(NSDate *)date;

+ (NSString *)getHHMMDateString:(NSDate *)date;

//yyyy-MM-dd 距现在是否超过31天
+ (BOOL)checkDateStringOver31DaysFromNow:(NSString *)dateString;

+ (BOOL)checkDateOver31DaysFromNow:(NSDate *)date;

//yyyy-MM-dd 距现在是否超过今天
+ (BOOL)madAirDateIsOverToday:(NSDate *)date;

//yyyy-MM-dd 获取中间所有的日期
+ (NSArray *)getDateStringsFrom:(NSString *)fromDateString to:(NSString *)toDateString;

/**
 *  是否为今天
 */
+ (BOOL)isToday:(NSDate *)date calendar:(NSCalendar *)calendar;

/**
 *  是否为昨天
 */
+ (BOOL)isYesterday:(NSDate *)date calendar:(NSCalendar *)calendar;

/**
 *  是否为前天
 */
+ (BOOL)isTheDayBeforeYesterday:(NSDate *)date calendar:(NSCalendar *)calendar;

/**
 *  是否为今年
 */
+ (BOOL)isThisYear:(NSDate *)date calendar:(NSCalendar *)calendar;

//从毫秒数获取小时如：8：00
+ (NSString *)getHHStringWithLongDate:(long long)longDate;

+ (NSString *)getWeekdayFromLongDate:(long long)longDate;

@end
