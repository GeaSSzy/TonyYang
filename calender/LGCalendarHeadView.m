//
//  LGCalendarHeadView.m
//  LGCalender
//
//  Created by jamy on 15/6/23.
//  Copyright (c) 2015年 jamy. All rights reserved.
//

#import "LGCalendarHeadView.h"
#import "UIVew+LGExtension.h"
#import "NSDate+calender.h"
#import "LGCalendarButton.h"
#import "TYhelper.h"

NSString *const KDateChangeNotification = @"KDateChangeNotificationName";

@interface LGCalendarHeadView ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionFlowLayout;
@property (nonatomic, strong) NSMutableArray *headerBtnArray;
@property (nonatomic, strong) NSDate *currentDate;
- (NSArray *)gotRecordForCurrentMonth;
@end


@implementation LGCalendarHeadView

@synthesize calenderStr;

-(NSMutableArray *)headerBtnArray
{
    if (_headerBtnArray == nil) {
        _headerBtnArray = [NSMutableArray array];
    }
    return _headerBtnArray;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    self.collectionFlowLayout = flowLayout;
    
    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40) collectionViewLayout:flowLayout];
    collection.scrollEnabled = YES;
    collection.userInteractionEnabled = YES;
    collection.bounces = YES;
    collection.pagingEnabled = YES;
    collection.backgroundColor = [UIColor clearColor];
    collection.dataSource = self;
    collection.delegate = self;
    [collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"headCell"];
    [self addSubview:collection];
    self.collectionView = collection;

    [self setupBtn];
}

- (void)setupBtn
{
    for (int i = 0; i < 4; i++) {
        LGCalendarButton *headerBtn = [[LGCalendarButton alloc] init];
        headerBtn.tag = i;
        [self addSubview:headerBtn];
        [headerBtn addTarget:self action:@selector(headerClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerBtnArray addObject:headerBtn];
    }
}
/**
 设置选择月份的按钮
 **/
- (void)headerClick:(LGCalendarButton *)btn
{
    int tag = (int)btn.tag;
    
    NSDate *newDate = [NSDate date];
    
    switch (tag) {
        case 0:
            newDate = [self.currentDate dayInPreviousYear];
            break;
        case 1:
            newDate = [self.currentDate dayInPreviousMonth];
            break;
        case 2:
            newDate = [self.currentDate dayInFollowYear];
            break;
        case 3:
            newDate = [self.currentDate dayInFollowMonth];
            break;
        default:
            break;
    }
    NSLog(@"CurrentDate is %@",self.currentDate);
    NSLog(@"newDate1 is %@",newDate);
    NSDateFormatter *yearMonth = [[NSDateFormatter alloc] init];
    [yearMonth setDateFormat:@"YYYY-MM"];
    NSString *calenderDate = [yearMonth stringFromDate:newDate];
    self.calenderStr = calenderDate;
    NSLog(@"calenderDate is %@",calenderDate);
    NSDate *newDate1 = [yearMonth dateFromString:calenderDate];
    NSLog(@"newDate2 is %@",newDate1);
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:newDate forKey:@"userInfoKey"];
    [[NSNotificationCenter defaultCenter] postNotificationName:KDateChangeNotification object:self userInfo:userInfo];
//    NSData *data = [self gotRecordForCurrentMonth];
//    [self writeDataToFile:data];
}

/**
 读取本月的健身记录
 **/
- (NSData *)gotRecordForCurrentMonth{
    NSString *path = [[NSString alloc] initWithFormat:@"http://175.130.116.203:10080/body/calender/%@",self.calenderStr];
    NSURL *url = [NSURL URLWithString:path];
    
    //SyncGet
    NSString *calenderStr = [TYhelper syncGet:url];
    NSData *jsonData = [calenderStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *calenderDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    NSArray *dateArray = [calenderDict objectForKey:@"days"];
    for (NSString *dayed in dateArray) {
        NSLog(@"recordDay is %@",dayed);
    }
    return jsonData;
}

- (void)writeDataToFile:(NSData *)data{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *ourDocumentPath = [documentPaths objectAtIndex:0];
    
    NSString *sandboxPath = NSHomeDirectory();
    NSString *documentPath = [sandboxPath stringByAppendingPathComponent:@"Documents"];
    
    NSString *calenderFile = @"calender.txt";
    NSString *FileName = [documentPath stringByAppendingPathComponent:calenderFile];
    [data writeToFile:calenderFile atomically:YES];
}

/**
 创建选择日期的按钮
 **/

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.collectionView.bounds = CGRectMake(0, 0, self.myWidth*0.6, self.myHeight);
    self.collectionView.center = self.center;
    self.collectionView.contentInset = UIEdgeInsetsZero;
    
    self.collectionFlowLayout.itemSize = CGSizeMake(self.collectionView.myWidth, self.myHeight*0.9);
    
    for (LGCalendarButton *btn in self.headerBtnArray) {
        switch (btn.tag) {
            case 0:
            {
                btn.frame = CGRectMake(20, 0, 15, 25);
            }
                break;
                case 1:
            {
                btn.frame = CGRectMake(50, 0, 15, 20);
            }
                break;
                case 2:
            {
                btn.frame = CGRectMake(self.frame.size.width-40, 0, 15, 25);
                btn.transform = CGAffineTransformMakeRotation(M_PI);
            }
                break;
                case 3:
            {
                btn.frame = CGRectMake(self.frame.size.width-70, 0, 15, 20);
                 btn.transform = CGAffineTransformMakeRotation(M_PI);
            }
                break;
                
            default:
                break;
        }
        CGPoint tempP = btn.center;
        tempP.y = self.center.y;
        btn.center = tempP;
    }
}

#pragma mark UICollectionView datasource/delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.maximumDate numberOfmunthFromDate:self.minimumDate]+1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"headCell" forIndexPath:indexPath];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
    
    if (!titleLabel) {
        titleLabel = [[UILabel alloc] initWithFrame:cell.contentView.bounds];
        titleLabel.tag = 100;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:titleLabel];
    }
    NSDate *currentDate = [self.minimumDate dayInTheFollowMouth:indexPath.item];
    self.currentDate = currentDate;
    [titleLabel setText:[NSDate stringFromDate:currentDate]];
    
    return cell;
}

-(void)setScrollOffset:(CGFloat)scrollOffset
{
    if (_scrollOffset != scrollOffset) {
        _scrollOffset = scrollOffset;
        [self.collectionView setContentOffset:CGPointMake(scrollOffset * self.collectionFlowLayout.itemSize.width, 0) animated:NO];
  }
    [self.collectionView reloadData];
}




@end
