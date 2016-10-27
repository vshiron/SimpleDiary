//
//  SDTabBarController.m
//  SimpleDiary
//
//  Created by vshiron on 15/12/13.
//  Copyright © 2015年 Apress. All rights reserved.
// 1,搭建整体框架，添加tabBar为主控制器，其他基于导航控制器为子控制器，建立Note（viewController）,Search（TableviewController）,setting(TableviewController)为基础的控制器

#import "SDTabBarController.h"
#import "SDSearchController.h"
#import "SDSettingController.h"
#import "SDNoteController.h"
#import "SDNavgationController.h"
@interface SDTabBarController ()

@end

@implementation SDTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    //写日记控制器
    SDNoteController* note = [[SDNoteController alloc]init];
//    note.title = @"写日记";
//    note.view.backgroundColor = [UIColor whiteColor];
//    SDNavgationController* navNote = [[SDNavgationController alloc] initWithRootViewController:note];
//    [self addChildViewController:navNote];
    
    [self ChildViewContronller:note title:@"写日记" Image:@"pencil_n" SelectedImage:@"pencli_s"];
    
    //搜索控制器
    SDSearchController* search = [[SDSearchController alloc] init];
//    search.title = @"记忆树";
//    SDNavgationController* searchNav = [[SDNavgationController alloc] initWithRootViewController:search];
//    [self addChildViewController:searchNav];
    
    [self ChildViewContronller:search title:@"记忆树" Image:@"tree_n" SelectedImage:@"tree_s"];
    
    //设置控制器
    SDSettingController* setting = [[SDSettingController alloc] init];

    [self ChildViewContronller:setting title:@"设置" Image:@"Tools_n" SelectedImage:@"Tools_s"];
    
}

-(void)ChildViewContronller:(UIViewController*) ChildVc title:(NSString*)title Image:(NSString*)Image SelectedImage:(NSString*)SelectedImage {
    
    ChildVc.title = title;
    ChildVc.tabBarItem.image = [UIImage imageNamed:Image];
    ChildVc.tabBarItem.selectedImage = [[UIImage imageNamed:SelectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = SDColor(123, 123, 123);
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = SDColor(165, 235, 6);
    [ChildVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [ChildVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    SDNavgationController* Nav = [[SDNavgationController alloc] initWithRootViewController:ChildVc];
    [self addChildViewController:Nav];
    
    
}



@end
