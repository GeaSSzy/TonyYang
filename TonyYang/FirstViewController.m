//
//  FirstViewController.m
//  TonyYang
//
//  Created by Geass on 15/12/9.
//  Copyright © 2015年 Geass. All rights reserved.
//

#import "FirstViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.title = @"Abs Actions";
    
    NSDateFormatter *yearMonth = [[NSDateFormatter alloc] init];
    [yearMonth setDateFormat:@"yyyy-MM-dd"];
    NSDate *today = [NSDate date];
    NSString *todayStr = [yearMonth stringFromDate:today];
    
    //selectNotes
//    NSString *selectString = [[NSString alloc] initWithFormat:@"select * from note where catalog=\"%@\" and date=\"%@\" and status<>\"willDelete\"", self.title,todayStr];
//    NSLog(@"selectString is %@",selectString);
//    NSMutableArray *recordArray = [[NSMutableArray alloc] init];
//    
//    TYSQLite *tySql = [[TYSQLite alloc] init];
//    if([tySql open] != 0){
//        recordArray = [tySql selectNotes:selectString];
//        NSLog(@"recordArray is %@",recordArray);
//        if ([recordArray count] != 0) {
//            self.testRecords = recordArray;
//        }
//    }
//    self.dictArray = [TYhelper notePadToArray:self.testRecords];
//    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.dictArray, @"records", nil];
//    self.dict = bodyDic;
//    NSLog(@"self.dict is %@", self.dict);
//    
//    NSData *dataDic = [NSJSONSerialization dataWithJSONObject:self.dict options:NSJSONWritingPrettyPrinted error:nil];
//    
//    NSString *urlString = [[NSString alloc] initWithFormat:@"http://xjq314.com:10080/body/train"];
//    NSURL *url = [NSURL URLWithString:urlString];
//
//    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
//    [request setDelegate:self];
//    [request setPostBody:dataDic];
//    [request startAsynchronous];
    
    
//    NSString *gotString = [[NSString alloc] init];
//    gotString = [TYhelper syncPost:url HTTPBody:dataDic];
//    NSLog(@"gotString is %@",gotString);
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    NSString *responseString = [request responseString];
    NSLog(@"responseString is %@",responseString);
    
    NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *receivedDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    [TYhelper postRecordToSQL:receivedDict];
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    NSError *error = [request error];
    NSLog(@"error is %@", error);
    NSLog(@"request error");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
