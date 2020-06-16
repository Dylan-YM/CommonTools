//
//  DateTimeUtil.m
//  AirTouch
//
//  Created by Devin on 1/14/15.
//  Copyright (c) 2015 Honeywell. All rights reserved.
//

#import "DateTimeUtil.h"


static DateTimeUtil *_instance=NULL;

@implementation DateTimeUtil

+(DateTimeUtil *)instance
{
    if(_instance==NULL)
    {
        _instance=[[DateTimeUtil alloc]init];
        [_instance setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return _instance;
}

+ (NSString *)getAccuratedToSecondsTimeString:(NSString *)originalTimeString
{
    //yyyy-MM-dd'T'HH:mm:ss.SSS
    NSInteger stringLength = 5 + 3 * 5 - 1;
    if (originalTimeString.length < stringLength) {
        return nil;
    }
    return [originalTimeString substringToIndex:stringLength];
}

-(NSString *)getNowDateTimeString
{
    return [self stringFromDate:[NSDate date]];
}

-(NSDate *)getDateTimeFromString:(NSString *)dateTimeString
{
    return [self dateFromString:dateTimeString];
}

//天津那边要求改动的方法
+ (NSString *)getUTCFormateDate:(NSDate *)localDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];//yyyy-MM-dd'T'HH:mm:ssZ
    return [dateFormatter stringFromDate:localDate];
}

+(NSDate *)getDateFromUTCString:(NSString *)time
{
    NSString * truncatedTime = [[self class]getAccuratedToSecondsTimeString:time];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
     NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];//yyyy-MM-dd'T'HH:mm:ssZZZ
    [dateFormatter setLocale:[NSLocale systemLocale]];
    return [dateFormatter dateFromString:truncatedTime];
}

//+(NSDate *)getDateFromLocalString:(NSString *)time
//{
//    NSString * truncatedTime = [[self class]getAccuratedToSecondsTimeString:time];
//    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
//    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
//    [dateFormatter setTimeZone:timeZone];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];//yyyy-MM-dd'T'HH:mm:ssZZZ
//    [dateFormatter setLocale:[NSLocale systemLocale]];
//    return [dateFormatter dateFromString:truncatedTime];
//}

//+(NSString *)getLocalStringFromUTCDate:(NSDate *)date
//{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
//    [dateFormatter setTimeZone:timeZone];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];//yyyy-MM-dd'T'HH:mm:ssZ
//    return [dateFormatter stringFromDate:date];
//}

+ (NSDate *)getDateFromLong:(long long)time
{
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:time/1000.0];
    return date;
}

+ (NSString *)getAuthorizationTimeStringFromUTCDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];//yyyy-MM-dd'T'HH:mm:ssZ
    NSString * timeString = [dateFormatter stringFromDate:date];
    return timeString;
}

//心知
//+(NSString *)getXinZhiLocalFormateDate:(NSDate *)localDate
//{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setLocale:[NSLocale systemLocale]];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];//yyyy-MM-dd'T'HH:mm:ssZ
//    return [dateFormatter stringFromDate:localDate];
//}

+(NSDate *)getXinZhiDateFromLocalString:(NSString *)time
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];//yyyy-MM-dd'T'HH:mm:ssZZZ
    [dateFormatter setLocale:[NSLocale systemLocale]];
    return [dateFormatter dateFromString:time];
}

    
+(BOOL)isNightNow:(NSInteger)firstHour firstMin:(NSInteger)paramFirstMin secondHour:(NSInteger)paramSecondHour secondMin:(NSInteger)paramSecondMin
{
    NSDate * now = [NSDate date];
    NSCalendar * cal = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents * todayComps = [cal components:unitFlags fromDate:now];
    
    NSDateComponents *fireComps = [[NSDateComponents alloc] init];
    [fireComps setDay:todayComps.day];
    [fireComps setMonth:todayComps.month];
    [fireComps setYear:todayComps.year];
    [fireComps setHour:firstHour];
    [fireComps setMinute:paramFirstMin];
    [fireComps setSecond:0];
    NSDate * morningDate = [cal dateFromComponents:fireComps];
    
    NSDateComponents *nightComps = [[NSDateComponents alloc] init];
    [nightComps setDay:todayComps.day];
    [nightComps setMonth:todayComps.month];
    [nightComps setYear:todayComps.year];
    [nightComps setHour:paramSecondHour];
    [nightComps setMinute:paramSecondMin];
    [nightComps setSecond:0];
    NSDate * nightDate = [cal dateFromComponents:nightComps];
    if ([now compare:morningDate]==NSOrderedDescending && [now compare:nightDate]==NSOrderedAscending) {
        return NO;
    }else
    {
        return YES;
    }
}

