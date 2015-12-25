//
//  LGCalendar.h
//  LGCalender
//
//  Created by jamy on 15/6/29.
//  Copyright (c) 2015年 jamy. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LGCalendar;
@protocol LGCalendarDelegate <NSObject>
@optional

- (void)LGCalendar:(LGCalendar *)calendar didSelectDate:(NSDate *)selectDate;

@end


typedef NS_OPTIONS(NSInteger, LGCalendarCellState) {
    LGCalendarCellStateNormal      = 0,
    LGCalendarCellStateSelected    = 1,
    LGCalendarCellStatePlaceholder = 1 << 1,
    LGCalendarCellStateToday       = 1 << 3,
    LGCalendarCellStateWeekend     = 1 << 4,
    LGCalenderCellStateRecord      = 1 << 5
};

@interface LGCalendar : UICollectionReusableView <UIAppearance>


@property (nonatomic, assign) id<LGCalendarDelegate> delegate;

@property (strong, nonatomic) NSDate *currentDate;
@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) NSDate *currentMonth;

@property (strong, nonatomic) UIFont   *titleFont                UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIFont   *subtitleFont             UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIFont   *weekdayFont              UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor  *eventColor               UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor  *weekdayTextColor         UI_APPEARANCE_SELECTOR;

@property (strong, nonatomic) UIColor  *headerTitleColor         UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) NSString *headerDateFormat         UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIFont   *headerTitleFont          UI_APPEARANCE_SELECTOR;

@property (strong, nonatomic) UIColor  *titleDefaultColor        UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor  *titleSelectionColor      UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor  *titleTodayColor          UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor  *titlePlaceholderColor    UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor  *titleWeekendColor        UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor  *titleRecordColor;

@property (strong, nonatomic) UIColor  *selectionColor           UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor  *todayColor               UI_APPEARANCE_SELECTOR;

@end
