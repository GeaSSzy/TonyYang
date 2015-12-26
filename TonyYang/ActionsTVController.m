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
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    NSDateFormatter *yearMonth = [[NSDateFormatter alloc] init];
    [yearMonth setDateFormat:@"YYYY-MM-dd"];
    NSDate *today = [NSDate date];
    NSString *todayStr = [yearMonth stringFromDate:today];

//selectNotes
    NSString *selectString = [[NSString alloc] initWithFormat:@"select * from note where catalog=\"%@\" and date=\"%@\"", self.catalogGot,todayStr];
    NSLog(@"selectString is %@",selectString);
    NSMutableArray *recordArray = [[NSMutableArray alloc] init];

    TYSQLite *tySql = [[TYSQLite alloc] init];
    if([tySql open] != 0){
        recordArray = [tySql selectNotes:selectString];
        NSLog(@"recordArray is %@",recordArray);
        if ([recordArray count] != 0) {
            self.records = recordArray;
        }
    }
}

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
    return [self.records count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DetailCell];
    if(cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:DetailCell];
    }
    
    NotePad *recordNote = [self.records objectAtIndex:row];
    cell.textLabel.text = recordNote.exercise;
//    cell.textLabel.text = [[self.records objectAtIndex:row] objectForKey:@"exercise"];
    
    NSString *repetition = recordNote.repetition;
    NSString *resistance = recordNote.resistance;
    NSString *group = recordNote.group;

    NSString *detailLabel = [[NSString alloc] initWithFormat:@"Repetition:%@\t\nResistance: %@kg\n Group    :     %@\t",repetition,resistance,group];
    cell.detailTextLabel.text = detailLabel;
    
    [recordNote release];
    
    return cell;
}

- (void)refreshSectionAndCell:(NotePad *)aNote{
    if ([self.records count] == 0) {
        NSMutableArray *recordArray = [[NSMutableArray alloc] init];
        [recordArray addObject:aNote];
        self.records = recordArray;
    }else{
        [self.records addObject:aNote];
    }
   
    NSLog(@"recordArray222 is %@",self.records);
    NSLog(@"gotRecord222is %@",self.gotRecord);

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