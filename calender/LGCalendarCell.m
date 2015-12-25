//
//  LGCalendarCell.m
//  LGCalender
//
//  Created by jamy on 15/6/24.
//  Copyright (c) 2015年 jamy. All rights reserved.
//

#import "LGCalendarCell.h"
#import "NSDate+calender.h"
#import "UIVew+LGExtension.h"
#import "LGCalendar.h"
#import "HistoryDataTVController.h"
#import "LGCalendarHeadView.h"
#import "TYhelper.h"

#define kAnimationDuration 0.15

@interface LGCalendarCell ()
@property (strong,   nonatomic) CAShapeLayer *backgroundLayer;
@property (readonly, nonatomic) BOOL         today;
@property (readonly, nonatomic) BOOL         weekend;
@end

@implementation LGCalendarCell
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = [UIColor darkTextColor];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        _backgroundLayer = [CAShapeLayer layer];
        _backgroundLayer.backgroundColor = [UIColor clearColor].CGColor;
        _backgroundLayer.hidden = YES;
        [self.contentView.layer insertSublayer:_backgroundLayer atIndex:0];
    }
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"calender" ofType:@"json"];
//    NSString *str = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
//    NSArray *dateArray = [dict objectForKey:@"days"];
    
//        NSString *path = [[NSString alloc] initWithFormat:@"http://175.130.116.203:10080/body/calender/2015-12"];
//        NSURL *url = [NSURL URLWithString:path];
//    
//        //SyncGet
//        NSString *calenderStr = [TYhelper syncGet:url];
//        NSData *jsonData = [calenderStr dataUsingEncoding:NSUTF8StringEncoding];
//        NSDictionary *calenderDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
//        NSArray *dateArray = [calenderDict objectForKey:@"days"];
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *ourDocumentPath = [documentPaths objectAtIndex:0];
    NSString *calenderFile = @"calender.json";
    NSString *FileName = [ourDocumentPath stringByAppendingPathComponent:calenderFile];
    
    NSString *readStr = [[NSString alloc] initWithContentsOfFile:FileName encoding:NSUTF8StringEncoding error:nil];
    NSData *jsonData = [readStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    NSArray *dateArray = [dict objectForKey:@"days"];
    
    
    NSLog(@"Array is %@",dateArray);
    self.dateDay = dateArray;

    return self;
}


-(void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    CGFloat titleHeight = self.bounds.size.height;
    CGFloat diameter = MIN(titleHeight, self.bounds.size.width);
    _backgroundLayer.frame = CGRectMake((self.bounds.size.width-diameter)/2,
                                        (titleHeight-diameter)/2,
                                        diameter,
                                        diameter);
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    [CATransaction setDisableActions:YES];
}

- (void)showAnimation
{
    _backgroundLayer.hidden = NO;
    _backgroundLayer.path = [UIBezierPath bezierPathWithOvalInRect:_backgroundLayer.bounds].CGPath;
    _backgroundLayer.fillColor = [self colorForCurrentStateInDictionary:_backgroundColors].CGColor;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    CABasicAnimation *zoomOut = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    zoomOut.fromValue = @0.3;
    zoomOut.toValue = @1.2;
    zoomOut.duration = kAnimationDuration*3/4;
    
    CABasicAnimation *zoomIn = [CABasicAnimation animationWithKeyPath:@"transfrom.scale"];
    zoomIn.fromValue = @1.2;
    zoomIn.toValue = @1.0;
    zoomIn.beginTime = kAnimationDuration*3/4;
    zoomIn.duration = kAnimationDuration/4;
    
    group.duration = kAnimationDuration;
    group.animations = @[zoomOut, zoomIn];
    [_backgroundLayer addAnimation:group forKey:@"bounce"];
    
    [self configureCell];
}

- (void)hideAnimation
{
    _backgroundLayer.hidden = YES;
    [self configureCell];
}


- (void)configureCell
{
    _titleLabel.text = [NSString stringWithFormat:@"%ld", (long)_date.currentDay];
    _titleLabel.textColor = [self colorForCurrentStateInDictionary:_titleColors];
    _backgroundLayer.fillColor = [self colorForCurrentStateInDictionary:_backgroundColors].CGColor;
    
    _titleLabel.frame = CGRectMake(0, 0, self.myWidth, self.myHeight);
    
    _backgroundLayer.hidden = !self.selected && !self.isToday && !self.isRecord;
    _backgroundLayer.path = [UIBezierPath bezierPathWithOvalInRect:_backgroundLayer.bounds].CGPath;
}


-(BOOL)isToday
{
    return _date.currentYear == _currentDate.currentYear && _date.currentMonth == _currentDate.currentMonth && _date.currentDay == _currentDate.currentDay;
}

- (BOOL)isPlaceholder
{
    return !(_date.currentYear == _month.currentYear && _date.currentMonth == _month.currentMonth);
}

- (BOOL)isWeekend
{
    return self.date.currentWeekDay ==7 || self.date.currentWeekDay == 6;
}

- (BOOL)isRecord
{
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"calender" ofType:@"json"];
//    NSString *str = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
//    NSArray *dateArray = [dict objectForKey:@"days"];
    
//    NSString *path = [[NSString alloc] initWithFormat:@"http://175.130.116.203:10080/body/calender/2015-12"];
//    NSURL *url = [NSURL URLWithString:path];
//    
//    //SyncGet
//    NSString *calenderStr = [TYhelper syncGet:url];
//    NSData *jsonData = [calenderStr dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *calenderDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
//    NSArray *dateArray = [calenderDict objectForKey:@"days"];
    
    
//    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *ourDocumentPath = [documentPaths objectAtIndex:0];
//    NSString *calenderFile = @"calender.txt";
//    NSData *fileData = [NSData dataWithContentsOfFile:calenderFile];
//    NSDictionary *calenderDict = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingMutableLeaves error:nil];
//    NSArray *dateArray = [calenderDict objectForKey:@"days"];
//    NSLog(@"Array is %@",dateArray);
    
    NSDateFormatter *testFormatter = [[NSDateFormatter alloc] init];
    [testFormatter setDateFormat:@"yyyy-MM-dd"];
    for (NSString *days in self.dateDay) {
        NSDate *dayDate = [testFormatter dateFromString:days];
        NSLog(@"testDate is %@",dayDate);
    
        if (_date.currentYear == dayDate.currentYear && _date.currentMonth == dayDate.currentMonth && _date.currentDay == dayDate.currentDay){
            return 1;
        }
    }
    return 0;
}


- (UIColor *)colorForCurrentStateInDictionary:(NSDictionary *)dictionary
{
    if (self.isSelected) {
        return dictionary[@(LGCalendarCellStateSelected)];
    }
    if (self.isToday) {
        return dictionary[@(LGCalendarCellStateToday)];
    }
    if (self.isPlaceholder) {
        return dictionary[@(LGCalendarCellStatePlaceholder)];
    }
    if (self.isWeekend && [[dictionary allKeys] containsObject:@(LGCalendarCellStateWeekend)]) {
        return dictionary[@(LGCalendarCellStateWeekend)];
    }
    if (self.isRecord){
        return dictionary[@(LGCalenderCellStateRecord)];
    }
    return dictionary[@(LGCalendarCellStateNormal)];
}

@end
