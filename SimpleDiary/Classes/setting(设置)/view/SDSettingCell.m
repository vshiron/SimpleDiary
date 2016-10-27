//
//  SDSettingCell.m
//  SimpleDiary
//
//  Created by vshiron on 15/12/23.
//  Copyright © 2015年 Apress. All rights reserved.
//

#import "SDSettingCell.h"
#import "SDSettingItem.h"
#import "SDSettingArrowItem.h"
#import "SDSettingSwitchItem.h"

@interface SDSettingCell()
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic , strong ) UIImageView *Settingimage;

@end
@implementation SDSettingCell

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeValueforSwitch) name:@"SDDidLockChangeNSNotification" object:nil];
//    }
//    return self;
//}

- (UIImageView *)imgView
{
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellArrow"]];
    }
    return _imgView;
}

- (SDSwitchView *)switchView
{
    if (_switchView == nil) {
        
        _switchView = [SDSwitchView sharedSwitchView];

    }
    return _switchView;
}

- (void)setItem:(SDSettingItem *)item
{
    _item = item;
    
    
    // 1.设置cell的子控件的数据
    [self setUpData];
    
    // 2.设置右边视图
    [self setUpAccessoryView];
    
}

// 设置cell的子控件的数据
- (void)setUpData
{
    self.imageView.image = [UIImage imageNamed:_item.icon];
    self.imageView.size = CGSizeMake(25, 25);
//    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.textLabel.text = _item.title;
}

// 设置右边视图
- (void)setUpAccessoryView
{
    if ([_item isKindOfClass:[SDSettingArrowItem class]]) { // 箭头
        self.accessoryView = self.imgView;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }else if ([_item isKindOfClass:[SDSettingSwitchItem class]]){ // Switch
        self.accessoryView = self.switchView;
        
        [self.switchView setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"SwtichValue"] animated:NO];

        [self.switchView addTarget:self action:@selector(lockChange) forControlEvents:UIControlEventValueChanged];


        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        self.accessoryView = nil;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
}


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    SDSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID ];
    
    if (cell == nil) {
        cell = [[SDSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}

-(void)lockChange{
    if (self.switchView.isOn == YES) {
        //设置通知中心，监听按钮点击
       [[NSNotificationCenter defaultCenter] postNotificationName:@"SDDidLockChangeNSNotification" object:nil];
    }else{

        // 同步：把内存中的数据和沙盒同步
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setBool:self.switchView.isOn forKey:@"SwtichValue"];
        
        [defaults synchronize];
        
    }

}


- (void)layoutSubviews {
    //改变系统cell.imageView大小的方法
    [super layoutSubviews];
    
    self.imageView.bounds =CGRectMake(10,5,30,30);
    
    self.imageView.frame =CGRectMake(10,5,30,30);
    
    self.imageView.contentMode =UIViewContentModeScaleAspectFit;
    
    
    //cell.textLabel
    CGRect tmpFrame = self.textLabel.frame;
    
    tmpFrame.origin.x = 46;
    
    self.textLabel.frame = tmpFrame;

    //cell.detailTextLabel
    tmpFrame = self.detailTextLabel.frame;
    
    tmpFrame.origin.x = 46;
    
    self.detailTextLabel.frame = tmpFrame;
    
}

@end
