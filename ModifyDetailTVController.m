//
//  UITableViewController+ModifyDetailTVController.m
//  TonyYang
//
//  Created by Geass on 15/12/30.
//  Copyright © 2015年 Geass. All rights reserved.
//

#import "ModifyDetailTVController.h"

@interface ModifyDetailTVController ()

@end

@implementation ModifyDetailTVController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(finishModification)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    //日期格式
    NSDateFormatter *yearMonth = [[NSDateFormatter alloc] init];
    [yearMonth setDateFormat:@"yyyy-MM-dd"];
    //显示修改前的值
    NSLog(@"self.modifyNote is %@",self.modifyNote);
    self.exerciseModification.text = self.modifyNote.exercise;
//    self.repetitionModification.text = self.modifyNote.repetition;
//    self.resistanceModification.text = self.modifyNote.resistance;
//    self.groupModification.text = self.modifyNote.group;
//    self.dataPickerModification.date = [yearMonth dateFromString:self.modifyNote.date];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)finishModification{
    
}

@end