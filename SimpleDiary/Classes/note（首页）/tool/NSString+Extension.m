//
//  NSString+Extension.m
//  SimpleDiary
//
//  Created by vshiron on 15/12/13.
//  Copyright © 2015年 Apress. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)
+(NSString*)stringBydateFormatter:(NSString*)formatterDate{
    //获取当前时间
    NSDate* date = [NSDate date];
    //格式化日期
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = formatterDate;
    return [formatter stringFromDate:date];
    
}

-(CGSize)sizeWithFont:(UIFont*)font maxW:(CGFloat)maxW{
    NSMutableDictionary* attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    
}

-(CGSize)sizeWithFont:(UIFont *)font{
    
    return [self sizeWithFont:font maxW:MAXFLOAT];
}


@end
