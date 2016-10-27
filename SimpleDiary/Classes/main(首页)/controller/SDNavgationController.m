
//
//  SDNavgationController.m
//  SimpleDiary
//
//  Created by vshiron on 15/12/13.
//  Copyright © 2015年 Apress. All rights reserved.
//

#import "SDNavgationController.h"
#import "UIBarButtonItem+Extension.h"

@interface SDNavgationController ()
@property (nonatomic , strong ) UINavigationBar *navBar;
@end

@implementation SDNavgationController


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationBar.backgroundColor = SDColor(1, 1, 1);
//    UINavigationBar *navBar = [UINavigationBar appearance];
//    navBar.backgroundColor = SDColor(23, 23, 23);

    self.navBar =[UINavigationBar appearance];
    
    [self.navBar setBackgroundImage:[UIImage imageNamed:@"bg_navigationBar_normal"] forBarMetrics:UIBarMetricsDefault];
    [self.navBar setBackgroundColor:[UIColor redColor]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //如果进来时不是第一个界面导航控制器，则添加返回按钮并隐藏tabbar
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"back_n" highImageName:@"back_h" target:self action:@selector(back)];
                                                            }
    [super pushViewController:viewController animated:animated];
    
    
}
-(void)back{
    
    [self popViewControllerAnimated:YES];
    
}

+ (void)initialize
{
//    UINavigationBar *navBar =[UINavigationBar appearance];
//    [navBar setBackgroundImage:[UIImage imageNamed:@"bg_navigationBar_normal"] forBarMetrics:UIBarMetricsDefault];
    
    
//    UIBarButtonItem *item = [UIBarButtonItem appearance];
//    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//    attrs[NSForegroundColorAttributeName] = [UIColor blackColor];
//    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
}

@end
