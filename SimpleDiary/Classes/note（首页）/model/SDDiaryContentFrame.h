//
//  SDDiaryContentFrame.h
//  SimpleDiary
//
//  Created by vshiron on 15/12/15.
//  Copyright © 2015年 Apress. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SDDiaryContent;

@interface SDDiaryContentFrame : NSObject
@property (nonatomic , strong ) SDDiaryContent* content;

/**
 *  需要保存内容
 */
@property (nonatomic , assign ) CGRect saveContentTextViweF;
/**
 *  需要保存日期
 */
@property (nonatomic , assign ) CGRect saveDayLableF;
/**
 *  需要保存时间
 */
@property (nonatomic , assign ) CGRect saveTimeLableF;
/**
 *  cell的高度
 */
@property (nonatomic, assign) CGFloat cellHeight;


@end
