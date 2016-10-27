

//
//  SDIntroduceController.m
//  SimpleDiary
//
//  Created by vshiron on 15/12/23.
//  Copyright © 2015年 Apress. All rights reserved.
//

#import "SDIntroduceController.h"
#define kPagecount 3
@interface SDIntroduceController ()<UIScrollViewAccessibilityDelegate>
@property (nonatomic ,weak ) UIPageControl* pageControl;
@end

@implementation SDIntroduceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //1.创建scrollView属性
    UIScrollView* scroll = [[UIScrollView alloc] init];
//    scroll.size = ;
    scroll.size = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height -64);
    //    scroll.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:scroll];
    
    //2.添加scrollView的图片属性
    
    CGFloat scrollW = scroll.width;
    CGFloat scrollH = scroll.height;
    for (int i = 0; i < kPagecount; i ++) {
        UIImageView * imageView = [[UIImageView alloc ]init];
        NSString* name = [NSString stringWithFormat:@"introduce_%d" , i +1 ];
        imageView.image = [UIImage imageNamed:name];
        imageView.width = scrollW;
        imageView.height = scrollH;
        imageView.y = 0;
        imageView.x = i * scrollW;
        [scroll addSubview:imageView];
        
        //如果是最后一个页码，则需要添加button和label
        
    
    }
    
    //3.设置scrolView的其他属性
    scroll.bounces = NO;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.contentSize = CGSizeMake(kPagecount * scroll.size.width, 0);
    scroll.pagingEnabled = YES;
    scroll.delegate =self;
    
    //4设置分页效果
    UIPageControl* pageControl = [[UIPageControl alloc]init];
    pageControl.numberOfPages = kPagecount;
    pageControl.backgroundColor = [UIColor redColor];
    //    pageControl.width =100;
    //    pageControl.heigth = 50;
    pageControl.currentPageIndicatorTintColor = SDColor(92, 153, 26);
    pageControl.pageIndicatorTintColor = SDColor(189, 189, 189);
    pageControl.centerX = scrollW * 0.5;
    pageControl.centerY = scrollH + 20;
    self.pageControl = pageControl;
    
    [self.view addSubview:pageControl];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    double page = scrollView.contentOffset.x / scrollView.width;
    
    //四舍五入运算，即图片跨越一半时立刻调整页码
    self.pageControl.currentPage = (int)(page + 0.5);
}



@end
