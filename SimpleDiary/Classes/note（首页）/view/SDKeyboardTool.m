//
//  SDKeyboardTool.m
//  SimpleDiary
//
//  Created by vshiron on 15/12/13.
//  Copyright © 2015年 Apress. All rights reserved.
//

#import "SDKeyboardTool.h"
#import "SDSaveButton.h"

@interface SDKeyboardTool()

@property (nonatomic , weak ) UILabel *tipsLabel;
@end

@implementation SDKeyboardTool

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupLabel];
        NSTimer* time = [NSTimer timerWithTimeInterval:5.0 target:self selector:@selector(autoSaveContent) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:time forMode:NSRunLoopCommonModes];

    }
    return self;
}



/**
 *设置自动保存（提示）
 */
-(void)setupLabel{
    
    UILabel* tipsLabel = [[UILabel alloc] init];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    NSString* strDate = [NSString stringBydateFormatter:@"HH:mm"];
    NSString* strFormat =[NSString stringWithFormat:@"%@ 保存到草稿中...",strDate];
    tipsLabel.text = strFormat;
    tipsLabel.textColor = [UIColor grayColor];
    [self addSubview:tipsLabel];
    //    tipsLabel.textColor = [UIColor grayColor];
    tipsLabel.font = [UIFont systemFontOfSize:12];
    self.tipsLabel = tipsLabel;
    self.tipsLabel.hidden = YES;
    
    
}




-(void)layoutSubviews{
    
    [super layoutSubviews];
    CGFloat screenW =[UIScreen mainScreen].bounds.size.width;
    //设置自动保存提示frame
    CGFloat tipsLabelX = 0;
    CGFloat tipsLabelY = 0;
    CGFloat tipsLabelW = 0.5 * screenW;
    CGFloat tipsLabelH = 0.8 * self.bounds.size.height;
    self.tipsLabel.frame = CGRectMake(tipsLabelX, tipsLabelY, tipsLabelW, tipsLabelH);

    
}


-(void)autoSaveContent{
    //    self.tipsLabel.hidden = !self.tipsLabel.hidden;
    //    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //这里要使用dispatch_get_main_queue(),否则好像无法正常刷新，异步线程好像有异常？
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.tipsLabel.hidden = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.tipsLabel.hidden = YES;
            
        });
    });
}







@end
