//
//  SDSettingController.m
//  SimpleDiary
//
//  Created by vshiron on 15/12/23.
//  Copyright © 2015年 Apress. All rights reserved.
//

#import "SDSettingController.h"
#import "SDSettingCell.h"
#import "SDSettingItem.h"
#import "SDSettingArrowItem.h"
#import "SDSettingSwitchItem.h"
#import "SDSettingGroup.h"
#import "SDSuggestController.h"
#import "SDLockController.h"
#import "SDIntroduceController.h"
#import "SDGradeController.h"
#import "SDAboutController.h"
#import "SDSwitchView.h"
#import "CLLockVC.h"
#import "MBProgressHUD+MJ.h"
#import <MessageUI/MessageUI.h>
#import <StoreKit/StoreKit.h>
#import "sys/utsname.h"
@interface SDSettingController ()<MFMailComposeViewControllerDelegate,SKStoreProductViewControllerDelegate>
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic , weak ) SDSwitchView *switchView;
@property (nonatomic , weak ) SDSettingCell *cell;
@property (weak, nonatomic)  UIActivityIndicatorView *indicator;
@end

@implementation SDSettingController


-(void)viewDidLoad{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lockChange) name:@"SDDidLockChangeNSNotification" object:nil];
    
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (id)init
{
//    self.tableView.scrollEnabled = NO;
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (NSMutableArray *)dataList
{
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
        
        // 0组
        SDSettingItem *introduce = [SDSettingArrowItem itemWithIcon:@"Tag" title:@"功能介绍" destVcClass:[SDIntroduceController class]];
     
        SDSettingItem *lock = [SDSettingSwitchItem itemWithIcon:@"Lock" title:@"手势解锁"];
        
        
        
        SDSettingGroup *group0 = [[SDSettingGroup alloc] init];
        group0.items = @[introduce,lock];
        group0.header = @"更多服务";
        
        // 1组
        SDSettingItem * suggest= [SDSettingArrowItem itemWithIcon:@"Open-Mail" title:@"意见反馈" destVcClass:[SDSuggestController class]];
//                                  itemWithIcon:@"Closed-Mail" title:@"意见反馈"];
        SDSettingItem *grade = [SDSettingArrowItem itemWithIcon:@"Clipboard" title:@"给我评分" destVcClass:[SDGradeController class]];
//                                itemWithIcon:@"Clipboard" title:@"给我评分"];
        SDSettingItem *about = [SDSettingArrowItem itemWithIcon:@"Scanner" title:@"关于" destVcClass:[SDAboutController class]];
        
//
        
        
        SDSettingGroup *group1 = [[SDSettingGroup alloc] init];
        group1.header = @"帮助";
        group1.items = @[suggest,grade,about];
        
        [_dataList addObject:group0];
        [_dataList addObject:group1];
        
    }
    
    return _dataList;
}

#pragma mark - Table view data source
//显示每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SDSettingGroup *  group = self.dataList[section];
    return group.items.count;
}

//tableview 中又多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.dataList.count;
}

//返回一个cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDSettingCell* cell = [SDSettingCell cellWithTableView:tableView];
    
    SDSettingGroup * group = self.dataList[indexPath.section];
    
    SDSettingItem * item = group.items[indexPath.row];
    
    cell.item = item;
    cell.backgroundColor = [UIColor whiteColor];
    
//    cell.switchView = self.switchView;
    return cell;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    SDSettingGroup* group = self.dataList[section];
    return group.header;
    
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    SDSettingGroup* group = self.dataList[section];
    return group.footer;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // 取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 取出模型
    SDSettingGroup *group = self.dataList[indexPath.section];
    SDSettingItem *item = group.items[indexPath.row];
    
    // 执行操作
    if (item.option) {
        item.option();
        return;
    }
    
    
    if (indexPath.section == 1&& indexPath.row == 0) {
        //发送邮件
        if(![MFMailComposeViewController canSendMail]){
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法发送邮件！"
                                                                                     message:@"请检查邮件设置"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            
            [alertController addAction:OKAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
            
        }else{
            MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
            mailController.mailComposeDelegate = self;
            
            NSString *title = @"【联系开发者】";
            [mailController setSubject:title];
            
            //获取设备信息
            UIDevice *device = [[UIDevice alloc] init];
            NSString *type = device.localizedModel;
            NSString *systemVersion = device.systemVersion;
            
            
            //获取APP版本信息
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            CFShow((__bridge CFTypeRef)(infoDictionary));
            NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            
            
            
            
            
            [mailController setToRecipients:@[@"oo.shiron.oo@qq.com"]];
            
            NSMutableString *mailBady = [NSMutableString stringWithFormat:@"请留下你的宝贵意见:\n设备名称：%@\n设备型号：%@\n系统版本：%@\nAPP版本：%@",type,[self getCurrentDeviceModel],systemVersion,appVersion];
            [mailController setMessageBody:mailBady isHTML:NO];
            
            [self presentViewController:mailController animated:YES completion:nil];
        }
    }

    //给我评分界面
    if (indexPath.section == 1&& indexPath.row == 1) {
        [self showAppStoreInApp:@"1071484906"];
    }
    
    if ([item isKindOfClass:[SDSettingArrowItem class]]) { // 需要跳转控制器
        SDSettingArrowItem *arrowItem = (SDSettingArrowItem *)item;
        // 创建跳转的控制器
        if (arrowItem.destVcClass) {
            
            UIViewController *vc = [[arrowItem.destVcClass alloc] init];
            vc.title = item.title;
            if (indexPath.section == 1&& indexPath.row == 0) return;
            if (indexPath.section == 1&& indexPath.row == 1 )return;
            [self.navigationController pushViewController:vc animated:YES];
        }
 
    }
    
}

