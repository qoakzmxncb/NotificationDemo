//
//  NotificationService.h
//  ServiseExtension
//
//  Created by Chason on 16/10/24.
//  Copyright © 2016年 Chason. All rights reserved.
//

#import <UserNotifications/UserNotifications.h>


/**
 在收到通知后的最多30s内，你可以把你的通知内容，解密后，在重新展示在用户的通知拦上
 */
@interface NotificationService : UNNotificationServiceExtension

@end
