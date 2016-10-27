//
//  SDNoteController.m
//  SimpleDiary
//
//  Created by vshiron on 15/12/13.
//  Copyright © 2015年 Apress. All rights reserved.
//

#import "SDNoteController.h"
#import "SDTextView.h"
#import "SDSaveButton.h"
#import "SDKeyboardTool.h"
#import "SDDiaryContent.h"
#import "MJExtension.h"
#import "SDTodayListController.h"
#import "UIBarButtonItem+Extension.h"
#import "CLLockVC.h"

@interface SDNoteController ()<UITextViewDelegate>
@property (nonatomic , weak ) SDTextView *textView;
@property (nonatomic , weak ) SDKeyboardTool *toolbar;
/** 是否正在切换键盘 */
@property (nonatomic, assign) BOOL switchingKeybaord;
/** 日记数组 */
@property (nonatomic , strong ) NSMutableArray *contentes;
@end

@implementation SDNoteController
#pragma mark - 懒加载联系人列表
-(NSMutableArray *)contentes{
    if (!_contentes) {
        self.contentes = [NSMutableArray array];
    }
    return _contentes;
}
#pragma mark - 设置内部控件位置
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //添加文本框
    [self setupTextView];

    //设置导航栏内容
    [self setupNav];
    
    //设置提示

    [self setupKeyboardTool];
    
    
    // 键盘的frame发生改变时发出的通知（位置和尺寸）
    [SDNotificationCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];

    NSTimer* time = [NSTimer timerWithTimeInterval:60.0 target:self selector:@selector(autoSaveCurrentContent) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:time forMode:NSRunLoopCommonModes];
    
}

#pragma mark - 设置显示内容
//添加小工具条小时保存内容
-(void)setupKeyboardTool{
    
    SDKeyboardTool* toolbar = [[SDKeyboardTool alloc] init];
    toolbar.width = self.view.width;
    toolbar.height = 30;
    toolbar.y = self.view.height - toolbar.height ;
    [self.view addSubview:toolbar];
    self.toolbar = toolbar;
    
}


/**
 *  设置导航栏内容
 */
-(void)setupNav{
    
    NSString* dateStr = [NSString stringBydateFormatter:@"yyyy年MM月dd日"];
    NSString* writeDiary = @"写日记";
    //设置nav中间显示的内容
    UILabel* titleView = [[UILabel alloc]init];
    titleView.width = 150;
    titleView.height = 50;
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.numberOfLines = 0;
//    titleView.y = 50;
    NSString* str =[NSString stringWithFormat:@"%@\n%@",writeDiary,dateStr];
    
    //创建一个带属性的字符串
    NSMutableAttributedString* attrStr = [[NSMutableAttributedString alloc]initWithString:str];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:[str rangeOfString:writeDiary]];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:[str rangeOfString:dateStr]];
    titleView.attributedText = attrStr;
    self.navigationItem.titleView = titleView;
    
    
    //保存
    UIBarButtonItem* saveBarbutton = [UIBarButtonItem itemWithImageName:@"save" highImageName:@"save" target:self action:@selector(saveContent)];
    saveBarbutton.customView.width = 35;
    saveBarbutton.customView.height = 35;
    
    //一分钟记录
    UIBarButtonItem* recoverBarbutton = [UIBarButtonItem itemWithImageName:@"Cloud" highImageName:@"Cloud" target:self action:@selector(recoverContent)];
    recoverBarbutton.customView.width = 25;
    recoverBarbutton.customView.height = 25;
    
    UIBarButtonItem* fontBarbutton = [UIBarButtonItem itemWithImageName:@"Font_n" highImageName:@"Font_h" target:self action:@selector(fontChange)];
    fontBarbutton.customView.width = 25;
    fontBarbutton.customView.height = 25;
    self.navigationItem.leftBarButtonItem =fontBarbutton;
    
    
//    self.navigationItem
    self.navigationItem.rightBarButtonItems = @[saveBarbutton,recoverBarbutton];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
}


/**
 * 添加文本框
 */
