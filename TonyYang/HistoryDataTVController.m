//
//  SecondViewController.m
//  TonyYang
//
//  Created by Geass on 15/12/9.
//  Copyright © 2015年 Geass. All rights reserved.
//

#import "HistoryDataTVController.h"
//#import "SwiftModule-swift.h"
#import "TYhelper.h"
#import "LGCalendar.h"
#import "DetailTVController.h"

@interface HistoryDataTVController () <UIViewControllerTransitioningDelegate, UINavigationControllerDelegate>


@end

@implementation HistoryDataTVController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *path = [[NSString alloc] initWithFormat:@"http://175.130.116.203:10080/body/calender/2015-12"];
    NSURL *url = [NSURL URLWithString:path];
    
    //判断网络连接是否OK
    if ([TYhelper NetWorkIsOk]) {
    //SyncGet
    NSString *calenderStr = [TYhelper syncGet:url];
    self.fileContent = calenderStr;
    NSData *jsonData = [self.fileContent dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *calenderDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"GotDict is %@",calenderDict);
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *ourDocumentPath = [documentPaths objectAtIndex:0];
    NSString *calenderFile = @"calender.json";
    NSString *FileName = [ourDocumentPath stringByAppendingPathComponent:calenderFile];
    NSLog(@"FileAddress is %@",FileName);
    self.fileAddress = FileName;
    [self.fileContent writeToFile:self.fileAddress atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    NSString *testGotStr = [[NSString alloc] initWithContentsOfFile:self.fileAddress encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"Data length is %d",[testGotStr length]);
    NSLog(@"testGotStr content is %@",testGotStr);
    NSData *testData = [testGotStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *testDict = [NSJSONSerialization JSONObjectWithData:testData options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"testDict from File is %@",testDict);
    }else{
        NSLog(@"There is no InterNet");
    }

//-----------------------------------------------------------------------------------------------------------------------------
    LGCalendar *calendar = [[LGCalendar alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 240)];
    [self.view addSubview:calendar];
    calendar.delegate = self;
//    self.LGCalendar = calendar;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)LGCalendar:(LGCalendar *)calendar didSelectDate:(NSDate *)selectDate{
    NSLog(@"select date:%@",selectDate);
//    [self.textField setText:[NSString stringWithFormat:@"%@",selectDate]];
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *monthFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"yyyy-MM-dd"];
    [monthFormatter setDateFormat:@"yyyy-MM"];
    self.selectedData = [dayFormatter stringFromDate:selectDate];
    self.monthData = [monthFormatter stringFromDate:selectDate];
    if (self.selectedData != nil) {
        [self performSegueWithIdentifier:@"DetailData" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"DetailData"]){
        DetailTVController *receive = segue.destinationViewController;
        receive.gotData = self.selectedData;
    }
}
@end
