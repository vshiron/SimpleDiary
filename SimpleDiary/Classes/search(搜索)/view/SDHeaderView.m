//
//  SDHeaderView.m
//  SimpleDiary
//
//  Created by vshiron on 15/12/21.
//  Copyright © 2015年 Apress. All rights reserved.
//

#import "SDHeaderView.h"
#import "SDDiaryContent.h"
@interface SDHeaderView ()
@property (nonatomic , strong ) UILabel *label;

@end

@implementation SDHeaderView

+(instancetype)headerViewWith:(UITableView *)tableview{
    
    static NSString *ID = @"headerView";
    //首先看缓存池中是否存在headerView，如果存在的 直接取出来用
    SDHeaderView *header = [tableview dequeueReusableHeaderFooterViewWithIdentifier:ID];
    
    if (header == nil) {
        //如果不存在   重新创建一个
        header = [[SDHeaderView alloc]initWithReuseIdentifier:ID];
    }
    
    return header;
    
}

-(void)setContentDate:(SDDiaryContent *)contentDate{
    _contentDate = contentDate;
    
    self.label.text = contentDate.saveDay;
    
}

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        UILabel *label = [[UILabel alloc]init];
        label.text =@"2015年12月21日";
        //居右显示
        label.textAlignment = NSTextAlignmentRight;
        
        [self.contentView addSubview:label];
        self.label = label;
    }
    
    return self;
}

/**
 *  当 当前的view 的frame 发生一些改变的时候  调用次方法  重新布局  内部的子控件
 */
- (void)layoutSubviews
{

    //获取屏幕的宽度
    //    CGFloat screenW = [[UIScreen mainScreen] bounds].size.width;
    
    CGFloat lblY = 0;
    CGFloat lblW = 150;
    CGFloat lblh = self.frame.size.height;
    CGFloat lblX = self.frame.size.width - lblW - 10;
    
    self.label.frame = CGRectMake(lblX, lblY, lblW, lblh);
    
}

@end
