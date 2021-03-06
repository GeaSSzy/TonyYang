//
//  NSObject+TYSQLite.h
//  TonyYang
//
//  Created by Geass on 15/12/25.
//  Copyright © 2015年 Geass. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "NotePad.h"

@class NotePad;



@interface TYSQLite : NSObject {
    sqlite3 *database;
    sqlite3_stmt *statement;
    char *errorMsg;
}

//打开数据库
- (BOOL)open;
//创建table
- (BOOL)create;

//增加、删除、修改、查询
- (BOOL)insert:(NotePad *)aNote;
- (BOOL)deleteAllNote;
- (BOOL)deleteOneNote:(NSString *)deleteString;
- (BOOL)update:(NSString *)updateString;

- (NSMutableArray *)selectAll;
- (NSMutableArray *)selectNotes:(NSString *)selectNSString;

@end