/**
 *  比较时间前后
 *
 *  @param compareDate 要比较的时间
 *
 *  @return return value >0 ,compareDate 早于 当前时间
 */
- (NSInteger)compareCurrentTime:(NSDate*) compareDate
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    return timeInterval/60;
}

+ (NSDate *)date2015 {
    NSString * date2015 = @"2015/01/01 00:00:00";
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone * timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate * date = [dateFormatter dateFromString:date2015];
    return date;
}

+ (UInt32)secondsSince2015ForNow {
    NSDate * now = [NSDate date];
    UInt32 seconds = [self secondsSince2015ForDate:now];
    return seconds;
}

+ (UInt32)secondsSince2015ForDate:(NSDate *)date {
    NSDate * date2015 = [self date2015];
    UInt32 seconds = [date timeIntervalSinceDate:date2015];
    return seconds;
}

+ (NSDate *)dateWithTimeIntervalSince2015:(NSTimeInterval)timeIntervalSince2015 {
    NSDate * date2015 = [self date2015];
    NSDate * targetDate = [NSDate dateWithTimeInterval:timeIntervalSince2015 sinceDate:date2015];
    return targetDate;
}

+ (NSArray *)getMadAirDateStringArrayWithDays:(NSInteger)days {
    NSMutableArray *dateArray = [NSMutableArray array];
    NSDate *firstDate = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)*days];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    for (NSInteger i = 0; i < days; i++) {
        NSDate *lastDay = [NSDate dateWithTimeInterval:24*60*60*i sinceDate:firstDate];
        
        NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:lastDay];
        NSInteger year = [dateComponent year];
        NSInteger month = [dateComponent month];
        NSInteger day = [dateComponent day];
        NSString *monthString = (month >= 10) ? [NSString stringWithFormat:@"%ld",(long)month] : [NSString stringWithFormat:@"0%ld",(long)month];
        NSString *dayString = (day >= 10) ? [NSString stringWithFormat:@"%ld",(long)day] : [NSString stringWithFormat:@"0%ld",(long)day];
        NSString *dateString = [NSString stringWithFormat:@"%ld-%@-%@",(long)year,monthString,dayString];
        [dateArray addObject:dateString];
    }
    return dateArray;
}

+ (BOOL)madAirDateIsToday:(NSDate *)date {
    NSDate *localeDate = [DateTimeUtil getLocaleDate];
    double intervalTime = [localeDate timeIntervalSinceReferenceDate] - [date timeIntervalSinceReferenceDate];
    if (intervalTime < 24*60*60 && intervalTime >= 0) {
        return YES;
    }
    return NO;
}

+ (BOOL)madAirDateIsOverToday:(NSDate *)date {
    NSDate *localeDate = [self getLocaleDate];
    double intervalTime = [localeDate timeIntervalSinceReferenceDate] - [date timeIntervalSinceReferenceDate];
    if (intervalTime < 0) {
        return YES;
    }
    return NO;
}

+ (NSDate *)getLocaleDate {
    NSDate *now = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:now];
    NSDate *localeDate = [now  dateByAddingTimeInterval: interval];
    return localeDate;
}

+ (NSString *)getDateStringWithFormat:(NSDateFormatter *)formatter :(NSDate *)date{
    return [formatter stringFromDate:date];
}

+ (NSString *)getYYMMDDDateString:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [self getDateStringWithFormat:dateFormatter :date];
}

+ (NSString *)getYYMMDDHHMMSSDateString:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [self getDateStringWithFormat:dateFormatter :date];
}

+ (NSString *)getMMDDDateString:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"MM-dd"];
    return [self getDateStringWithFormat:dateFormatter :date];
}

+ (NSString *)getHHMMDateString:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"HH:mm"];
    return [self getDateStringWithFormat:dateFormatter:date];
}

+ (BOOL)checkDateStringOver31DaysFromNow:(NSString *)dateString {
    NSString *dateFormat = @"yyyy-MM-dd";
    NSDate *localeDate = [self getLocaleDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:dateFormat];
    NSDate *date = [dateFormatter dateFromString:dateString];
    double intervalTime = [localeDate timeIntervalSinceReferenceDate] - [date timeIntervalSinceReferenceDate];
    if (intervalTime > 31*24*60*60) {
        return YES;
    }
    return NO;
}

+ (BOOL)checkDateOver31DaysFromNow:(NSDate *)date {
    NSDate *localeDate = [self getLocaleDate];
    double intervalTime = [localeDate timeIntervalSinceReferenceDate] - [date timeIntervalSinceReferenceDate];
    if (intervalTime > 31*24*60*60) {
        return YES;
    }
    return NO;
}

