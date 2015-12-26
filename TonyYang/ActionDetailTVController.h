//
//  UITableViewController+ActionDetailTVController.h
//  TonyYang
//
//  Created by Geass on 15/12/20.
//  Copyright © 2015年 Geass. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionDetailTVController : UITableViewController


- (IBAction)keyboardHidden:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *excerciseField;
@property (strong, nonatomic) IBOutlet UITextField *repetitionField;
@property (strong, nonatomic) IBOutlet UITextField *resistanceField;
@property (strong, nonatomic) IBOutlet UITextField *groupField;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (copy, nonatomic) NSString *catalogRec;
@property (assign, nonatomic) id delegate;

@end
