//
//  SDDiaryContentTool.m
//  SimpleDiary
//
//  Created by vshiron on 15/12/14.
//  Copyright © 2015年 Apress. All rights reserved.
//

#import "SDDiaryContentTool.h"
#import "FMDB.h"
#import "SDDiaryContent.h"
@implementation SDDiaryContentTool
static FMDatabase *_db;
+ (void)initialize
{
    // 1.打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"diaryContent.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];

    // 2.创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_diary (id integer PRIMARY KEY, content blod NOT NULL, saveDay text NOT NULL,saveTime text NOT NULL);"];
}





+(void)savecontent:(SDDiaryContent*)content{
    
        NSData* contentData = [NSKeyedArchiver archivedDataWithRootObject:content];
        [_db executeUpdateWithFormat:@"INSERT INTO t_diary(content, saveDay,saveTime) VALUES (%@, %@ , %@);", contentData, content.saveDay,content.saveTime];
    
}

+(NSArray*)contentWithAllData{

//    NSString* sql = [NSString stringWithFormat:@"SELECT * FROM t_diary WHERE saveDay = %@ ",saveDay];
    NSString* sql = @"SELECT * FROM t_diary";

    FMResultSet* set = [_db executeQuery:sql];
    NSMutableArray* contentes = [NSMutableArray array];

    while (set.next) {
      
        NSData *contentData = [set objectForColumnName:@"content"];
        
        NSDictionary *status = [NSKeyedUnarchiver unarchiveObjectWithData:contentData];

        [contentes addObject:status];
    }
     return contentes;
}

+(NSArray*)contentWithTodayData{
    NSString* saveDay = [NSString stringBydateFormatter:@"yyyy年MM月dd日"];
    
    NSString* sql = [NSString stringWithFormat:@"SELECT * FROM t_diary WHERE saveDay = '%@' ;",saveDay];
//    NSString* sql = @"SELECT * FROM t_diary ORDER BY saveDay DESC LIMIT 20;";
    
    
    FMResultSet* set = [_db executeQuery:sql];
    NSMutableArray* contentes = [NSMutableArray array];
    
    while (set.next) {
        
        NSData *contentData = [set objectForColumnName:@"content"];
        
        NSDictionary *status = [NSKeyedUnarchiver unarchiveObjectWithData:contentData];
        
        [contentes addObject:status];
    }
    return contentes;
}
+(NSArray*)contentWithMonthDate{
  
    NSString* saveDay = [NSString stringBydateFormatter:@"yyyy年MM月"];
    
    NSString* sql = [NSString stringWithFormat:@"SELECT * FROM t_diary WHERE saveDay like '%@%%' ;",saveDay];
//        NSString* sql = @"SELECT * FROM t_diary WHERE saveDay like '2015年12月%'";
    
    
    FMResultSet* set = [_db executeQuery:sql];
    NSMutableArray* contentes = [NSMutableArray array];
    
    while (set.next) {
        
        NSData *contentData = [set objectForColumnName:@"content"];
        
        NSDictionary *status = [NSKeyedUnarchiver unarchiveObjectWithData:contentData];
        
        [contentes addObject:status];
    }
    return contentes;
}


+(NSArray*)contentWithSomeDay:(NSString*)someDay{
//    NSString* saveDay = [NSString stringBydateFormatter:someDay];
    
    NSString* sql = [NSString stringWithFormat:@"SELECT * FROM t_diary WHERE saveDay = '%@' ;",someDay];
    //    NSString* sql = @"SELECT * FROM t_diary ORDER BY saveDay DESC LIMIT 20;";
    
    
    FMResultSet* set = [_db executeQuery:sql];
    NSMutableArray* contentes = [NSMutableArray array];
    
    while (set.next) {
        
        NSData *contentData = [set objectForColumnName:@"content"];
        
        NSDictionary *status = [NSKeyedUnarchiver unarchiveObjectWithData:contentData];
        
        [contentes addObject:status];
    }
    return contentes;
}

+(NSArray*)contentWithYesterdayDate{
    
    
    
    NSString* saveDay = [NSString stringBydateFormatter:@"yyyy年MM月"];
    
    NSString* sql = [NSString stringWithFormat:@"SELECT * FROM t_diary WHERE saveDay = '%@' ;",saveDay];
    
    
    FMResultSet* set = [_db executeQuery:sql];
    NSMutableArray* contentes = [NSMutableArray array];
    
    while (set.next) {
        
        NSData *contentData = [set objectForColumnName:@"content"];
        
        NSDictionary *status = [NSKeyedUnarchiver unarchiveObjectWithData:contentData];
        
        [contentes addObject:status];
    }
    return contentes;
}

@end
