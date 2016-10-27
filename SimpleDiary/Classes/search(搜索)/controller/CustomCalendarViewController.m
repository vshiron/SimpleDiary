//
//  CustomCalendarViewController.h
//  sampleCalendar
//
//  Created by Michael Azevedo on 21/07/2014.
//  Copyright (c) 2014 Michael Azevedo All rights reserved.
//

#import "CustomCalendarViewController.h"
#import "SDDiaryContentTool.h"
#import "MBProgressHUD+MJ.h"
@interface CustomCalendarViewController ()

@property (nonatomic, strong) CalendarView * customCalendarView;
@property (nonatomic, strong) NSCalendar * gregorian;
@property (nonatomic, assign) NSInteger currentYear;
@end

@implementation CustomCalendarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.title = @"心路历程";
    
    _gregorian       = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //设置日历所有属性
    CGFloat customCalendarW = [UIScreen mainScreen].bounds.size.width;
    CGFloat customCalendarH = customCalendarW * 8 / 9;
    
    
    _customCalendarView                             = [[CalendarView alloc]initWithFrame:CGRectMake(0, 64, customCalendarW, customCalendarH)];
    _customCalendarView.delegate                    = self;
    _customCalendarView.datasource                  = self;
    _customCalendarView.calendarDate                = [NSDate date];
    _customCalendarView.monthAndDayTextColor        = RGBCOLOR(0, 174, 255);//抬头
    _customCalendarView.dayBgColorWithData          = RGBCOLOR(116, 173, 34);//1-25
    _customCalendarView.dayBgColorWithoutData       = RGBCOLOR(220, 201, 87);//27-31
    _customCalendarView.dayBgColorSelected          = RGBCOLOR(209, 225, 8);//26
    _customCalendarView.dayTxtColorWithoutData      = RGBCOLOR(57, 69, 84);
    _customCalendarView.dayTxtColorWithData         = [UIColor whiteColor];
    _customCalendarView.dayTxtColorSelected         = [UIColor whiteColor];    
    _customCalendarView.borderColor                 = RGBCOLOR(159, 162, 172);
    _customCalendarView.borderWidth                 = 1;
    _customCalendarView.allowsChangeMonthByDayTap   = YES;
    _customCalendarView.allowsChangeMonthByButtons  = YES;
    _customCalendarView.keepSelDayWhenMonthChange   = YES;
    //是否有翻页效果
//    _customCalendarView.nextMonthAnimation          = UIViewAnimationOptionTransitionFlipFromRight;
//    _customCalendarView.prevMonthAnimation          = UIViewAnimationOptionTransitionFlipFromLeft;
    
    dispatch_async(dispatch_get_main_queue(), ^{        
        [self.view addSubview:_customCalendarView];
        _customCalendarView.center = CGPointMake(self.view.center.x, _customCalendarView.center.y);
    });
    
    NSDateComponents * yearComponent = [_gregorian components:NSCalendarUnitYear fromDate:[NSDate date]];
    _currentYear = yearComponent.year;

}

#pragma mark - Gesture recognizer

-(void)swipeleft:(id)sender
{
    [_customCalendarView showNextMonth];
}

-(void)swiperight:(id)sender
{
    [_customCalendarView showPreviousMonth];
}

#pragma mark - CalendarDelegate protocol conformance

-(void)dayChangedToDate:(NSDate *)selectedDate
{
    //如果选择日期比今天小，肯定是忘了写日记，如果还没到，那就是还没到啊~
    NSDate * nowDate = [NSDate date];
   
    //点击选择某一天，离开查询数据库当天是否有些日记，没有则显示“那天偷懒没写日记吧~”
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
   
   
    //时间本地化
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
    //日期格式化
     formatter.dateFormat = @"yyyy年MM月dd日";
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //NSCalendarUnit声明两个时间相差了多少时间
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour |
    NSCalendarUnitMinute | NSCalendarUnitSecond;
    //计算两个日期之间的差距
    NSDateComponents* cmps =  [calendar components:unit fromDate:selectedDate toDate:nowDate options:0];
    
    NSString* selectedDateStr = [formatter stringFromDate:selectedDate];
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_after(0.01, queue, ^{
        //如果当天有写日记，则返回到搜索界面，显示当天日记
        if ([SDDiaryContentTool contentWithSomeDay:selectedDateStr].count) {
            
            if ([_delegate respondsToSelector:@selector(sendSelectedDate:)]) {
                [_delegate sendSelectedDate:selectedDateStr];
            }
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
        }else if (cmps.day > 0){
            
            [MBProgressHUD showError:@"这天偷懒没写日记吧~"];
        }else{
            
            [MBProgressHUD showError:@"这天还没到呢，不要急~"];
        }
    }) ;
  
    
}

#pragma mark - CalendarDataSource protocol conformance

-(BOOL)isDataForDate:(NSDate *)date
{
    if ([date compare:[NSDate date]] == NSOrderedAscending)
        return YES;
    return NO;
}

-(BOOL)canSwipeToDate:(NSDate *)date
{
    NSDateComponents * yearComponent = [_gregorian components:NSCalendarUnitYear fromDate:date];
    return (yearComponent.year == _currentYear || yearComponent.year == _currentYear+1);
}

#pragma mark - Action methods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
