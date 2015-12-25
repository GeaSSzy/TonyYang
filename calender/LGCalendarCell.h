//
//  LGCalendarCell.h
//  LGCalender
//
//  Created by jamy on 15/6/24.
//  Copyright (c) 2015年 jamy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGCalendarCell : UICollectionViewCell

@property (nonatomic, strong) NSDictionary *titleColors;
@property (nonatomic, strong) NSDictionary *backgroundColors;

@property (weak,   nonatomic) UIColor             *eventColor;

@property (copy,   nonatomic) NSDate              *date;
@property (copy,   nonatomic) NSDate              *month;
@property (weak,   nonatomic) NSDate              *currentDate;

@property (weak,   nonatomic) UILabel             *titleLabel;

@property (assign, nonatomic) BOOL                hasEvent;

@property (readonly, getter = isPlaceholder)      BOOL placeholder;

@property (strong ,nonatomic)NSArray *dateDay;

- (void)showAnimation;
- (void)hideAnimation;
- (void)configureCell;
@end
