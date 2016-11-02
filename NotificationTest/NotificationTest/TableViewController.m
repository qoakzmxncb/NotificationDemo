//
//  TableViewController.m
//  NotificationTest
//
//  Created by Chason on 16/10/25.
//  Copyright © 2016年 Chason. All rights reserved.
//

#import "TableViewController.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import "JPUSHService.h"

@interface TableViewController (){
    NSInteger identifierCount;
}

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    identifierCount = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            
            break;
        }
        case 1:{
            
            break;
        }
        case 2:{
            
            break;
        }
        case 3:{
            
            break;
        }
        case 4:{
            
            break;
        }
        case 5:{
            
            break;
        }
        case 6:{
            
            break;
        }
        case 7:{
            
            break;
        }
        case 8:{
            
            break;
        }
        case 9:{
            
            break;
        }
        case 10:{
            
            break;
        }
        case 11:{
            
            break;
        }
        case 12:{
            
            break;
        }
            
        default:
            break;
    }
}

- (void)unnotificationTrigger1{
    UNMutableNotificationContent *content = [self defaultUNNotificationContent];
    // 设定触发器和触发模式
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
    
    // 设置UNNotificationRequest
    // 设置通知的identifier，如果identifier不变，则可以起到更新通知的效果
    identifierCount++;
    NSString *requestIdentifer = [NSString stringWithFormat:@"%ld",(long)identifierCount];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:trigger];
    //把通知加到UNUserNotificationCenter, 到指定触发点会被触发
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    }];
}

- (void)unnotificationTrigger4{
    UNMutableNotificationContent *content = [self defaultUNNotificationContent];
    // 设定触发器和触发模式
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:4 repeats:NO];
    
    // 设置UNNotificationRequest
    // 设置通知的identifier，如果identifier不变，则可以起到更新通知的效果
    identifierCount++;
    NSString *requestIdentifer = [NSString stringWithFormat:@"%ld",(long)identifierCount];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:trigger];
    //把通知加到UNUserNotificationCenter, 到指定触发点会被触发
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    }];
}

- (void)unnotificationUpdateContent{
    NSArray *titlearray = @[@"随即标题",@"随即标题2",@"随即标题3",@"随即标题4"];
    NSArray *subtitlearray = @[@"随即副标题",@"随即副标题2",@"随即副标题3",@"随即副标题4"];
    NSArray *bodyarray = @[@"随即内容",@"随即内容2",@"随即内容3",@"随即内容4"];
    
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    
    //测试后得出，title和subtitle最多显示18个中文字符，body最多显示36个中文字符，在下拉菜单72个中文字符
    //title,subtitle,body都可以通过[NSString localizedUserNotificationStringForKey:arguments:]本地化
    NSInteger i = arc4random() % 4;
    content.title = titlearray[i];
    content.subtitle = subtitlearray[i];
    content.body = bodyarray[i];
    content.badge = @1;
    
    // 设定触发器和触发模式
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
    
    // 设置UNNotificationRequest
    // 设置通知的identifier，如果identifier不变，则可以起到更新通知的效果
    NSString *requestIdentifer = @"identifier";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:trigger];
    //把通知加到UNUserNotificationCenter, 到指定触发点会被触发
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    }];
}

- (void)unnotificationWithImage{
    UNMutableNotificationContent *content = [self defaultUNNotificationContent];
    // 设置通知附件内容
    NSError *error = nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"jpg"];
    UNNotificationAttachment *imgatt = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
    
    content.attachments = @[imgatt];
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
    identifierCount++;
    NSString *requestIdentifer = [NSString stringWithFormat:@"%ld",(long)identifierCount];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:trigger];
    //把通知加到UNUserNotificationCenter, 到指定触发点会被触发
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    }];
}

- (void)unnotificationWithAudio{
    UNMutableNotificationContent *content = [self defaultUNNotificationContent];
    // 设置通知附件内容
    NSError *error = nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"伤心太平洋" ofType:@"mp3"];
    UNNotificationAttachment *imgatt = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
    
    content.attachments = @[imgatt];
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
    identifierCount++;
    NSString *requestIdentifer = [NSString stringWithFormat:@"%ld",(long)identifierCount];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:trigger];
    //把通知加到UNUserNotificationCenter, 到指定触发点会被触发
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    }];
}

