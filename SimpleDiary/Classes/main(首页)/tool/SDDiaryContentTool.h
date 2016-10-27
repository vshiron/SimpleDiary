//
//  SDDiaryContentTool.h
//  SimpleDiary
//
//  Created by vshiron on 15/12/14.
//  Copyright © 2015年 Apress. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SDDiaryContent;
@interface SDDiaryContentTool : NSObject

//+(void)saveContent:(NSString*)saveContent
//           saveDay:(NSString*)saveDay
//          saveTime:(NSString*)saveTime;
+(NSArray*)contentWithAllData;
+(NSArray*)contentWithTodayData;
+(NSArray*)contentWithMonthDate;
+(NSArray*)contentWithSomeDay:(NSString*)someDay;
+(void)savecontent:(SDDiaryContent*)content;
@end
