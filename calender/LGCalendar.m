//
//  LGCalendar.m
//  LGCalender
//
//  Created by jamy on 15/6/29.
//  Copyright (c) 2015年 jamy. All rights reserved.
//

#import "LGCalendar.h"
#import "LGCalendarCell.h"
#import "LGCalendarHeadView.h"
#import "NSDate+calender.h"
#import "UIVew+LGExtension.h"
#import "LGCalendarHeadView.h"

#define kWeekHeight roundf(self.myHeight/9)

@interface LGCalendar () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) NSMutableArray             *weekdays;

@property (strong, nonatomic) NSMutableDictionary        *backgroundColors;
@property (strong, nonatomic) NSMutableDictionary        *titleColors;
@property (strong, nonatomic) NSMutableDictionary        *subtitleColors;

@property (weak  , nonatomic) CALayer                    *topBorderLayer;
@property (weak  , nonatomic) CALayer                    *bottomBorderLayer;
@property (weak  , nonatomic) UICollectionView           *collectionView;
@property (weak  , nonatomic) UICollectionViewFlowLayout *collectionViewFlowLayout;
@property (weak  , nonatomic) LGCalendarHeadView           *header;

@property (strong, nonatomic) NSDate                     *minimumDate;
@property (strong, nonatomic) NSDate                     *maximumDate;
@end

@implementation LGCalendar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _titleFont        = [UIFont systemFontOfSize:15];
    _subtitleFont     = [UIFont systemFontOfSize:10];
    _weekdayFont      = [UIFont systemFontOfSize:15];
    _headerTitleFont  = [UIFont systemFontOfSize:15];
    _headerTitleColor = [UIColor blueColor];
    
    NSArray *weekSymbols = [[NSCalendar currentCalendar] shortStandaloneWeekdaySymbols];
    _weekdays = [NSMutableArray arrayWithCapacity:weekSymbols.count];
    for (int i = 0; i < weekSymbols.count; i++) {
        UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        weekdayLabel.text = weekSymbols[i];
        weekdayLabel.textAlignment = NSTextAlignmentCenter;
        weekdayLabel.font = _weekdayFont;
        weekdayLabel.textColor = [UIColor blueColor];
        [_weekdays addObject:weekdayLabel];
        [self addSubview:weekdayLabel];
    }
    
    LGCalendarHeadView *header = [[LGCalendarHeadView alloc] init];
    [self addSubview:header];
    self.header = header;
    
    self.minimumDate = [NSDate dateWithYear:1970 month:1 day:1];
    self.maximumDate = [NSDate dateWithYear:2099 month:12 day:31];
    
    _header.minimumDate = self.minimumDate;
    _header.maximumDate = self.maximumDate;
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    self.collectionViewFlowLayout = layout;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.bounces = YES;
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.delaysContentTouches = NO;
    collectionView.canCancelContentTouches = YES;
    [collectionView registerClass:[LGCalendarCell class] forCellWithReuseIdentifier:@"calendercell"];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    _currentDate = [NSDate date];
    _currentMonth = [_currentDate copy];
    
    _backgroundColors = [NSMutableDictionary dictionaryWithCapacity:5];
    _backgroundColors[@(LGCalendarCellStateNormal)]      = [UIColor clearColor];
    _backgroundColors[@(LGCalendarCellStateSelected)]    = [UIColor blueColor];
    _backgroundColors[@(LGCalendarCellStatePlaceholder)] = [UIColor clearColor];
    _backgroundColors[@(LGCalendarCellStateToday)]       = [UIColor redColor];
    _backgroundColors[@(LGCalenderCellStateRecord)]      = [UIColor greenColor];
    
    _titleColors = [NSMutableDictionary dictionaryWithCapacity:6];
    _titleColors[@(LGCalendarCellStateNormal)]      = [UIColor blackColor];
    _titleColors[@(LGCalendarCellStateSelected)]    = [UIColor whiteColor];
    _titleColors[@(LGCalendarCellStatePlaceholder)] = [UIColor lightGrayColor];
    _titleColors[@(LGCalendarCellStateToday)]       = [UIColor whiteColor];
    _titleColors[@(LGCalendarCellStateWeekend)]       = [UIColor purpleColor];
    _titleColors[@(LGCalenderCellStateRecord)]        = [UIColor whiteColor];
    
    CALayer *topBorderLayer = [CALayer layer];
    topBorderLayer.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2].CGColor;
    [self.layer addSublayer:topBorderLayer];
    self.topBorderLayer = topBorderLayer;
    
    CALayer *bottomBorderLayer = [CALayer layer];
    bottomBorderLayer.backgroundColor = _topBorderLayer.backgroundColor;
    [self.layer addSublayer:bottomBorderLayer];
    self.bottomBorderLayer = bottomBorderLayer;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dateDidChange:) name:KDateChangeNotification object:nil];

    dispatch_async(dispatch_get_main_queue(), ^{
       self.selectedDate = [NSDate date];
    });
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dateDidChange:(NSNotification *)note
{
    NSDictionary *userInfo = note.userInfo;
    NSDate *newDate = (NSDate *)userInfo[@"userInfoKey"];
    if (newDate) {
          self.selectedDate = newDate;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat padding = self.myHeight * 0.01;

    self.header.frame = CGRectMake(0, 0, self.myWidth, self.myHeight/8.0);

    _collectionView.frame = CGRectMake(0, kWeekHeight+_header.myHeight, self.myWidth, self.myHeight-kWeekHeight-_header.myHeight);
    _collectionView.contentInset = UIEdgeInsetsZero;
    _collectionViewFlowLayout.itemSize = CGSizeMake(
                                                    _collectionView.myWidth/7,
                                                    (_collectionView.myHeight-padding*2)/6
                                                    );
    _collectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(padding, 0, padding, 0);
    
    CGFloat width = self.myWidth/_weekdays.count;
    CGFloat height = kWeekHeight;
    [_weekdays enumerateObjectsUsingBlock:^(UILabel *weekdayLabel, NSUInteger idx, BOOL *stop) {
        NSUInteger absoluteIndex = (idx)%7;
        weekdayLabel.frame = CGRectMake(absoluteIndex*weekdayLabel.myWidth,
                                        _header.myHeight,
                                        width,
                                        height);
    }];
}

#pragma mark -collectionView datasource/delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [_maximumDate numberOfmunthFromDate:_minimumDate];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 42;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LGCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"calendercell" forIndexPath:indexPath];
    
    cell.titleColors        = self.titleColors;
    cell.backgroundColors   = self.backgroundColors;
    cell.eventColor         = self.eventColor;
    cell.month              = [_minimumDate dayInTheFollowMouth:indexPath.section];
    cell.currentDate        = self.currentDate;
    cell.titleLabel.font    = _titleFont;
    cell.date               = [self dateFormIndexPath:indexPath];
    [cell configureCell];

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LGCalendarCell *cell = (LGCalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell showAnimation];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(LGCalendar:didSelectDate:)]) {
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate:cell.date];
        NSDate *localDate = [cell.date dateByAddingTimeInterval:interval];
        [self.delegate LGCalendar:self didSelectDate:localDate];
    }
}


