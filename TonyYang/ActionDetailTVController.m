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
#import "TYhelper.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

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
    NSString *repetition = self.repetitionField.text;
    NSString *resistance = self.resistanceField.text;
    NSString *group = self.groupField.text;
    NSString *resistance1 = self.resistanceField.text;
    NSString *group1 = self.groupField.text;
    NSDictionary *actionRecord = [[NSDictionary alloc] initWithObjectsAndKeys:exercise,@"exercise", self.catalogRec,@"catalog",resistance1,@"resistance", repetition,@"repication",group1,@"group", nil];
    NotePad *actionNote = [[NotePad alloc] init];
    
    //训练date
    NSDateFormatter *yearMonth = [[NSDateFormatter alloc] init];
    [yearMonth setDateFormat:@"yyyy-MM-dd"];
    NSDate *selected = [self.datePicker date];
    NSString *pickerDate = [yearMonth stringFromDate:selected];
    
    //create tagID
    NSDateFormatter *forTagID = [[NSDateFormatter alloc] init];
    [forTagID setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *recordDate = [NSDate date];
    NSString *tagID = [forTagID stringFromDate:recordDate];
    
    actionNote.catalog = self.catalogRec;
    actionNote.exercise = exercise;
    actionNote.resistance = resistance;
    actionNote.repetition = repetition;
    actionNote.group = @"1";
    actionNote.date = pickerDate;
    actionNote.tagID = tagID;
    actionNote.uuid = @"uuidNeeded";
    actionNote.status = @"willRecord";
    
//insert into SQLite
    
    TYSQLite *tySql = [[TYSQLite alloc] init];
    
    BOOL insertOK = [tySql insert:actionNote];

    //Insert delegate code
    //delegate date
    [self.delegate setValue:pickerDate forKey:@"recordDate"];
    NSLog(@"pickerDate is OK");
    //delegate record
    if ([self.delegate respondsToSelector:@selector(refreshSectionAndCell:)]) {
        [self.delegate setValue:actionNote forKey:@"gotRecord"];
        NSLog(@"gotRecord is OK");
    }
    
    //PostToServer
    if ([TYhelper NetWorkIsOk]) {
        //selectNotes
        NSString *selectString = [[NSString alloc] initWithFormat:@"select * from note where status=\"willRecord\""];
        NSMutableArray *recordArray = [[NSMutableArray alloc] init];
        //从数据库中select
        if([tySql open] != 0){
            recordArray = [tySql selectNotes:selectString];
            NSLog(@"recordArray is %@",recordArray);
            if ([recordArray count] != 0) {
                self.toServerArray = [TYhelper notePadToArray:recordArray];
                NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.toServerArray, @"records", nil];
                self.toServerDict = bodyDic;
                NSData *dataDic = [NSJSONSerialization dataWithJSONObject:self.toServerDict options:NSJSONWritingPrettyPrinted error:nil];
                
                NSString *urlString = [[NSString alloc] initWithFormat:@"http://xjq314.com:10080/body/train"];
                NSURL *url = [NSURL URLWithString:urlString];
                
                ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
                [request setPostBody:dataDic];
                [request startAsynchronous];
                [request setCompletionBlock :^{
                    // 请求响应结束，返回 responseString
                    NSString *responseString = [request responseString ]; // 对于 2 进制数据，使用 NSData 返回 NSData *responseData = [request responseData];
                    NSLog ( @"block test is %@" ,responseString);
                    NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *receivedDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
                    [TYhelper postRecordToSQL:receivedDict];
                }];
                [request setFailedBlock :^{
                    // 请求响应失败，返回错误信息
                    NSError *error = [request error ];
                    NSLog ( @"error:%@" ,[error userInfo ]);
                }];
            }
        }
    }

    //popOut
    for (UIViewController *actionsTV in self.navigationController.viewControllers){
        if ([actionsTV isKindOfClass:[ActionsTVController class]]) {
            [self.delegate performSelector:@selector(refreshSectionAndCell:)withObject:actionNote];
            [self.navigationController popToViewController:actionsTV animated:YES];
        }
    }
    
}

//- (void)requestFinished:(ASIHTTPRequest *)request{
//    NSString *responseString = [request responseString];
//    NSLog(@"responseString is %@",responseString);
//    
//    NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *receivedDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
//    [TYhelper postRecordToSQL:receivedDict];
//}
//
//- (void)requestFailed:(ASIHTTPRequest *)request{
//    NSError *error = [request error];
//    NSLog(@"error is %@", error);
//    NSLog(@"request error");
//}

- (IBAction)keyboardHidden:(id)sender {
    [self.view endEditing:YES];
}
@end