-(void)setupTextView{
    //设置textView的高度
    CGFloat textViewH = 230;
    if ([UIScreen mainScreen].bounds.size.height == 736) {
        textViewH = 420;
    }else if ([UIScreen mainScreen].bounds.size.height == 667){
        textViewH = 380;
        
    }else if ([UIScreen mainScreen].bounds.size.height == 568){
        textViewH = 280;
    }else if ([UIScreen mainScreen].bounds.size.height == 480){
        textViewH = 200;
    }
    
    
    SDTextView* textView = [[SDTextView alloc] init];
//    CGFloat screenH =[UIScreen mainScreen].bounds.size.height;
    CGFloat screenW =[UIScreen mainScreen].bounds.size.width;
    textView.placeholder=@"记录生活的点点滴滴: )";
    
    //设置了该属性才能使用scrollView的代理
    textView.alwaysBounceVertical = YES;

    textView.frame = CGRectMake(0, 64, screenW, textViewH);
    textView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    self.textView = textView;
    textView.delegate = self;
    [self.view addSubview:textView];
    

    // 监听键盘改变的通知
    [SDNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:textView];
    
}


#pragma mark - 自动保存方法
-(void)autoSaveCurrentContent{
    //获得自动保存时间和内容，将其存入
    NSString* time = [NSString stringBydateFormatter:@"MM月dd日 HH:mm"];
    NSString* content = self.textView.text;
    [[NSUserDefaults standardUserDefaults] setObject:content forKey:@"saveCurrentContent"];
    [[NSUserDefaults standardUserDefaults] setObject:time forKey:@"saveCurrentTime"];
    
    
    
}
/**
 *  恢复草稿箱内容
 */
-(void)recoverContent{
    NSString* title =@"是否恢复到上次自动保存状态";
    NSString* message = [[NSUserDefaults standardUserDefaults] objectForKey:@"saveCurrentTime"];
    NSString* cancelButtonTitle = @"取消";
    NSString* sureButtonTitie = @"确认";
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    //创建按钮响应事件
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction* sureAction = [UIAlertAction actionWithTitle:sureButtonTitie style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.textView.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"saveCurrentContent"];
    }];
    //响应添加到控制器当中
    [alert addAction:cancelAction];
    [alert addAction:sureAction];
    
    [self presentViewController:alert animated:YES completion:nil];
      
    
}
#pragma mark - 键盘的frame发生改变时调用实现方法
/**
 * 键盘的frame发生改变时调用（显示、隐藏等）
 */
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    // 如果正在切换键盘，就不要执行后面的代码
//    if (self.switchingKeybaord) return;
    
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        // 工具条的Y值 == 键盘的Y值 - 工具条的高度
        if (keyboardF.origin.y > self.view.height) { // 键盘的Y值已经远远超过了控制器view的高度
        
            self.toolbar.y = self.view.height - self.toolbar.height * 2;
        } else {

            self.toolbar.y = keyboardF.origin.y - self.toolbar.height;

            
        }
    }];
}
//文本框内容发送变动时，保存按钮状态改变
-(void)textDidChange{
    
    self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;
}


-(void)saveContent{
    SDDiaryContent * content = [[SDDiaryContent alloc] init];
    content.saveContent = self.textView.text;
    content.saveDay = [NSString stringBydateFormatter:@"yyyy年MM月dd日"];
    content.saveTime = [NSString stringBydateFormatter:@"HH:mm"];
    
    [SDDiaryContentTool savecontent:content];
    //跳转到显示今天日记列表
    SDTodayListController * today = [[SDTodayListController alloc] init];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    //跳转前将文本框内容清空
    self.textView.text = nil;
    [self.navigationController pushViewController:today animated:YES ];
    
    
}
//注销通知中心
- (void)dealloc
{
    [SDNotificationCenter removeObserver:self];
}
#pragma mark - UITextViewDelegate
//向下滑动时，收起键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.textView resignFirstResponder];
}

//点击改变字体大小
-(void)fontChange{
    
    static int i = 13;
    self.textView.font = [UIFont systemFontOfSize:i];
    i ++;
    if (i == 20) {
        i = 13;
    }
}


@end
