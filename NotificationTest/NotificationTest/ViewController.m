//
//  ViewController.m
//  NotificationTest
//
//  Created by Chason on 16/10/21.
//  Copyright © 2016年 Chason. All rights reserved.
//

#import "ViewController.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import "JPUSHService.h"

@interface ViewController (){
    NSInteger identifierCount;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    identifierCount = 0;
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnDidClick:(UIButton *)sender {
    [self createALocalNotification];
}

- (IBAction)iOS8BtnClick:(UIButton *)sender {
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
        
        notification.alertTitle = @"alertTitle";  //NS_AVAILABLE_IOS(8_2);
        
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

- (void)createALocalNotification{
    // 1.创建通知内容
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    
    //title,subtitle,body都可以通过[NSString localizedUserNotificationStringForKey:arguments:]本地化
    content.title = @"一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十";
    content.subtitle = @"一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十";
    content.body = @"一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十";
    content.badge = @1;
    content.userInfo = @{@"key":@"可以在userInfo里面携带自己的数据",
                         @"key2":@"还没发现数据能带多长",
                         @"key3":@"在预览界面body都能显示完全",
                         @"categoryKey":@"category1"};
//    content.categoryIdentifier = @"my_category2";
    NSError *error = nil;
    // 2.设置通知附件内容
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"jpg"];
//    UNNotificationAttachment *imgatt = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path] options:nil error:&error];

    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"gif"];
    UNNotificationAttachment *imgatt2 = [UNNotificationAttachment attachmentWithIdentifier:@"att11" URL:[NSURL fileURLWithPath:path2] options:nil error:&error];
//    NSString *th2 = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"m4a"];
//    UNNotificationAttachment *audioAtt = [UNNotificationAttachment attachmentWithIdentifier:@"att2" URL:[NSURL fileURLWithPath:path2] options:nil error:&error];
//    NSString *path3 = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"mov"];
//    UNNotificationAttachment *videoAtt = [UNNotificationAttachment attachmentWithIdentifier:@"att3" URL:[NSURL fileURLWithPath:path3] options:nil error:&error];
    content.attachments = @[imgatt2];
//    content.launchImageName = @"4.png";
    // 2.设置声音
    UNNotificationSound *sound = [UNNotificationSound defaultSound];
    content.sound = sound;
    
    // 3.设定触发器和触发模式
    /*
     UNPushNotificationTrigger          远程推送
     UNTimeIntervalNotificationTrigger  本地推送时间触发器
     UNCalendarNotificationTrigger      每月每天的触发器
     UNLocationNotificationTrigger      地点触发器
     */
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
    
    // 4.设置UNNotificationRequest
    // 设置通知的identifier，如果identifier不变，则可以起到更新通知的效果
    identifierCount++;
    NSString *requestIdentifer = [NSString stringWithFormat:@"%ld",(long)identifierCount];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:trigger];
    
    /*
     UNNotificationActionOptionNone
     UNNotificationActionOptionAuthenticationRequired = (1 << 0),
     UNNotificationActionOptionDestructive = (1 << 1), 取消
     UNNotificationActionOptionForeground = (1 << 2), 启动程序
     */
    
//    UNTextInputNotificationAction *textAction = [UNTextInputNotificationAction actionWithIdentifier:@"my_text" title:@"text_action" options:UNNotificationActionOptionAuthenticationRequired textInputButtonTitle:@"输入" textInputPlaceholder:@"默认文字"];
//    UNNotificationAction *action = [UNNotificationAction actionWithIdentifier:@"my_action" title:@"action" options:UNNotificationActionOptionDestructive];
//    UNNotificationAction *action_1 = [UNNotificationAction actionWithIdentifier:@"my_action_1" title:@"action_1" options:UNNotificationActionOptionAuthenticationRequired];
//    
//    UNNotificationAction *clearAction = [UNNotificationAction actionWithIdentifier:@"look" title:@"查看" options:UNNotificationActionOptionForeground];
//    
    /*
     UNNotificationCategoryOptionNone = (0),
     UNNotificationCategoryOptionCustomDismissAction = (1 << 0),
     UNNotificationCategoryOptionAllowInCarPlay = (2 << 0),
     */
//    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"my_category" actions:@[clearAction,textAction,action,action_1] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
    
    UNNotificationAction *clearAction = [UNNotificationAction actionWithIdentifier:@"clear" title:@"clear" options:UNNotificationActionOptionNone];
    
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"my_category" actions:@[clearAction] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
    
    NSSet *setting = [NSSet setWithObjects:category, nil];
    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:setting];
    //5.把通知加到UNUserNotificationCenter, 到指定触发点会被触发
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    }];
}

- (IBAction)jpushLocalNotification:(UIButton *)sender {
    JPushNotificationContent *content = [[JPushNotificationContent alloc] init];
    content.title = @"标题";
    content.subtitle = @"副标题";
    content.body = @"推送内容";
    content.badge = @2;
    content.categoryIdentifier = @"my_category";
    content.userInfo = @{@"key":@"可以在userInfo里面携带自己的数据",
                         @"key2":@"还没发现数据能带多长",
                         @"key3":@"在预览界面body都能显示完全",
                         @"categoryKey":@"category1"};
    NSError *error = nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"jpg"];
    UNNotificationAttachment *imgatt = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
    content.attachments = @[imgatt];
    
    JPushNotificationTrigger *trigger = [[JPushNotificationTrigger alloc] init];
    trigger.repeat = NO;
    trigger.timeInterval = 1;
    
    JPushNotificationRequest *request = [[JPushNotificationRequest alloc] init];
    request.requestIdentifier = [NSString stringWithFormat:@"%ld",(long)identifierCount];
    request.content = content;
    request.trigger = trigger;
    
    [JPUSHService addNotification:request];
}


@end
