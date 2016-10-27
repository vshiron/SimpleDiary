//
//  SDDiaryContent.h
//  SimpleDiary
//
//  Created by vshiron on 15/12/14.
//  Copyright © 2015年 Apress. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDDiaryContent : NSObject
/**
 *  需要保存内容
 */
@property (nonatomic , strong ) NSString *saveContent;
/**
 *  需要保存日期
 */
@property (nonatomic , strong ) NSString *saveDay;
/**
 *  需要保存时间
 */
@property (nonatomic , strong ) NSString *saveTime;

@end
