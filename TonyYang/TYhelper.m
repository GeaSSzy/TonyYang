//
//  NSObject+TYhelper.m
//  TonyYang
//
//  Created by Geass on 15/12/9.
//  Copyright © 2015年 Geass. All rights reserved.
//

#import "TYhelper.h"

@interface TYhelper ()

@end

@implementation TYhelper

+ (void)postRecordToSQL:(NSDictionary *)records{
    NSArray *noteArray = [records objectForKey:@"records"];
    TYSQLite *sqlUpdate = [[TYSQLite alloc] init];
    for (NSDictionary *oneDict in noteArray) {
        NSString *updateString = [NSString stringWithFormat:@"update note set uuid=\"%@\", status=\"settled\" where tagID=\"%@\"",[oneDict objectForKey:@"uuid"], [oneDict objectForKey:@"tagid"]];
        if ([sqlUpdate open]){
            BOOL *updateOK = [sqlUpdate update:updateString];
        }
    }
}

+ (void)deleteUnnecessaryDataInSql{
    NSString *deleteString = [[NSString alloc] initWithFormat:@"delete from note where status=\"willDelete\" and uuid=\"uuidNeeded\""];
    TYSQLite *tySql = [[TYSQLite alloc] init];
    BOOL delUDISql = [tySql deleteOneNote:deleteString];
}

+ (void)postWillRecord{
    //selectNotes
    NSString *selectString = [[NSString alloc] initWithFormat:@"select * from note where status=\"willRecord\""];
    NSMutableArray *recordArray = [[NSMutableArray alloc] init];
    NSMutableArray *toServerArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *toServerDict = [[NSMutableDictionary alloc] init];
    //从数据库中select
    TYSQLite *tySql = [[TYSQLite alloc] init];
    if([tySql open] != 0){
        recordArray = [tySql selectNotes:selectString];
        NSLog(@"recordArray is %@",recordArray);
        if ([recordArray count] != 0) {
            toServerArray = [TYhelper notePadToArray:recordArray];
            NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:toServerArray, @"records", nil];
            toServerDict = bodyDic;
            NSData *dataDic = [NSJSONSerialization dataWithJSONObject:toServerDict options:NSJSONWritingPrettyPrinted error:nil];
            
            NSString *urlString = [[NSString alloc] initWithFormat:@"http://xjq314.com:10080/body/train"];
            NSURL *url = [NSURL URLWithString:urlString];
            
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
            [request setPostBody:dataDic];
            [request startAsynchronous];
            [request setCompletionBlock :^{
                // 请求响应结束，返回 responseString
                NSString *responseString = [request responseString ]; // 对于 2 进制数据，使用 NSData 返回 NSData *responseData = [request responseData];
                NSLog ( @"block test is %@" ,responseString);
                NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *receivedDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
                [TYhelper postRecordToSQL:receivedDict];
            }];
            [request setFailedBlock :^{
                // 请求响应失败，返回错误信息
                NSError *error = [request error ];
                NSLog ( @"error:%@" ,[error userInfo ]);
            }];
        }
    }
}

+ (void)deleteWillDelete{
    //selectNotes
    NSString *selectString = [[NSString alloc] initWithFormat:@"select * from note where status=\"willDelete\" and uuid<>\"uuidNeeded\""];
    NSMutableArray *recordArray = [[NSMutableArray alloc] init];
    NSMutableArray *toServerArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *toServerDict = [[NSMutableDictionary alloc] init];
    //从数据库中select
    TYSQLite *tySql = [[TYSQLite alloc] init];
    if([tySql open] != 0){
        recordArray = [tySql selectNotes:selectString];
        NSLog(@"recordArray is %@",recordArray);
        if ([recordArray count] != 0) {
            for (NotePad *oneNote in recordArray){
                NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:oneNote.uuid, @"uuid", nil];
                toServerDict = bodyDic;
                NSData *dataDic = [NSJSONSerialization dataWithJSONObject:toServerDict options:NSJSONWritingPrettyPrinted error:nil];
                
                NSString *urlString = [[NSString alloc] initWithFormat:@"http://xjq314.com:10080/body/record/%@",oneNote.uuid];
                NSLog(@"URLString is %@",urlString);
                NSLog(@"uuid is %@",oneNote.uuid);
                NSURL *url = [NSURL URLWithString:urlString];
                
                ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
                [request buildPostBody];
                [request setRequestMethod:@"DELETE"];
                [request setPostBody:dataDic];
                [request startAsynchronous];
                [request setCompletionBlock :^{
                    // 请求响应结束，返回 responseString
                    NSString *responseString = [request responseString ]; // 对于 2 进制数据，使用 NSData 返回 NSData *responseData = [request responseData];
                    NSLog ( @"block response is %@" ,responseString);
                    NSData *responseData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
                    NSString *deleteStr = [[NSString alloc] initWithFormat:@"delete from note where uuid=\"%@\"",[responseDict objectForKey:@"uuid"]];
                    if ([tySql open]) {
                        BOOL deleteUuid = [tySql deleteOneNote:deleteStr];
                    }
                    
                }];
                [request setFailedBlock :^{
                    // 请求响应失败，返回错误信息
                    NSError *error = [request error ];
                    NSLog ( @"error:%@" ,[error userInfo ]);
                }];
            }
        }
        if ([tySql open]) {
            [TYhelper deleteUnnecessaryDataInSql];
        }
    }
}

