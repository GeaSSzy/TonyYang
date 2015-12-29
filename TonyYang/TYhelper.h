//
//  NSObject+TYhelper.h
//  TonyYang
//
//  Created by Geass on 15/12/9.
//  Copyright © 2015年 Geass. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYSQLite.h"
#import "Reachability.h"

@interface TYhelper : NSObject

@property (strong, nonatomic) NSDictionary *serverData;
@property (strong, nonatomic) NSMutableDictionary *appData;

+ (NSDictionary *)serverDataToAppData: (NSDictionary *)serverData;
+ (NSString *)syncGet:(NSURL *)url;
+ (NSString *)syncPost:(NSURL *)url HTTPBody: (NSData *)body;
+ (NSMutableArray *)notePadToArray:(NSArray *)noteArray;

//检查网络是否可用
+ (BOOL)NetWorkIsOk;



@end
