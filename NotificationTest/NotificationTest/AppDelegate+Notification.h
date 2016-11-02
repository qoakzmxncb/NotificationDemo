//
//  AppDelegate+Notification.h
//  NotificationTest
//
//  Created by Chason on 16/10/28.
//  Copyright © 2016年 Chason. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Notification)

- (void)initJPushWithApplication:(UIApplication *)application andLaunchOption:(NSDictionary *)launchoption;

- (void)initNotificationWithApplication:(UIApplication *)application andLaunchOption:(NSDictionary *)launchoption;

@end