+ (void)getDataToSQL:(NSDictionary *)records{
    NSArray *noteArray = [records objectForKey:@"records"];
    TYSQLite *tySQL = [[TYSQLite alloc] init];
    NotePad *insertNote = [[NotePad alloc] init];
    for (NSDictionary *oneDict in noteArray){
        NSString *selectString = [NSString stringWithFormat:@"select * from note where uuid=\"%@\"",[oneDict objectForKey:@"uuid"]];
        if ([tySQL open]) {
            NSMutableArray *selectArray = [tySQL selectNotes:selectString];
            if ([selectArray count] == 0) {          
                insertNote.catalog = [oneDict objectForKey:@"catalog"];
                insertNote.exercise = [oneDict objectForKey:@"exercise"];
                insertNote.resistance = [[NSString alloc] initWithFormat:@"%d",[oneDict objectForKey:@"resistance"]];
                insertNote.repetition = [[NSString alloc] initWithFormat:@"%d",[oneDict objectForKey:@"repetition"]];
                insertNote.group = [[NSString alloc] initWithFormat:@"1"];
                insertNote.date = [oneDict objectForKey:@"date"];
                insertNote.tagID = [[NSString alloc] initWithFormat:@"noTagID"];
                insertNote.uuid = [oneDict objectForKey:@"uuid"];
                insertNote.status = [[NSString alloc] initWithFormat:@"settled"];

                TYSQLite *tySql = [[TYSQLite alloc] init];
                
                BOOL insertOK = [tySql insert:insertNote];
            }
        }
        
    }
}

//Check Network status
+ (BOOL)NetWorkIsOk{
    if (
        ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable)
        &&
        ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable)) {
        return YES;
    }else{
        return NO;
    }
}

+ (NSMutableArray *)notePadToArray:(NSArray *)noteArray{
    NSMutableArray *recordArray = [[NSMutableArray alloc] init];
    for (NotePad *oneNote in noteArray) {
        NSDictionary *oneDict = [[NSDictionary alloc] initWithObjectsAndKeys:oneNote.exercise, @"exercise", oneNote.catalog, @"catalog", oneNote.resistance, @"resistance", oneNote.repetition, @"repetition", oneNote.group, @"groups", oneNote.date, @"date", oneNote.tagID, @"tagid", nil];
        [recordArray addObject:oneDict];
    }
    return recordArray;
}

+ (NSDictionary *)serverDataToAppData:(NSDictionary *)serverData{
    NSArray *positionsList = @[@"Abs", @"Back", @"Biceps", @"Chest", @"Leg", @"Shoulder", @"Triceps"];
    NSMutableArray *absArray = [[NSMutableArray alloc] init];
    NSMutableArray *backArray = [[NSMutableArray alloc] init];
    NSMutableArray *bicepsArray = [[NSMutableArray alloc] init];
    NSMutableArray *chestArray = [[NSMutableArray alloc] init];
    NSMutableArray *legArray = [[NSMutableArray alloc] init];
    NSMutableArray *shoulderArray = [[NSMutableArray alloc] init];
    NSMutableArray *tricepsArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *appData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:absArray, @"Abs", backArray, @"Back", bicepsArray, @"Biceps", chestArray, @"Chest", legArray, @"Leg", shoulderArray, @"Shoulder", tricepsArray, @"Triceps", nil];
    NSMutableArray *serverArray = [serverData objectForKey:@"records"];
    //将data按照部位分类，并存入appData中
    for (NSString *positionlist in positionsList) {
        for (NSDictionary *actionlist in serverArray){
            NSRange urgentRange = [[actionlist objectForKey:@"catalog"] rangeOfString:positionlist];
            if (urgentRange.location != NSNotFound){
                [[appData objectForKey:positionlist] addObject:actionlist];
            }
        }
    }
    
    //删除Value为空的元素
    for (NSString *positionlist in positionsList){
        if([[appData objectForKey:positionlist] count] == 0){
            [appData removeObjectForKey:positionlist];
        }
    }
    NSLog(@"appData string is %@", appData);
    
    return appData;
}

+ (NSString *)syncGet:(NSURL *)url{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSData *received = [NSURLConnection sendSynchronousRequest:request  returningResponse:nil error:nil];
    NSString *str = [[NSString alloc] initWithData:received encoding:NSUTF8StringEncoding];
    return str;
}

+ (NSString *)syncPost:(NSURL *)url HTTPBody: (NSData *)body{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *str = [[NSString alloc] initWithData:received encoding:NSUTF8StringEncoding];
    return str;
}

+ (void)asyncGet:(NSURL *)url{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

+ (NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month

{
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setMonth:month];
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    
    [comps release];
    
    [calender release];
    
    return mDate;
    
}

@end