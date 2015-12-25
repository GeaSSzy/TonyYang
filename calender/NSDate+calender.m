//
//  NSDate+calender.m
//  LGCalender
//
//  Created by jamy on 15/6/21.
//  Copyright (c) 2015年 jamy. All rights reserved.
//

#import "NSDate+calender.h"

@implementation NSDate (calender)

-(NSInteger)currentYear
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *cps = [cal components:NSCalendarUnitYear fromDate:self];
    return cps.year;
}

- (NSInteger)currentMonth
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *cps = [cal components:NSCalendarUnitMonth fromDate:self];
    return cps.month;
}

- (NSInteger)currentDay
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *cps = [cal components:NSCalendarUnitDay fromDate:self];
    return cps.day;
}

- (NSInteger)currentWeekDay
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *cps = [cal components:NSCalendarUnitWeekday fromDate:self];
    return cps.weekday;
}

- (NSInteger)numberOFdateFrom:(NSDate *)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *cps = [cal components:NSCalendarUnitDay fromDate:date toDate:self options:0];
    return cps.day;
}

/**
 *  计算这个月有多少天
 *
 *  @return 天数
 */
- (NSUInteger)numberOfDaysInMonth
{
    return [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self].length;
}

/**
 *  计算这个月的第一天
 *
 *  @return 第一天的date对象
 */
-(NSDate *)firstDayOfcurrentMonth
{
    NSDate *stateDate = nil;
    BOOL result = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitMonth startDate:&stateDate interval:NULL forDate:self];
    if (!result) {
        return nil;
    }
    return stateDate;
}

/**
 *  计算这个月的最后一天
 *
 *  @return 返回最后一天的对象
 */
-(NSDate *)lastDayOfCurrentMonth
{
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:unit fromDate:self];
    dateComponents.day = [self numberOfDaysInMonth];
    
    return [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
}

/**
 *  计算上一个月的date
 *
 *  @return 返回上一个月的date对象
 */
- (NSDate *)dayInPreviousMonth
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

- (NSDate *)dayInPreviousYear
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = -1;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

- (NSDate *)dayInFollowYear
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = 1;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

/**
 *  计算下一个月date
 *
 *  @return 返回下一个月的date对象
 */
- (NSDate *)dayInFollowMonth
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = 1;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

/**
 *  计算当前日期之后的第几个月
 *
 *  @param month 月数
 *
 *  @return 第几个月的时间对象
 */
- (NSDate *)dayInTheFollowMouth:(NSInteger)month
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = month;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

/**
 *  计算当前日期之后的第几天
 *
 *  @param day 天数
 *
 *  @return 当前日期之后第几天的时间对象
 */
- (NSDate *)dayInFollowDay:(NSInteger)day
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = day;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

- (NSDate *)dayInPreviousWithCount:(NSInteger)count
{
    return [self dayInFollowDay:-count];
}


/**
 *  NSString 转 NSDate
 *
 *  @param dateString 时间字符串
 *
 *  @return NSDate对象
 */
- (NSDate *)dateFromString:(NSString *)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}

-(NSInteger)numberOfmunthFromDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *cps = [calendar components:NSCalendarUnitMonth fromDate:date toDate:self options:0];
    
    return cps.month;
}

+ (NSDate *)dateWithYear:(int)year month:(int)month day:(int)day
{
    NSDateComponents *cps = [[NSDateComponents alloc] init];
    cps.year = year;
    cps.month = month;
    cps.day = day;
    
    return [[NSCalendar currentCalendar] dateFromComponents:cps];
}

/**
 *  NSdate 转 NSString
 *
 *  @param date 时间对象
 *
 *  @return STR对象
 */
+ (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *str = [formatter stringFromDate:date];
    
    return str;
}

@end
