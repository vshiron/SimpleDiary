//
//  SDSaveButton.m
//  SimpleDiary
//
//  Created by vshiron on 15/12/13.
//  Copyright © 2015年 Apress. All rights reserved.
//

#import "SDSaveButton.h"

@implementation SDSaveButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置普通状态下按钮模式
        [self setTitle:@"保存日记" forState:UIControlStateNormal
         ];
        
        //设置高亮状态下按钮模式
        [self setTitle:@"日记保存中..." forState:UIControlStateHighlighted
         ];
        
        
        //设置按钮的圆角半径不会被遮挡
        [self.layer setMasksToBounds:YES];
        //圆角半径
        [self.layer setCornerRadius:3];
        //边框宽度
        [self.layer setBorderWidth:2];
        
        [self.layer setBorderColor:(__bridge CGColorRef _Nullable)([UIColor grayColor])];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setBackgroundColor:SDColor(240, 240, 240)];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:14];

        
    }
    return self;
}


@end
