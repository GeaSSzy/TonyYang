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
    
    

 
    NSDateFormatter *yearMonth = [[NSDateFormatter alloc] init];
    [yearMonth setDateFormat:@"yyyy-MM"];
    NSDate *today = [NSDate date];
    NSString *todayStr = [yearMonth stringFromDate:today];
    NSLog(@"todayStr is %@",todayStr);
    NSDate *lastMonth = [TYhelper getPriousorLaterDateFromDate:today withMonth:-1];
    NSLog(@"lastMonth is %@",lastMonth);


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
