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
    
    NSDateFormatter *yearMonth = [[NSDateFormatter alloc] init];
    [yearMonth setDateFormat:@"YYYY-MM-dd"];
    NSDate *today = [NSDate date];
    NSString *todayStr = [yearMonth stringFromDate:today];
    
    //selectNotes
    NSString *selectString = [[NSString alloc] initWithFormat:@"select * from note where catalog=\"%@\" and date=\"%@\" and status<>\"willDelete\"", self.catalogGot,todayStr];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewWillAppear:(BOOL)animated{
//    NSDateFormatter *yearMonth = [[NSDateFormatter alloc] init];
//    [yearMonth setDateFormat:@"YYYY-MM-dd"];
//    NSDate *today = [NSDate date];
//    NSString *todayStr = [yearMonth stringFromDate:today];
//
//    //selectNotes
//    NSString *selectString = [[NSString alloc] initWithFormat:@"select * from note where catalog=\"%@\" and date=\"%@\"", self.catalogGot,todayStr];
//    NSLog(@"selectString is %@",selectString);
//    NSMutableArray *recordArray = [[NSMutableArray alloc] init];
//
//    TYSQLite *tySql = [[TYSQLite alloc] init];
//    if([tySql open] != 0){
//        recordArray = [tySql selectNotes:selectString];
//        NSLog(@"recordArray is %@",recordArray);
//        if ([recordArray count] != 0) {
//            self.records = recordArray;
//            NSLog(@"Mark");
//        }
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
    
    NotePad *recordNote =[[NotePad alloc] init];
    recordNote = [self.records objectAtIndex:row];
    cell.textLabel.text = recordNote.exercise;
//    cell.textLabel.text = [[self.records objectAtIndex:row] objectForKey:@"exercise"];
    
    NSString *repetition = [[NSString alloc] initWithString:recordNote.repetition];
    NSString *resistance = [[NSString alloc] initWithString:recordNote.resistance];
    NSString *group = [[NSString alloc] initWithString:recordNote.group];

    NSString *detailLabel = [[NSString alloc] initWithFormat:@"Repetition:%@\t\nResistance: %@kg\n Group    :     %@\t",repetition,resistance,group];
    cell.detailTextLabel.text = detailLabel;
    
    repetition = nil;
    resistance = nil;
    group = nil;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    editingStyle = UITableViewCellEditingStyleDelete;//此处的EditingStyle可等于任意UITableViewCellEditingStyle,该行代码只在iOS8.0以前版本有作用，也可以不实现
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        //title可自定义
        NSLog(@"点击删除");
        NotePad *deletePad = [[NotePad alloc] init];
        deletePad = [self.records objectAtIndex:[indexPath row]];
        NSString *updateTagID = deletePad.tagID;
        NSString *updateString = [NSString stringWithFormat:@"update note set status=\"willDelete\" where tagID=%@",updateTagID];
        TYSQLite *deleteSql = [[TYSQLite alloc] init];
        if([deleteSql open] != 0){
            BOOL deleteOK = [deleteSql update:updateString];
        }
        [self removeOneCell:indexPath];
    }];//此处是iOS8.0以后苹果最新推出的api，UITableViewRowAction，Style是划出的标签颜色等状态的定义，这里也可以自行定义
    UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Edit" handler:^(UITableViewRowAction *action, NSIndexPath *indePath){
        
    }];
    editRowAction.backgroundColor = [UIColor colorWithRed:0 green:124/255.0 blue:233/255.0 alpha:1];    //定义RowAction的颜色
    return @[deleteRowAction, editRowAction];   //最后返回这两个RowAction的数组
}


#pragma mark - Function Method

- (void)refreshSectionAndCell:(NotePad *)aNote{
        NSMutableArray *recordArray = [[NSMutableArray alloc] initWithArray:self.records];
        [recordArray addObject:aNote];
        self.records = recordArray;
    //Insert new Cell
    if ([self.records count]!= 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([self.records count] - 1) inSection: 0];
        NSMutableArray *indexPaths = [[NSMutableArray alloc]init];
        [indexPaths addObject:indexPath];
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths: indexPaths  withRowAnimation:UITableViewScrollPositionNone];
        [self.tableView endUpdates];
    }
}

- (void)removeOneCell:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    NSMutableArray *recordArray = [[NSMutableArray alloc] initWithArray:self.records];
    [recordArray removeObjectAtIndex:row];
    self.records = recordArray;
    NSLog(@"number of self.records is %lu", (unsigned long)[self.records count]);
    NSLog(@"%@ will be removed",[self.records objectAtIndex:row]);
    NSIndexPath *index = [NSIndexPath indexPathForRow:row inSection:0];
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    [indexPaths addObject:index];
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

@end