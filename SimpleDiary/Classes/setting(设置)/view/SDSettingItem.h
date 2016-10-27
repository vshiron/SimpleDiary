//
//  SDSettingItem.h
//  SimpleDiary
//
//  Created by vshiron on 15/12/23.
//  Copyright © 2015年 Apress. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^SDSettingItemOption)();
@interface SDSettingItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) SDSettingItemOption option;

//@property (nonatomic, assign) ILSettingItemType type;

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title;
@end
