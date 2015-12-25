//
//  UITableViewController+DetailTVController.h
//  TonyYang
//
//  Created by Geass on 15/12/9.
//  Copyright © 2015年 Geass. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTVController : UITableViewController //<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSDictionary *dataServer;
@property (strong, nonatomic) NSDictionary *dataApp;
@property (strong, nonatomic) NSArray *appKeys;
@property (strong, nonatomic) NSString *gotYear;
@property (strong, nonatomic) NSString *gotMonth;
@property (strong, nonatomic) NSString *gotDay;
@property (strong, nonatomic) NSString *gotData;

//@property (strong, nonatomic) IBOutlet UILabel *timesValue;
//@property (strong, nonatomic) IBOutlet UILabel *weightValue;
//@property (strong, nonatomic) IBOutlet UILabel *groupValue;

@end
