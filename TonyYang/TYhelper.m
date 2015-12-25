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
            if ([[actionlist objectForKey:@"catalog"] isEqualToString:positionlist]){
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
@end