//
//  SDDiaryContentFrame.m
//  SimpleDiary
//
//  Created by vshiron on 15/12/15.
//  Copyright © 2015年 Apress. All rights reserved.
//

#import "SDDiaryContentFrame.h"
#import "SDDiaryContent.h"
#define SDContentCellBorderW 10

@implementation SDDiaryContentFrame
-(void)setContent:(SDDiaryContent *)content{
    
    _content = content;
    //时间
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    CGFloat timeX = SDContentCellBorderW;
    CGFloat timeY = 0;
    CGFloat timeW = cellW;
    CGFloat timeH =44;
    self.saveTimeLableF = CGRectMake(timeX, timeY, timeW, timeH);
    
    //正文
    CGFloat contentX = SDContentCellBorderW;
    CGFloat contentY = CGRectGetMaxY(self.saveTimeLableF) ;
//    CGFloat contentW = timeX;
//    CGFloat contentH = MAXFLOAT;
//    self.saveContentTextViweF = CGRectMake(contentX, contentY, contentW, contentH);
    
    CGFloat maxW = cellW -2 * SDContentCellBorderW - SDContentCellBorderW;
    
    CGSize contentSize = [content.saveContent sizeWithFont:[UIFont systemFontOfSize:16] maxW:maxW];
    
    self.saveContentTextViweF = (CGRect){{contentX,contentY},contentSize};
    
    self.cellHeight = CGRectGetMaxY(self.saveContentTextViweF);

}

@end
