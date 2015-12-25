//
//  SecondViewController.h
//  TonyYang
//
//  Created by Geass on 15/12/9.
//  Copyright © 2015年 Geass. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryDataTVController : UIViewController

@property (strong, nonatomic) NSDictionary *calenderData;
@property (strong, nonatomic) NSArray *calenderDate;
@property (strong, nonatomic) NSString *selectedData;
@property (strong, nonatomic) NSString *monthData;
@property (strong, nonatomic) NSString *fileAddress;
@property (strong, nonatomic) NSString *fileContent;

@end

