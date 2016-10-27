//
//  SDTodayContentCell.h
//  SimpleDiary
//
//  Created by vshiron on 15/12/15.
//  Copyright © 2015年 Apress. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SDDiaryContentFrame;


@interface SDTodayContentCell : UITableViewCell
+(instancetype)cellWithTable:(UITableView*)tableView;

@property (nonatomic , strong ) SDDiaryContentFrame *contentFrame;
@end
