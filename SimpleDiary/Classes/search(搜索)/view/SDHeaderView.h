//
//  SDHeaderView.h
//  SimpleDiary
//
//  Created by vshiron on 15/12/21.
//  Copyright © 2015年 Apress. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SDDiaryContent;
@interface SDHeaderView : UITableViewHeaderFooterView

+ (instancetype)headerViewWith:(UITableView *)tableview;

@property (nonatomic , strong ) SDDiaryContent *contentDate;

@end
