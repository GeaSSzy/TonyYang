//
//  UITableViewController+DetailTVController.m
//  TonyYang
//
//  Created by Geass on 15/12/9.
//  Copyright © 2015年 Geass. All rights reserved.
//

#import "DetailTVController.h"
#import "TYSQLite.h"
#import "TYhelper.h"

static NSString *DetailCell = @"DetailCell";

@interface DetailTVController ()

@end

@implementation DetailTVController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    //判断网络连接是否OK
    if ([TYhelper NetWorkIsOk]) {
//    NSString *path = [[NSString alloc] initWithFormat:@"http://175.130.116.203:10080/body/records/%@-%@-%@",self.gotYear,self.gotMonth,self.gotDay];
    NSString *path = [[NSString alloc] initWithFormat:@"http://175.130.116.203:10080/body/records/%@",self.gotData];
//    NSString *path = [[NSString alloc] initWithFormat:@"http://175.130.116.203:10080/body/records/2015-12-07"];
    NSURL *url = [NSURL URLWithString:path];

    //SyncGet
    NSString *receivedStr = [TYhelper syncGet:url];
    NSData *jsonData = [receivedStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *receivedDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    self.dataServer = receivedDict;
    NSDictionary *appDict = [TYhelper serverDataToAppData:self.dataServer];
    self.dataApp = appDict;
    NSArray *keysArray = [self.dataApp allKeys];
    self.appKeys = keysArray;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.appKeys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = [self.appKeys objectAtIndex:section];
    NSArray *nameSection = [self.dataApp objectForKey:key];
    return [nameSection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    NSString *key = [self.appKeys objectAtIndex:section];
    NSArray *nameSection = [self.dataApp objectForKey:key];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DetailCell];
    if(cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:DetailCell];
    }

    cell.textLabel.text = [[nameSection objectAtIndex:row] objectForKey:@"exercise"];
   
    NSString *repetition = [[nameSection objectAtIndex:row] objectForKey:@"repetition"];
    NSString *resistance = [[nameSection objectAtIndex:row] objectForKey:@"resistance"];
//    timesValueLabel.text = repetition;
    
//    NSMutableAttributedString *timeValue= [[NSMutableAttributedString alloc] initWithString:repetition];
//    weightValueLabel.attributedText = timeValue;
//    groupValue.attributedText = [[nameSection objectAtIndex:row] objectForKey:@""];
    NSString *detailLabel = [[NSString alloc] initWithFormat:@"Repetition:%@\t\nResistance: %@kg\n Group    :     1\t",repetition,resistance];
    NSLog(@"detailLabel is %@",detailLabel);
    cell.detailTextLabel.text = detailLabel;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *key = [self.appKeys objectAtIndex:section];
    return key;
}
@end