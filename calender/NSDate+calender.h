//
//  NSDate+calender.h
//  LGCalender
//
//  Created by jamy on 15/6/21.
//  Copyright (c) 2015年 jamy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (calender)

-(NSInteger)currentYear;

- (NSInteger)currentMonth;

- (NSInteger)currentDay;

- (NSInteger)currentWeekDay;

- (NSInteger)numberOFdateFrom:(NSDate *)date;

/**
 *  计算这个月有多少天
 *
 *  @return 天数
 */
- (NSUInteger)numberOfDaysInMonth;


- (NSDate *)dayInPreviousYear;

- (NSDate *)dayInFollowYear;

/**
 *  计算这个月的第一天
 *
 *  @return 第一天的date对象
 */
-(NSDate *)firstDayOfcurrentMonth;

/**
 *  计算这个月的最后一天
 *
 *  @return 返回最后一天的对象
 */
-(NSDate *)lastDayOfCurrentMonth;

/**
 *  计算上一个月的date
 *
 *  @return 返回上一个月的date对象
 */
- (NSDate *)dayInPreviousMonth;

/**
 *  计算下一个月date
 *
 *  @return 返回下一个月的date对象
 */
- (NSDate *)dayInFollowMonth;

/**
 *  计算当前日期之后的第几个月
 *
 *  @param month 月数
 *
 *  @return 第几个月的时间对象
 */
- (NSDate *)dayInTheFollowMouth:(NSInteger)month;


- (NSDate *)dayInPreviousWithCount:(NSInteger)count;

/**
 *  计算当前日期之后的第几天
 *
 *  @param day 天数
 *
 *  @return 当前日期之后第几天的时间对象
 */
- (NSDate *)dayInFollowDay:(NSInteger)day;

/**
 *  NSString 转 NSDate
 *
 *  @param dateString 时间字符串
 *
 *  @return NSDate对象
 */
- (NSDate *)dateFromString:(NSString *)dateString;

/**
 *  NSdate 转 NSString
 *
 *  @param date 时间对象
 *
 *  @return STR对象
 */
+ (NSString *)stringFromDate:(NSDate *)date;

/**
 *  根据制定的年月日计算的时间
 *
 *  @param year  年
 *  @param month 月
 *  @param day   ri
 *
 *  @return 返回制定年月日的时间对象
 */
+ (NSDate *)dateWithYear:(int)year month:(int)month day:(int)day;

/**
 *  计算从当前时间到指定时间的月数
 *
 *  @param date 制定时间
 *
 *  @return 月数
 */
-(NSInteger)numberOfmunthFromDate:(NSDate *)date;
@end
