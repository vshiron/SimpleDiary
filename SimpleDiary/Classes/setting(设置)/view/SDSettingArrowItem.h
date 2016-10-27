//
//  SDSettingArrowItem.h
//  SimpleDiary
//
//  Created by vshiron on 15/12/23.
//  Copyright © 2015年 Apress. All rights reserved.
//

#import "SDSettingItem.h"

@interface SDSettingArrowItem : SDSettingItem
// 调整的控制器的类名
@property (nonatomic, assign) Class destVcClass;

@property (nonatomic, copy) NSString *destVcName;

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVcClass:(Class)destVcClass;
@end
