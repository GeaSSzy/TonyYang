//
//  UITableViewController+ModifyDetailTVController.h
//  TonyYang
//
//  Created by Geass on 15/12/30.
//  Copyright © 2015年 Geass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYSQLite.h"

@interface ModifyDetailTVController : UITableViewController

@property (copy, nonatomic) NSIndexPath *indexModify;
@property (assign, nonatomic) id delegateModify;
@property (strong, nonatomic) NotePad *modifyNote;

@property (strong, nonatomic) IBOutlet UITextField *exerciseModification;
@property (strong, nonatomic) IBOutlet UITextField *repetitionModification;
@property (strong, nonatomic) IBOutlet UITableViewCell *resistanceModification;
@property (strong, nonatomic) IBOutlet UITextField *groupModification;
@property (strong, nonatomic) IBOutlet UIDatePicker *dataPickerModification;

@end
