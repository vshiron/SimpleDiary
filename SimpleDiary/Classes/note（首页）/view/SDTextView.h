//
//  SDTextView.h
//  SimpleDiary
//
//  Created by vshiron on 15/12/13.
//  Copyright © 2015年 Apress. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDTextView : UITextView
/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字的颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;
@end
