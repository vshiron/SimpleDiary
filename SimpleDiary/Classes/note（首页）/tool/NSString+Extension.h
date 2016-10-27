//
//  NSString+Extension.h
//  SimpleDiary
//
//  Created by vshiron on 15/12/13.
//  Copyright © 2015年 Apress. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)
+(NSString*)stringBydateFormatter:(NSString*)formatter;
-(CGSize)sizeWithFont:(UIFont*)font maxW:(CGFloat)maxW;
-(CGSize)sizeWithFont:(UIFont *)font;
@end
