//
//  UITableViewController+actionsTVController.h
//  TonyYang
//
//  Created by Geass on 15/12/20.
//  Copyright © 2015年 Geass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYSQLite.h"

@interface ActionsTVController : UITableViewController

@property(strong, nonatomic) NSString *catalogGot;
@property(strong, nonatomic) NSMutableDictionary *todayRecord;
@property(strong, nonatomic) NotePad *gotRecord;
@property(copy, nonatomic) NSMutableArray *records;
@property(strong, nonatomic) NSString *recordDate;

@end
