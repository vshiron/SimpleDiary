//
//  SDSettingGroup.h
//  SimpleDiary
//
//  Created by vshiron on 15/12/23.
//  Copyright © 2015年 Apress. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDSettingGroup : NSObject

@property (nonatomic, copy) NSString *header;

@property (nonatomic, strong) NSArray *items;

@property (nonatomic, copy) NSString *footer;
@end
