//
//  SDTodayContentCell.m
//  SimpleDiary
//
//  Created by vshiron on 15/12/15.
//  Copyright © 2015年 Apress. All rights reserved.
//

#import "SDTodayContentCell.h"
#import "SDDiaryContent.h"
#import "SDDiaryTextView.h"
#import "SDDiaryContentFrame.h"
@interface SDTodayContentCell()
/**
 *  需要保存内容
 */
@property (nonatomic , strong ) UITextView *saveContentTextViwe;
/**
 *  需要保存日期
 */
@property (nonatomic , strong ) UILabel *saveDayLable;
/**
 *  需要保存时间
 */
@property (nonatomic , strong ) UILabel *saveTimeLable;

@end

@implementation SDTodayContentCell

+(instancetype)cellWithTable:(UITableView*)tableView{
    
    
    static NSString* ID = @"cell";
    SDTodayContentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SDTodayContentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    return cell;
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self setupContent];
//        self.selected= NO;
        self.userInteractionEnabled = NO;
//        self.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    return self;
}
/**
 *  设置需要显示的主体
 */
-(void)setupContent{
    /** 设置正文主体*/
    UITextView* saveContentTextView =[[UITextView alloc] init];
    [self.contentView addSubview:saveContentTextView];
//    saveContentTextView.backgroundColor  = [UIColor greenColor];
    self.saveContentTextViwe =saveContentTextView;
    self.saveContentTextViwe.textColor = [UIColor blackColor];
    saveContentTextView.editable =NO;
    saveContentTextView.scrollEnabled = NO;
    self.saveContentTextViwe.textContainerInset = UIEdgeInsetsMake(0, -5, 0, -5);
    
    
    /** 设置时间主体 */
    
    UILabel* saveTimeLable = [[UILabel alloc]init];
    [self.contentView addSubview:saveTimeLable];
//    saveTimeLable.backgroundColor = [UIColor yellowColor];
    self.saveTimeLable = saveTimeLable;
    
    
}
-(void)setContentFrame:(SDDiaryContentFrame *)contentFrame{
    _contentFrame = contentFrame;
    
    SDDiaryContent* Content = contentFrame.content;
    
    /** 设置正文内容*/
    self.saveContentTextViwe.frame = contentFrame.saveContentTextViweF;
    self.saveContentTextViwe.text = Content.saveContent;
    self.saveContentTextViwe.font = [UIFont systemFontOfSize:16];
    
    /** 设置时间位置*/
    
    self.saveTimeLable.frame = contentFrame.saveTimeLableF;
    self.saveTimeLable.text = Content.saveTime;
    self.saveTimeLable.font = [UIFont boldSystemFontOfSize:12];
    self.saveTimeLable.textColor = SDColor(140, 140, 140);
    
    
}

@end
