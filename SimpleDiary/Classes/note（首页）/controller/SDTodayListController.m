//
//  SDTodayListController.m
//  SimpleDiary
//
//  Created by vshiron on 15/12/14.
//  Copyright © 2015年 Apress. All rights reserved.
//

#import "SDTodayListController.h"
#import "SDNoteController.h"
#import "SDDiaryContentTool.h"
#import "SDDiaryContent.h"
#import "SDTodayContentCell.h"
#import "SDDiaryContentFrame.h"

@interface SDTodayListController()
@property (nonatomic , strong ) NSMutableArray*contentFrame;
//@property (nonatomic , strong ) NSArray *contentes;
@end
@implementation SDTodayListController

-(NSMutableArray *)contentFrame{
    if (!_contentFrame) {
           
        self.contentFrame = [NSMutableArray array];

    }
    return _contentFrame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"今天";
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.tableHeaderView = [[UIView alloc] init];
    
    //取出数据库数据
    NSArray* contentes = [SDDiaryContentTool contentWithTodayData];
    //将模型数组转换为Frame数组
    NSMutableArray* contentFrames = [self contentFrameWithContentes:contentes];
    self.contentFrame = contentFrames;
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray*)contentFrameWithContentes:(NSArray*)contentes{
    NSMutableArray* frames = [NSMutableArray array];
    
    for (SDDiaryContent* content in contentes) {
        SDDiaryContentFrame* f = [[SDDiaryContentFrame alloc]init];
        f.content = content ;
        [frames addObject:f];
    }
    return frames;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentFrame.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SDTodayContentCell* cell=[SDTodayContentCell cellWithTable:tableView];
    

    
    cell.contentFrame = self.contentFrame[indexPath.row];
//    SDDiaryContent* content = self.contentes[indexPath.row];
//    cell.textLabel.text = content.saveContent;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SDDiaryContentFrame* frame = self.contentFrame[indexPath.row];
    return frame.cellHeight;
}
@end