+ (NSArray *)getDateStringsFrom:(NSString *)fromDateString to:(NSString *)toDateString {
    NSMutableArray *resultArray = [NSMutableArray array];
    [resultArray addObject:fromDateString];
    
    NSString *dateFormat = @"yyyy-MM-dd";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:dateFormat];
    NSDate *fromDate = [dateFormatter dateFromString:fromDateString];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    for (NSInteger i = 1; i < NSIntegerMax; i++) {
        NSDate *lastDay = [NSDate dateWithTimeInterval:24*60*60*i sinceDate:fromDate];
        
        NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:lastDay];
        NSInteger year = [dateComponent year];
        NSInteger month = [dateComponent month];
        NSInteger day = [dateComponent day];
        NSString *monthString = (month >= 10) ? [NSString stringWithFormat:@"%ld",(long)month] : [NSString stringWithFormat:@"0%ld",(long)month];
        NSString *dayString = (day >= 10) ? [NSString stringWithFormat:@"%ld",(long)day] : [NSString stringWithFormat:@"0%ld",(long)day];
        NSString *dateString = [NSString stringWithFormat:@"%ld-%@-%@",(long)year,monthString,dayString];
        [resultArray addObject:dateString];
        if ([dateString isEqualToString:toDateString]) {
            break;
        }
    }
    return resultArray;
}

+ (BOOL)isToday:(NSDate *)date calendar:(NSCalendar *)calendar {
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    // 2.获得date的年月日
    NSDateComponents *dateCmps = [calendar components:unit fromDate:date];
    return ((dateCmps.year == nowCmps.year) && (dateCmps.month == nowCmps.month) && (dateCmps.day == nowCmps.day));
}

+ (BOOL)isYesterday:(NSDate *)date calendar:(NSCalendar *)calendar {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [fmt setTimeZone:timeZone];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [self getYYMMDDDateString:date];
    NSDate *insertDate = [fmt dateFromString:dateStr];
    
    NSString *nowStr = [fmt stringFromDate:[NSDate date]];
    NSDate *nowDate = [fmt dateFromString:nowStr];
    
    // 获得nowDate和insertDate的差距
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:insertDate toDate:nowDate options:0];
    return (cmps.day == 1);
}

+ (BOOL)isTheDayBeforeYesterday:(NSDate *)date calendar:(NSCalendar *)calendar {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [fmt setTimeZone:timeZone];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [self getYYMMDDDateString:date];
    NSDate *insertDate = [fmt dateFromString:dateStr];
    
    NSString *nowStr = [fmt stringFromDate:[NSDate date]];
    NSDate *nowDate = [fmt dateFromString:nowStr];
    
    // 获得nowDate和insertDate的差距
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:insertDate toDate:nowDate options:0];
    return (cmps.day == 2);
}

+ (BOOL)isThisYear:(NSDate *)date calendar:(NSCalendar *)calendar {
    int unit = NSCalendarUnitYear;
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    // 2.获得date的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:date];
    return (nowCmps.year == selfCmps.year);
}

+ (NSString *)getHHStringWithLongDate:(long long)longDate {
    NSDate *date = [self getDateFromLong:longDate];
    if (date == nil) {
        return @"";
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitDay | NSCalendarUnitHour) fromDate:date];
    NSInteger day = [components day];
    NSInteger hour = [components hour];
    
    NSDate *now = [NSDate date];
    NSDateComponents *nowComponents = [calendar components:(NSCalendarUnitDay | NSCalendarUnitHour) fromDate:now];
    NSInteger nowDay = [nowComponents day];
    NSInteger nowHour = [nowComponents hour];
    
    if (nowDay == day && nowHour == hour) {
        return NSLocalizedString(@"common_now", nil);
    } else {
        return [NSString stringWithFormat:@"%li:00",(long)hour];
    }
}

+ (NSString *)getWeekdayFromLongDate:(long long)longDate {
    NSDate *date = [self getDateFromLong:longDate];
    if (date == nil) {
        return @"";
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:date];
    NSInteger weekday = [components weekday];
    
    NSDate *now = [NSDate date];
    NSDateComponents *nowComponents = [calendar components:NSCalendarUnitWeekday fromDate:now];
    NSInteger nowWeekday = [nowComponents weekday];
    if (weekday == nowWeekday) {
        return NSLocalizedString(@"common_today", nil);
    } else {
        switch (weekday) {
            case 1:
                return NSLocalizedString(@"common_sunday", nil);
            case 2:
                return NSLocalizedString(@"common_monday", nil);
            case 3:
                return NSLocalizedString(@"common_tuesday", nil);
            case 4:
                return NSLocalizedString(@"common_wednesday", nil);
            case 5:
                return NSLocalizedString(@"common_thursday", nil);
            case 6:
                return NSLocalizedString(@"common_friday", nil);
            case 7:
                return NSLocalizedString(@"common_saturday", nil);
            default:
                return @"";
        }
    }
}

@end
