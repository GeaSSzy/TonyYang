//
//  NSObject+TYSQLite.m
//  TonyYang
//
//  Created by Geass on 15/12/25.
//  Copyright © 2015年 Geass. All rights reserved.
//

#import "TYSQLite.h"

@interface TYSQLite ()

@end

@implementation TYSQLite

- (id)init{
    self = [super init];
    return self;
}

//打开数据库
- (BOOL)open{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"noteList.db"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL *find = [fileManager fileExistsAtPath:path];
    //判断是否存在
    if(find){
        NSLog(@"数据库文件已经存在");
        //打开数据库，并返回操作是否正确
        if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
            NSLog(@"数据库打开成功");
        }
        return YES;
    }else {
        if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
            //调用createMusiceList创建数据库表
            [self create];
            return YES;
        }else{
            sqlite3_close(database);
            NSLog(@"Error: open database file.");
            return NO;
        }
        return NO;
    }
}

//创建表
- (BOOL)create{
    //创建表语句
    const char *createSql = "create table if not exists note (id integer primary key autoincrement, catalog text, exercise text, resistance real, repetition integer, group integer, date text, tagID text, uuid text, status text)";
    //创建表是否成功
    if (sqlite3_exec(database, createSql, NULL, NULL, &errorMsg) == SQLITE_OK) {
        NSLog(@"create OK");
        return YES;
    }else{
        //打印出错信息
        NSLog(@"error : %s",errorMsg);
        sqlite3_free(errorMsg);
    }
    return NO;
}

//增加、删除、修改、查询
- (BOOL)insert:(NotePad *)aNote{
    //向表中插入记录
    //定义一个sql语句
    NSString *insertStatementNS = [NSString stringWithFormat:
                                   @"insert into \"note\"\
                                   (catalog, exercise, resistance, repetition, group, date, tagID, uuid, status)\
                                   values (\"%@\", \"%@\", %f, %d, %d, \"%@\", \"%@\", \"%@\", \"%@\")",
                                   aNote.catalog, aNote.exercise, aNote.resistance, aNote.repetition, aNote.group, aNote.date, aNote.tagID, aNote.uuid, aNote.status];
    //将定义的NSString的sql语句，切换成UTF8的c风格的字符串
    const char *insertSql = [insertStatementNS UTF8String];
    //执行插入语句
    if (sqlite3_exec(database, insertSql, NULL, NULL, &errorMsg) == SQLITE_OK) {
        NSLog(@"Insert OK");
        return YES;
    }else{
        NSLog(@"error: %s",errorMsg);
        sqlite3_free(errorMsg);
    }
    return NO;
}

- (BOOL)deleteAllNote{
    //删除所有数据，条件为1>0永真
    const char *deleteAllSql = "delete from note where 1>0";
    //执行删除语句
    if (sqlite3_exec(database, deleteAllSql, NULL, NULL, &errorMsg) == SQLITE_OK) {
        NSLog(@"删除所有数据成功");
    }
    return YES;
}

- (BOOL)deleteOneNote:(NotePad *)aNote{
    //删除某条数据
    NSString *deleteString = [NSString stringWithFormat:@"delete from note where uuid = %@",aNote.uuid];
    //转成utf-8的c风格
    const char *deleteSql = [deleteString UTF8String];
    //执行删除语句
    if (sqlite3_exec(database, deleteSql, NULL, NULL, &errorMsg) == SQLITE_OK) {
        NSLog(@"删除成功");
    }
    return YES;
}

- (BOOL)update:(NotePad *)aNote{
    //更新语句
    NSString *updateString = [NSString stringWithFormat:
                              @"update note set catalog='%@', exercise='%@', resistance=%f, repetition=%d, group=%d, date='%@', tagID='%@', uuid='%@', status='%@'",
                              aNote.catalog, aNote.exercise, aNote.resistance, aNote.repetition, aNote.group, aNote.date, aNote.tagID, aNote.uuid, aNote.status];
    const char *updateSql = [updateString UTF8String];
    //执行更新语句
    if (sqlite3_exec(database, updateSql, NULL, NULL, &errorMsg) == SQLITE_OK) {
        NSLog(@"更新成功");
    }
    return YES;
}

