//
//  SDKeyboardTool.h
//  SimpleDiary
//
//  Created by vshiron on 15/12/13.
//  Copyright © 2015年 Apress. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDKeyboardTool,SDSaveButton;

@protocol SDKeyboardToolDelegate <NSObject>

-(void)keyboardTool:(SDKeyboardTool*)keyboard didSaveButton:(SDSaveButton*)button;

@end


@interface SDKeyboardTool : UIView

@property (nonatomic ,weak) id<SDKeyboardToolDelegate> delagate;
@end
