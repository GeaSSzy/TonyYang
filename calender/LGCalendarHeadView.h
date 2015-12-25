//
//  LGCalendarHeadView.h
//  LGCalender
//
//  Created by jamy on 15/6/23.
//  Copyright (c) 2015年 jamy. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXTERN NSString *const KDateChangeNotification;

@interface LGCalendarHeadView : UICollectionReusableView

@property (assign  , nonatomic) CGFloat scrollOffset;
@property (strong  , nonatomic) NSDate  *minimumDate;
@property (strong  , nonatomic) NSDate  *maximumDate;
@property (strong  , nonatomic) NSString *calenderStr;

- (NSArray *)gotRecordForCurrentMonth;
- (NSString *)gotCalenderStr;

@end
