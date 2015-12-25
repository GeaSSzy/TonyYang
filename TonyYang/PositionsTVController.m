//
//  UITableViewController+PositionsTVController.m
//  TonyYang
//
//  Created by Geass on 15/12/21.
//  Copyright © 2015年 Geass. All rights reserved.
//

#import "PositionsTVController.h"
#import "ActionsTVController.h"

@interface PositionsTVController ()

@end

@implementation PositionsTVController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"Abs Actions"]){
        ActionsTVController *action = segue.destinationViewController;
        action.catalogGot = @"Abs Actions";
    }else if ([segue.identifier isEqualToString:@"Back Actions"]){
        ActionsTVController *action = segue.destinationViewController;
        action.catalogGot = @"Back Actions";
    }else if ([segue.identifier isEqualToString:@"Biceps Actions"]){
        ActionsTVController *action = segue.destinationViewController;
        action.catalogGot = @"Biceps Actions";
    }else if ([segue.identifier isEqualToString:@"Chest Actions"]){
        ActionsTVController *action = segue.destinationViewController;
        action.catalogGot = @"Chest Actions";
    }else if ([segue.identifier isEqualToString:@"Leg Actions"]){
        ActionsTVController *action = segue.destinationViewController;
        action.catalogGot = @"Leg Actions";
    }else if ([segue.identifier isEqualToString:@"Shoulder Actions"]){
        ActionsTVController *action = segue.destinationViewController;
        action.catalogGot = @"Shoulder Actions";
    }else if ([segue.identifier isEqualToString:@"Triceps Actions"]){
        ActionsTVController *action = segue.destinationViewController;
        action.catalogGot = @"Triceps Actions";
    }
}


@end