//
//  Header.h
//  TonyYang
//
//  Created by Geass on 15/12/25.
//  Copyright © 2015年 Geass. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NotePad : NSObject

@property (assign, nonatomic)NSUInteger *noteID;

@property (strong, nonatomic)NSString *catalog;
@property (strong, nonatomic)NSString *exercise;
@property (assign, nonatomic)double *resistance;
@property (assign, nonatomic)NSUInteger *repetition;
@property (assign, nonatomic)NSUInteger *group;
@property (strong, nonatomic)NSString *date;
@property (strong, nonatomic)NSString *tagID;
@property (strong, nonatomic)NSString *uuid;
@property (strong, nonatomic)NSString *status;

@end