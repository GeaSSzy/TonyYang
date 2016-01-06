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
    NSDateFormatter *yearMonth = [[NSDateFormatter alloc] init];
    [yearMonth setDateFormat:@"yyyy-MM"];
    NSDate *today = [NSDate date];
    NSDate *lastMonth = [TYhelper getPriousorLaterDateFromDate:today withMonth:-1];
    NSDate *twoLastMonth = [TYhelper getPriousorLaterDateFromDate:today withMonth:-2];
    
    NSString *todayStr = [yearMonth stringFromDate:today];
    NSString *lastStr = [yearMonth stringFromDate:lastMonth];
    NSString *twoLastStr = [yearMonth stringFromDate:twoLastMonth];
    
    NSArray *monthArray = [[NSArray alloc] initWithObjects:todayStr, lastStr, twoLastStr, nil];
    
    //判断网络连接是否OK
    if ([TYhelper NetWorkIsOk]) {
        //SyncGet
        NSMutableArray *daysArray = [[NSMutableArray alloc] init];
        for (NSString *str in monthArray){
            NSString *path = [[NSString alloc] initWithFormat:@"http://xjq314.com:10080/body/calender/%@",str];
            NSURL *url = [NSURL URLWithString:path];
            NSString *calenderStr = [TYhelper syncGet:url];
            NSLog(@"calenderStr is %@",calenderStr);
            NSData *jsonData = [calenderStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *calenderDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"GotDict is %@",calenderDict);
            [daysArray addObjectsFromArray:[calenderDict objectForKey:@"days"]];
        }
        NSDictionary *daysDict = [[NSDictionary alloc] initWithObjectsAndKeys:daysArray, @"days", nil];
        NSData *daysData = [NSJSONSerialization dataWithJSONObject:daysDict options:NSJSONWritingPrettyPrinted error:nil];
        NSString *daysString = [[NSString alloc] initWithData:daysData encoding:NSUTF8StringEncoding];
        self.fileContent = daysString;
        NSLog(@"fileContent is %@",self.fileContent);
        
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
