//
//  AppDelegate+Notification.m
//  NotificationTest
//
//  Created by Chason on 16/10/28.
//  Copyright © 2016年 Chason. All rights reserved.
//

#import "AppDelegate+Notification.h"

#import "JPUSHService.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

NSString *const appKey = @"your jpush appkey";

@interface AppDelegate ()<UNUserNotificationCenterDelegate,JPUSHRegisterDelegate>

@end


@implementation AppDelegate (Notification)

- (void)initJPushWithApplication:(UIApplication *)application andLaunchOption:(NSDictionary *)launchoption{
//    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]; //IDFA

    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        
        UNTextInputNotificationAction *textAction = [UNTextInputNotificationAction actionWithIdentifier:@"my_text" title:@"text_action" options:UNNotificationActionOptionAuthenticationRequired textInputButtonTitle:@"输入" textInputPlaceholder:@"默认文字"];
        UNNotificationAction *action = [UNNotificationAction actionWithIdentifier:@"my_action" title:@"action" options:UNNotificationActionOptionDestructive];
        UNNotificationAction *action_1 = [UNNotificationAction actionWithIdentifier:@"my_action_1" title:@"action_1" options:UNNotificationActionOptionAuthenticationRequired];
    
        UNNotificationAction *clearAction = [UNNotificationAction actionWithIdentifier:@"look" title:@"查看" options:UNNotificationActionOptionForeground];
        UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"my_category" actions:@[clearAction,textAction,action,action_1] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
        entity.categories = [NSSet setWithObject:category];
        
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    //Required
    // init Push(2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil  )
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchoption appKey:appKey
                          channel:nil
                 apsForProduction:NO
            advertisingIdentifier:nil];
}

- (void)initNotificationWithApplication:(UIApplication *)application andLaunchOption:(NSDictionary *)launchoption{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge|UNAuthorizationOptionSound|UNAuthorizationOptionAlert)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  if (granted) {
                                      //点击允许
                                      NSLog(@"注册成功");
                                      [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                                          NSLog(@"%@",settings);
                                      }];
                                  }
                                  else{
                                      NSLog(@"注册失败");
                                  }
                              }];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] > 8.0){
        //1.创建消息上面要添加的动作(按钮的形式显示出来)
        UIMutableUserNotificationAction *action = [[UIMutableUserNotificationAction alloc] init];
        action.identifier = @"action";//按钮的标示
        action.title=@"按钮1";//按钮的标题
        /*
         UIUserNotificationActivationModeForeground, // activates the application in the foreground
         UIUserNotificationActivationModeBackground  // activates the application in the background, unless it's already in the foreground
         */
        action.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
//        action.authenticationRequired = YES;
//        action.destructive = YES;
        /*
         UIUserNotificationActionBehaviorDefault,        // the default action behavior
         UIUserNotificationActionBehaviorTextInput       // system provided action behavior, allows text input from the user
         */
        action.behavior = UIUserNotificationActionBehaviorTextInput;

//        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];
//        action2.identifier = @"action2";
//        action2.title=@"按钮2";
//        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
//        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
//        action2.destructive = YES;
//
//        UIMutableUserNotificationAction *action3 = [[UIMutableUserNotificationAction alloc] init];
//        action3.identifier = @"action3";
//        action3.title=@"按钮3";
//        action3.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
//        action3.authenticationRequired = NO;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
//        action3.destructive = NO;

        //2.创建动作(按钮)的类别集合
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"alert";//这组动作的唯一标示,推送通知的时候也是根据这个来区分
        /*
         UIUserNotificationActionContextDefault,  // the default context of a notification action
         UIUserNotificationActionContextMinimal   // the context of a notification action when space is limited
         */
        [categorys setActions:@[action] forContext:(UIUserNotificationActionContextMinimal)];

        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:[NSSet setWithObjects:categorys, nil]];
        [application registerUserNotificationSettings:setting];
    }
    
    //注册获取device token 这个没变化
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

#pragma mark - deviceToken delegate 没变化
// 获得Device Token
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    
    [JPUSHService registerDeviceToken:deviceToken];
}
// 获得Device Token失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


#pragma mark - JPUSHRegisterDelegate

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

#pragma clang diagnostic pop


#pragma mark - UNUserNotificationCenterDelegate
// iOS 10收到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    NSLog(@"The date displayed on the notification:%@",notification.date);
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"iOS10 前台收到远程通知:%@", userInfo);
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

// 通知的点击事件
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    //    NSNumber *badge = content.badge;  // 推送消息的角标
    //    NSString *body = content.body;    // 推送消息体
    //    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    //    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    //    NSString *title = content.title;  // 推送消息的标题
    
    NSString *action = response.actionIdentifier;
    NSLog(@"点击通知:\nactionIdentifier:%@ \tnotification identifier:%@",action,request.identifier);
    
    if ([response isKindOfClass:[UNTextInputNotificationResponse class]]) {
        UNTextInputNotificationResponse *textinputResponse = (UNTextInputNotificationResponse *)response;
        NSLog(@"输入动作:%@",textinputResponse.userText);
    }
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"iOS10 收到远程通知:%@", userInfo);
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:%@",content);
    }
    
    // Warning: UNUserNotificationCenter delegate received call to -userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler: but the completion handler was never called.
    completionHandler();  // 系统要求执行这个方法
}

#pragma mark - 旧版本推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"iOS7及以上系统，收到远程通知:%@", userInfo);
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    NSLog(@"iOS7及以上系统，收到本地通知:%@", notification);
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler{
    NSLog(@"iOS8系统，点击本地通知:%@\tUILocalNotification:%@", identifier,notification);
    completionHandler();
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler{
    NSLog(@"iOS8系统，点击远程通知:%@\tuserInfo:%@", identifier,userInfo);
    completionHandler();
}


@end
