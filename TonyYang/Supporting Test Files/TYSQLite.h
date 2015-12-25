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
#import "NoteDb.h"

@class NotePad;
@class NoteDb;



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
- (BOOL)deleteOneNote:(NotePad *)aNote;
- (BOOL)update:(NotePad *)aNote;

- (NoteDb *)selectAll;
- (NoteDb *)selectNotes:(NotePad *)aNote;

@end