- (NoteDb *)selectAll{
    NoteDb *noteDb = [[NoteDb alloc] autorelease];
    //查询所有语句
    const char *seleteAllSql = "select * from note";
    //执行查询
    if (sqlite3_prepare_v2(database, seleteAllSql, -1, &statement, nil) == SQLITE_OK) {
        NSLog(@"select ALL OK");
        //如果查询有语句就执行step来添加数据
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NotePad *note = [[NotePad alloc] init];
            
            int noteID = sqlite3_column_int(statement, 0);
            NSMutableString *catalog = [NSMutableString stringWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
            NSMutableString *exercise = [NSMutableString stringWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
            double resistance = sqlite3_column_double(statement, 3);
            int repetition = sqlite3_column_int(statement, 4);
            int group = sqlite3_column_int(statement, 5);
            NSMutableString *date = [NSMutableString stringWithCString:(char *)sqlite3_column_text(statement, 6) encoding:NSUTF8StringEncoding];
            NSMutableString *tagID = [NSMutableString stringWithCString:(char *)sqlite3_column_text(statement, 7) encoding:NSUTF8StringEncoding];
            NSMutableString *uuid = [NSMutableString stringWithCString:(char *)sqlite3_column_text(statement, 8) encoding:NSUTF8StringEncoding];
            NSMutableString *status = [NSMutableString stringWithCString:(char *)sqlite3_column_text(statement, 9) encoding:NSUTF8StringEncoding];
            
            note.noteID = noteID;
            note.catalog = catalog;
            note.exercise = exercise;
            note.resistance = &(resistance);
            note.repetition = repetition;
            note.group = group;
            note.date = date;
            note.tagID = tagID;
            note.uuid = uuid;
            note.status = status;
            
            [noteDb addObject:note];
            [note release];
        }
        return noteDb;
    }
    return noteDb;
}

- (NoteDb *)selectNotes:(NotePad *)aNote{
    NoteDb *noteDb = [[[NoteDb alloc] init] autorelease];
    //查询Note语句
    NSString *selectNSString = [NSString stringWithFormat:@"select * from note where tagID=%@", aNote.tagID];
    //转成UTF-8的c风格
    const char *selectSql = [selectNSString UTF8String];
    //执行查询
    if (sqlite3_prepare_v2(database, selectSql, -1, &statement, nil) == SQLITE_OK ) {
        NSLog(@"select OK");
        //如果查询有语句就执行step来添加数据
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NotePad *note = [[NotePad alloc] init];
            
            int noteID = sqlite3_column_int(statement, 0);
            NSMutableString *catalog = [NSMutableString stringWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
            NSMutableString *exercise = [NSMutableString stringWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
            double resistance = sqlite3_column_double(statement, 3);
            int repetition = sqlite3_column_int(statement, 4);
            int group = sqlite3_column_int(statement, 5);
            NSMutableString *date = [NSMutableString stringWithCString:(char *)sqlite3_column_text(statement, 6) encoding:NSUTF8StringEncoding];
            NSMutableString *tagID = [NSMutableString stringWithCString:(char *)sqlite3_column_text(statement, 7) encoding:NSUTF8StringEncoding];
            NSMutableString *uuid = [NSMutableString stringWithCString:(char *)sqlite3_column_text(statement, 8) encoding:NSUTF8StringEncoding];
            NSMutableString *status = [NSMutableString stringWithCString:(char *)sqlite3_column_text(statement, 9) encoding:NSUTF8StringEncoding];
            
            note.noteID = noteID;
            note.catalog = catalog;
            note.exercise = exercise;
            note.resistance = &(resistance);
            note.repetition = repetition;
            note.group = group;
            note.date = date;
            note.tagID = tagID;
            note.uuid = uuid;
            note.status = status;
            
            [noteDb addObject:note];
            [note release];
        }
        return noteDb;
    }
    return noteDb;
}

@end