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
    
//    NSNumber *aaa = [[NSNumber alloc] initWithUnsignedInteger:1];
    NSArray *aaa = [[NSArray alloc] initWithObjects:@"array1",@"array2", nil];
    NSNumber *bbb = [[NSNumber alloc] initWithUnsignedInteger:12];
    NSNumber *ccc = [[NSNumber alloc] initWithUnsignedInteger:10];
//    NSLog(@"result is %d",aaa+bbb);
    

    
    
    
    
    
    NSString *str123 = @"\"records\":[{\"catalog\":\"Abs Actions\", \"date\":\"2015-12-28\", \"exercise\":\"ab vc\", \"groups\":1, \"repetition\":11, \"resistance\":60, \"tagid\":\"20151228210058\"}]";
    NSData *data12344 = [str123 dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *dict123 = [[NSMutableDictionary alloc] init];
    
    [dict123 setObject:@"Abs Actions" forKey:@"catalog"];
    [dict123 setObject:@"2015-12-28" forKey:@"date"];
    [dict123 setObject:@"ab vc" forKey:@"exercise"];
    [dict123 setValue:aaa forKey:@"groups"];
    [dict123 setObject:bbb forKey:@"repetition"];
    [dict123 setObject:ccc forKey:@"resistance"];
    [dict123 setObject:@"20151228210058" forKey:@"tagid"];
    
    NSDictionary *test12344 = [[NSDictionary alloc] initWithObjectsAndKeys:dict123, @"records", nil];
    
    self.testDic = test12344;
    NSLog(@"testDic is %@",self.testDic);
    

    
    
    
    self.title = @"Abs Actions";
    
    NSDateFormatter *yearMonth = [[NSDateFormatter alloc] init];
    [yearMonth setDateFormat:@"yyyy-MM-dd"];
    NSDate *today = [NSDate date];
    NSString *todayStr = [yearMonth stringFromDate:today];
    
    //selectNotes
    NSString *selectString = [[NSString alloc] initWithFormat:@"select * from note where catalog=\"%@\" and date=\"%@\" and status<>\"willDelete\"", self.title,todayStr];
    NSLog(@"selectString is %@",selectString);
    NSMutableArray *recordArray = [[NSMutableArray alloc] init];
    
    TYSQLite *tySql = [[TYSQLite alloc] init];
    if([tySql open] != 0){
        recordArray = [tySql selectNotes:selectString];
        NSLog(@"recordArray is %@",recordArray);
        if ([recordArray count] != 0) {
            self.testRecords = recordArray;
        }
    }
    self.dictArray = [TYhelper notePadToArray:self.testRecords];
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.dictArray, @"records", nil];
    self.dict = bodyDic;
    NSLog(@"self.dict is %@", self.dict);
    
    NSData *dataDic = [NSJSONSerialization dataWithJSONObject:self.testDic options:NSJSONWritingPrettyPrinted error:nil];
    NSLog(@"dataDic is %@",dataDic);
    
    NSString *urlString = [[NSString alloc] initWithFormat:@"http://xjq314.com:10080/body/train"];
    NSURL *url = [NSURL URLWithString:urlString];

//    NSString *bodyStr = @"test body string";
//    NSData *testbodyStrData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
//    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
//    [request setDelegate:self];
//    [request setPostBody:dataDic];
//    [request startAsynchronous];
    NSString *gotString = [[NSString alloc] init];
    gotString = [TYhelper syncPost:url HTTPBody:dataDic];
    NSLog(@"gotString is %@",gotString);
}

//- (void)requestFinished:(ASIHTTPRequest *)request{
//    NSString *responseString = [request responseString];
//    NSLog(@"responseString is %@",responseString);
//}
//
//- (void)requestFailed:(ASIHTTPRequest *)request{
//    NSError *error = [request error];
//    NSLog(@"error is %@", error);
//    NSLog(@"request error");
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
