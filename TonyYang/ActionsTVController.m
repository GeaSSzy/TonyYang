//
//  UITableViewController+actionsTVController.m
//  TonyYang
//
//  Created by Geass on 15/12/20.
//  Copyright © 2015年 Geass. All rights reserved.
//

#import "ActionsTVController.h"
#import "ActionDetailTVController.h"

static NSString *DetailCell = @"actionsCell";

@interface ActionsTVController ()

@end

@implementation ActionsTVController

- (void)viewDidLoad {
    [self.navigationController  setToolbarHidden:NO animated:YES];
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = self.catalogGot;
    NSLog(@"CatalogGot is %@",self.catalogGot);
    NSLog(@"gotRecord is %@",self.gotRecord);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewWillAppear:(BOOL)animated{
//   
//    NSLog(@"recordArray1111 is %@",self.records);
//    NSLog(@"gotRecord1111 is %@",self.gotRecord);
//    NSLog(@"TodayRecord1111 is %@",self.todayRecord);
//}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if ([segue.identifier isEqualToString:@"Add action"]){
//        ActionDetailTVController *detailTV = segue.destinationViewController;
//        detailTV.catalogRec = self.catalogGot;
//    }
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setDelegate:)]) {
        [destination setValue:self forKey:@"delegate"];
    }
    if ([destination respondsToSelector:@selector(setCatalogRec:)]){
        [destination setValue:self.catalogGot forKey:@"catalogRec"];
    }
}

#pragma -mark

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = [self.todayRecord objectForKey:@"records"];
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DetailCell];
    if(cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:DetailCell];
    }
    
    cell.textLabel.text = [[self.records objectAtIndex:row] objectForKey:@"excercise"];
    
    NSString *repetition = [[self.records objectAtIndex:row] objectForKey:@"repication"];
    NSString *resistance = [[self.records objectAtIndex:row] objectForKey:@"resistance"];
    NSString *group = [[self.records objectAtIndex:row] objectForKey:@"group"];

    NSString *detailLabel = [[NSString alloc] initWithFormat:@"Repetition:%@\t\nResistance: %@kg\n Group    :     %@\t",repetition,resistance,group];
    cell.detailTextLabel.text = detailLabel;
    
    return cell;
}

- (void)refreshSectionAndCell:(NSDictionary *)dict{
    if ([self.records count] == 0) {
        NSMutableArray *recordArray = [[NSMutableArray alloc] init];
        [recordArray addObject:dict];
        self.records = recordArray;
    }else{
        [self.records addObject:dict];
    }
   
    
//    [self.records addObject:self.gotRecord];
    NSMutableDictionary *todayDic = [[NSDictionary alloc] initWithObjectsAndKeys:self.recordDate,@"date",self.records,@"records", nil];
    self.todayRecord = todayDic;
    NSLog(@"recordArray222 is %@",self.records);
    NSLog(@"gotRecord222is %@",self.gotRecord);
    NSLog(@"TodayRecord222 is %@",self.todayRecord);
    //Reload Sections
//    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
//    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    //Reload cell
//    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self.records count] inSection:0];
//    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    if ([self.records count]!= 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([self.records count] - 1) inSection: 0];
        NSMutableArray *indexPaths = [[NSMutableArray alloc]init];
        [indexPaths addObject:indexPath];
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths: indexPaths  withRowAnimation:UITableViewScrollPositionNone];
        [self.tableView endUpdates];
    }
}



@end