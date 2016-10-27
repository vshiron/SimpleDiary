//
//  SDSearchController.m
//  SimpleDiary
//
//  Created by vshiron on 15/12/13.
//  Copyright © 2015年 Apress. All rights reserved.
//
#import "SDSearchController.h"
#import "SDDiaryContentTool.h"
#import "SDDiaryContent.h"
#import "SDTodayContentCell.h"
#import "SDDiaryContentFrame.h"
#import "SDHeaderView.h"
#import "CustomCalendarViewController.h"
#import "MBProgressHUD+MJ.h"
#import "MJRefresh.h"
@interface SDSearchController ()<CustomCalendarViewControllerDelegate>
@property (nonatomic , strong ) NSMutableArray*contentFrame;
@property (nonatomic , strong ) NSArray* contentes;
@property (nonatomic , strong ) CustomCalendarViewController *calendar;
@end

@implementation SDSearchController

-(NSArray *)contentes{
    if (!_contentes) {
        
        NSArray* arr = [SDDiaryContentTool contentWithTodayData];
        
        if ( arr.count == 0) {
            SDDiaryContent* nilDiary = [[SDDiaryContent alloc] init];
            nilDiary.saveContent =@"今天还没开始写日记吧";;
            nilDiary.saveTime = @"^_^";
            nilDiary.saveDay = @"爱自己，爱生活~";
            _contentes = @[nilDiary];
        }else{
            
            self.contentes = [SDDiaryContentTool contentWithTodayData];
        }
    }
    return _contentes;
}

//懒加载
-(NSMutableArray *)contentFrame{
    if (!_contentFrame) {
        
        self.contentFrame = [NSMutableArray array];     
    }
    return _contentFrame;
}
/**
 *  字典数组转模型数组
 */
-(NSMutableArray*)contentFrameWithContentes:(NSArray*)contentes{
    NSMutableArray* frames = [NSMutableArray array];
    
    for (SDDiaryContent* content in contentes) {
        SDDiaryContentFrame* f = [[SDDiaryContentFrame alloc]init];
        f.content = content ;
        [frames addObject:f];
    }
    return frames;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView reloadData];
    
    [self setupNav];
    
    [self setupdata];
    [self setupRefresh];
    
    self.tableView.tableHeaderView = [[UIView alloc] init];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

-(void)setupdata{
    //取出数据库数据
    
    //将模型数组转换为Frame数组
    NSMutableArray* contentFrames = [self contentFrameWithContentes:self.contentes];
    self.contentFrame = contentFrames;
}


-(void)setupNav{
    //设置导航栏标题
    self.navigationController.title =@"记忆树";
    //取出日历图片
    UIImage *imageRight =[[UIImage imageNamed:@"Calendar-Day-of-Week"]
                     imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *imageLeft =[[UIImage imageNamed:@"Brightness"]
                          imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    //自定义按钮"日历表"
    UIButton* btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRight addTarget:self action:@selector(showCalendar) forControlEvents:UIControlEventTouchUpInside];
    [btnRight setBackgroundImage:imageRight forState:UIControlStateNormal];
    btnRight.size = CGSizeMake(30, 30);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btnRight];
    
    //自定义按钮“今天”
    UIButton* btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft addTarget:self action:@selector(showToday) forControlEvents:UIControlEventTouchUpInside];
    [btnLeft setBackgroundImage:imageLeft forState:UIControlStateNormal];
    btnLeft.size = CGSizeMake(30, 30);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
}
-(void)showToday{
    [MBProgressHUD showSuccess:@"快速回到今天日记中..."];
    [self judgeTodayHaveContent];
    //刷新表格
    [self.tableView reloadData];
    
}
-(void)judgeTodayHaveContent{
    //重新装载数据
    if ( [SDDiaryContentTool contentWithTodayData].count == 0) {
        SDDiaryContent* nilDiary = [[SDDiaryContent alloc] init];
        nilDiary.saveContent =@"今天还没开始写日记吧";;
        nilDiary.saveTime = @"^_^";
        nilDiary.saveDay = @"爱自己，爱生活~";
        NSArray * selected = @[nilDiary];
        NSMutableArray* contentFrames = [self contentFrameWithContentes:selected];
        self.contentFrame = contentFrames;
    }else{
        NSArray * selected = [SDDiaryContentTool contentWithTodayData];
        NSMutableArray* contentFrames = [self contentFrameWithContentes:selected];
        self.contentFrame = contentFrames;
    }
}



-(void)showCalendar{
    
    CustomCalendarViewController* calendar = [[CustomCalendarViewController alloc] init];
    calendar.delegate = self;
    self.calendar =calendar;
    [self.navigationController pushViewController:calendar animated:YES];
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
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SDDiaryContentFrame* frame = self.contentFrame[indexPath.row];
    
    
    return frame.cellHeight;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    SDHeaderView* headerView = [SDHeaderView headerViewWith:tableView];
    
    
    
    SDDiaryContentFrame* frame = self.contentFrame[section];
    
   
    
    headerView.contentDate = frame.content;
    
    
    return headerView;
    
}
#pragma mark - CustomCalendarViewControllerDelegate

-(void)sendSelectedDate:(NSString *)SelectedDate{
    //重新装载数据
    NSArray * selected = [SDDiaryContentTool contentWithSomeDay:SelectedDate];
    NSMutableArray* contentFrames = [self contentFrameWithContentes:selected];
    self.contentFrame = contentFrames;
    //刷新表格
    [self.tableView reloadData];
}

- (void)setupRefresh
{
    //下拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    [self.tableView headerBeginRefreshing];

    //一些设置
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    self.tableView.headerRefreshingText = @"刷新中。。。";
}

//下拉刷新
- (void)headerRereshing
{
    // 1.添加假数据
    //重新装载数据

    [self judgeTodayHaveContent];
    [self.tableView reloadData];
    //2.结束刷新
    [self.tableView headerEndRefreshing];
}



@end