- (void)unnotificationWithVideo{
    UNMutableNotificationContent *content = [self defaultUNNotificationContent];
    // 设置通知附件内容
    NSError *error = nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"mov"];
    UNNotificationAttachment *imgatt = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
    
    content.attachments = @[imgatt];
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
    identifierCount++;
    NSString *requestIdentifer = [NSString stringWithFormat:@"%ld",(long)identifierCount];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:trigger];
    //把通知加到UNUserNotificationCenter, 到指定触发点会被触发
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    }];
}

- (void)unnotificationWithAction{
    UNMutableNotificationContent *content = [self defaultUNNotificationContent];
    
    content.categoryIdentifier = @"my_category"; //要跟UNNotificationCategory的identifier对应
    // 设定触发器和触发模式
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
    identifierCount++;
    NSString *requestIdentifer = [NSString stringWithFormat:@"%ld",(long)identifierCount];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:trigger];
    
    /*
     UNNotificationActionOptionNone
     UNNotificationActionOptionAuthenticationRequired = (1 << 0),
     UNNotificationActionOptionDestructive = (1 << 1), 取消
     UNNotificationActionOptionForeground = (1 << 2), 启动程序
     */
    
    UNTextInputNotificationAction *textAction = [UNTextInputNotificationAction actionWithIdentifier:@"my_text" title:@"text_action" options:UNNotificationActionOptionAuthenticationRequired textInputButtonTitle:@"输入" textInputPlaceholder:@"默认文字"];
    UNNotificationAction *action = [UNNotificationAction actionWithIdentifier:@"my_action" title:@"action" options:UNNotificationActionOptionDestructive];
    UNNotificationAction *action_1 = [UNNotificationAction actionWithIdentifier:@"my_action_1" title:@"action_1" options:UNNotificationActionOptionAuthenticationRequired];

    UNNotificationAction *clearAction = [UNNotificationAction actionWithIdentifier:@"look" title:@"查看" options:UNNotificationActionOptionForeground];

    /*
     UNNotificationCategoryOptionNone = (0),
     UNNotificationCategoryOptionCustomDismissAction = (1 << 0),
     UNNotificationCategoryOptionAllowInCarPlay = (2 << 0),
     */
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"my_category" actions:@[clearAction,textAction,action,action_1] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];

    
    NSSet *setting = [NSSet setWithObjects:category, nil];
    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:setting];
    
    
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    }];
}

- (void)iOS8LocalNotification{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    //设置5秒之后
    NSDate *pushDate = [NSDate dateWithTimeIntervalSinceNow:4];
    if (notification != nil) {
        // 设置推送时间（5秒后）
        notification.fireDate = pushDate;
        // 设置时区（此为默认时区）
        notification.timeZone = [NSTimeZone defaultTimeZone];
        // 设置重复间隔（默认0，不重复推送）
        notification.repeatInterval = 0;
        // 推送声音（系统默认）
        notification.soundName = UILocalNotificationDefaultSoundName;
        // 推送内容
        notification.alertBody = @"推送主体内容";
        
        notification.alertAction = @"alertAction";
        
        notification.alertLaunchImage = @"1.png";
        
//        notification.alertTitle = @"alertTitle";  //NS_AVAILABLE_IOS(8_2);
        
        notification.category = @"alert";
        //显示在icon上的数字
        notification.applicationIconBadgeNumber = 1;
        //设置userinfo 方便在之后需要撤销的时候使用
        NSDictionary *info = [NSDictionary dictionaryWithObject:@"name"forKey:@"key"];
        notification.userInfo = info;
        //添加推送到UIApplication
        UIApplication *app = [UIApplication sharedApplication];
        [app scheduleLocalNotification:notification];
    }
}

- (UNMutableNotificationContent *)defaultUNNotificationContent
{
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    
    //测试后得出，title和subtitle最多显示18个中文字符，body最多显示36个中文字符，在下拉菜单72个中文字符
    //title,subtitle,body都可以通过[NSString localizedUserNotificationStringForKey:arguments:]本地化
    content.title = @"标题";
    content.subtitle = @"副标题";
    content.body = @"消息主题内容";
    content.badge = @1;
    content.userInfo = @{@"key":@"可以在userInfo里面携带自己的数据",
                         @"key2":@"还没发现数据限制多长",
                         @"key3":@"在预览界面body都能显示完全",
                         @"category":@"远程推送可以把category带在这里"};
    return content;
}


@end
