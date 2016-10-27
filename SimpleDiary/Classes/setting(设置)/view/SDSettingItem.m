//
//  SDSettingItem.m
//  SimpleDiary
//
//  Created by vshiron on 15/12/23.
//  Copyright © 2015年 Apress. All rights reserved.
//

#import "SDSettingItem.h"

@implementation SDSettingItem
+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title
{
    SDSettingItem *item = [[self alloc] init];
    
    item.icon = icon;
    item.title = title;
    
    return item;
}

@end