#pragma mark - lock按钮改变点击

-(void)lockChange{
    
    
    if ([CLLockVC hasPwd]) {
       NSString* title =@"是否开启密码保护";
        [self alertVCWithTitle:title];

    }else{
        NSString* title =@"是否开启密码保护";
        [self alertVCWithTitle:title];
    }
    

    
}

//弹出是否要选择开启或关闭手势密码的窗口
-(void)alertVCWithTitle:(NSString*)title{
    
    NSString* cancelButtonTitle = @"取消";
    NSString* sureButtonTitie = @"确认";
    NSString* message = nil;
    if ([CLLockVC hasPwd]) {
        message = @"温馨提示：点击确认后进入管理界面，输入正确密码后开启保护，管理界面右下方可以修改密码";
    }else{
        message = @"温馨提示：开启保护后，密码作为拥有者的开启软件唯一标识，请务必牢记密码";
    }
    
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    //创建按钮响应事件--取消
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self saveSwitch:NO animated:YES];

    }];
    
    //创建按钮响应事件--确认
    UIAlertAction* sureAction = [UIAlertAction actionWithTitle:sureButtonTitie style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveSwitch:YES animated:NO];

        [self lockAction];

    }];
    //响应添加到控制器当中
    [alert addAction:cancelAction];
    [alert addAction:sureAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)lockAction{

    BOOL hasPwd = [CLLockVC hasPwd];
//    hasPwd = NO;
    if(hasPwd){
        [CLLockVC showVerifyLockVCInVC:self forgetPwdBlock:^{
            
            [self saveSwitch:NO animated:YES];
            
        } successBlock:^(CLLockVC *lockVC, NSString *pwd) {
//            NSLog(@"密码正确");
            [lockVC dismiss:1.0f];
        }];

    }else{
        
        [CLLockVC showSettingLockVCInVC:self successBlock:^(CLLockVC *lockVC, NSString *pwd) {
            
            NSLog(@"密码设置成功");
            [lockVC dismiss:1.0f];
        }];
    }
}

-(void)saveSwitch:(BOOL)SwitchValue animated:(BOOL)animated{
    
    self.switchView =  [SDSwitchView sharedSwitchView];
    [self.switchView setOn:SwitchValue animated:animated];
    // 同步：把内存中的数据和沙盒同步
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.switchView.isOn forKey:@"SwtichValue"];
    [defaults synchronize];
    
}

-(void)clikc{

    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] boolForKey:@"SwtichValue"]?@"YES":@"NO");
    
}



//跳转appstore
- (void)showAppStoreInApp:(NSString *)_appId {
    Class isAllow = NSClassFromString(@"SKStoreProductViewController");
    if (isAllow != nil) {
        SKStoreProductViewController *sKStoreProductViewController = [[SKStoreProductViewController alloc] init];
        sKStoreProductViewController.delegate = self;
        self.indicator.hidden = NO;
        [self.indicator startAnimating];
        [sKStoreProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier: _appId}
                                                completionBlock:^(BOOL result, NSError *error) {
                                                    if (result) {
                                                        [self.indicator stopAnimating];
                                                        self.indicator.hidden = YES;
                                                        [self presentViewController:sKStoreProductViewController
                                                                           animated:YES
                                                                         completion:nil];
                                                        
                                                    }
                                                    else{
                                                        NSLog(@"%@",error);
                                                    }
                                                }];
    }
    else{
        //低于iOS6没有这个类
        NSString *string = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/id%@?mt=8",_appId];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
    }
}


//SKstore的代理
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    
    
    [viewController dismissViewControllerAnimated:YES
                                       completion:nil];
    
    
}


#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}


//获取设备具体型号
- (NSString *)getCurrentDeviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}




@end