-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LGCalendarCell *cell = (LGCalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell hideAnimation];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scrollOffset = MAX(scrollView.contentOffset.x/scrollView.myWidth,
                               scrollView.contentOffset.y/scrollView.myHeight);
    
    _header.scrollOffset = scrollOffset;
}



#pragma mark -other

-(void)setSelectedDate:(NSDate *)selectedDate
{
    [self setSelectedDate:selectedDate animation:NO];
}


- (void)setSelectedDate:(NSDate *)selectedDate animation:(BOOL)animate
{
    NSIndexPath *selectedIndexPath = [self indexPathFormDate:selectedDate];
    
    [self.collectionView selectItemAtIndexPath:selectedIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    [self collectionView:_collectionView didSelectItemAtIndexPath:selectedIndexPath];
    
    if (!self.collectionView.tracking && !self.collectionView.decelerating) {
        [self scrollToDate:selectedDate animate:NO];
    }
}

-(void)setCurrentDate:(NSDate *)currentDate
{
    [self scrollToDate:currentDate animate:NO];
}

- (void)scrollToDate:(NSDate *)date animate:(BOOL)animate
{
    NSInteger offset = [date numberOfmunthFromDate:_minimumDate];
    
    [self.collectionView setContentOffset:CGPointMake(offset * self.collectionView.myWidth, 0) animated:animate];
  
    if (_header.scrollOffset != offset) {
        [_header setScrollOffset:offset];
    }
    
    _currentMonth = [_selectedDate copy];
    [_collectionView reloadData];
}


- (NSDate *)dateFormIndexPath:(NSIndexPath *)indexPath
{
    NSDate *currentMonth = [_minimumDate dayInTheFollowMouth:indexPath.section];
    NSDate *firstDateOfmonth = [currentMonth firstDayOfcurrentMonth];
    NSInteger numberInpreMonth = firstDateOfmonth.currentWeekDay%7?:7;
    NSDate *firstDateOfPage = [firstDateOfmonth dayInPreviousWithCount:numberInpreMonth];
    
    NSDate *date;
    NSInteger rows = indexPath.item % 6;
    NSInteger column = indexPath.item / 6;
    date = [firstDateOfPage dayInFollowDay:7*rows+column];
    
    return date;
}

- (NSIndexPath *)indexPathFormDate:(NSDate *)date
{
    NSInteger section = [date numberOfmunthFromDate:_minimumDate];
    NSDate *firstDateOfmonth = [date firstDayOfcurrentMonth];
    NSInteger numberInpreMonth = firstDateOfmonth.currentWeekDay%7?:7;
    NSDate *firstDateOfPage = [firstDateOfmonth dayInPreviousWithCount:numberInpreMonth];
    
    NSInteger item = 0;
    NSInteger item2 = [date numberOfmunthFromDate:firstDateOfPage];
    NSInteger row = item2/7;
    NSInteger column = item2%7;
    item = column*6+row;
    
    return [NSIndexPath indexPathForItem:item inSection:section];
}

@end
