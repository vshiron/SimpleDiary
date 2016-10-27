//
//  SDSettingCell.h
//  SimpleDiary
//
//  Created by vshiron on 15/12/23.
//  Copyright © 2015年 Apress. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDSwitchView.h"
@class SDSettingItem;

@interface SDSettingCell : UITableViewCell
@property (nonatomic, strong) SDSettingItem *item;
@property (nonatomic, strong) SDSwitchView *switchView;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
