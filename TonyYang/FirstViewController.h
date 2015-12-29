//
//  FirstViewController.h
//  TonyYang
//
//  Created by Geass on 15/12/9.
//  Copyright © 2015年 Geass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYSQLite.h"
#import "TYhelper.h"

@interface FirstViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *testRecords;
@property (strong, nonatomic) NSMutableArray *dictArray;
@property (strong, nonatomic) NSDictionary *dict;
@property (strong, nonatomic) NSMutableDictionary *testDic;

@end

