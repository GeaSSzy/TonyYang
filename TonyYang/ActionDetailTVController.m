//
//  UITableViewController+ActionDetailTVController.m
//  TonyYang
//
//  Created by Geass on 15/12/20.
//  Copyright © 2015年 Geass. All rights reserved.
//

#import "ActionDetailTVController.h"
#import "ActionsTVController.h"
#import "TYSQLite.h"

@interface ActionDetailTVController ()

@end

@implementation ActionDetailTVController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone  target:self action:@selector(backToActions)];
    self.navigationItem.rightBarButtonItem = rightButton;
    NSLog(@"catalogRec is %@",self.catalogRec);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backToActions{
    //训练记录
    NSString *exercise = self.excerciseField.text;
    double *repetition = (double *)self.repetitionField.text;
    NSUInteger *resistance = self.resistanceField.text;
    NSUInteger *group = (NSUInteger *)self.groupField.text;
    NSDictionary *actionRecord = [[NSDictionary alloc] initWithObjectsAndKeys:exercise,@"exercise", self.catalogRec,@"catalog",resistance,@"resistance", repetition,@"repication",group,@"group", nil];
    NotePad *actionNote = [[NotePad alloc] init];
    
    //训练date
    NSDateFormatter *yearMonth = [[NSDateFormatter alloc] init];
    [yearMonth setDateFormat:@"YYYY-MM-dd"];
    NSDate *selected = [self.datePicker date];
    NSString *pickerDate = [yearMonth stringFromDate:selected];
    
    actionNote.catalog = self.catalogRec;
    actionNote.exercise = exercise;
    actionNote.resistance = resistance;
    actionNote.repetition = repetition;
    actionNote.group = group;
    actionNote.date = pickerDate;
//    actionNote.tagID = tagID;
    actionNote.status = @"willRecord";
    
    //Insert delegate code
    //delegate date
    [self.delegate setValue:pickerDate forKey:@"recordDate"];
    //delegate record
    if ([self.delegate respondsToSelector:@selector(refreshSectionAndCell:)]) {
        [self.delegate setValue:actionRecord forKey:@"gotRecord"];
    }
    
    //popOut
    for (UIViewController *actionsTV in self.navigationController.viewControllers){
        if ([actionsTV isKindOfClass:[ActionsTVController class]]) {
            [self.delegate performSelector:@selector(refreshSectionAndCell:)withObject:actionRecord];
            [self.navigationController popToViewController:actionsTV animated:YES];
        }
    }
    
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    NSString *excercise = self.excerciseField.text;
//    NSString *repetition = self.repetitionField.text;
//    NSString *resistance = self.resistanceField.text;
//    NSString *group = self.groupField.text;
//    NSDictionary *actionRecord = [[NSDictionary alloc] initWithObjectsAndKeys:excercise,@"excercise", self.catalogRec,@"catalog",resistance,@"resistance", repetition,@"repication",group,@"group", nil];
//    if ([segue.identifier isEqualToString:@"backToActions"]){
//        ActionsTVController *backTVController = segue.destinationViewController;
//        backTVController.gotRecord = actionRecord;
//    }
//}

- (IBAction)keyboardHidden:(id)sender {
    [self.view endEditing:YES];
}
@end