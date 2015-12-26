//
//  NSObject+Nog.h
//  TonyYang
//
//  Created by Geass on 15/12/26.
//  Copyright © 2015年 Geass. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotePad : NSObject

@property (assign, nonatomic)NSUInteger *noteID;

@property (strong, nonatomic)NSString *catalog;
@property (strong, nonatomic)NSString *exercise;
@property (assign, nonatomic)NSString *resistance;
@property (assign, nonatomic)NSString *repetition;
@property (assign, nonatomic)NSString *group;
@property (strong, nonatomic)NSString *date;
@property (strong, nonatomic)NSString *tagID;
@property (strong, nonatomic)NSString *uuid;
@property (strong, nonatomic)NSString *status;

@end