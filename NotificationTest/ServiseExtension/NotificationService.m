//
//  NotificationService.m
//  ServiseExtension
//
//  Created by Chason on 16/10/24.
//  Copyright © 2016年 Chason. All rights reserved.
//

#import "NotificationService.h"

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    // 重写一些东西
    self.bestAttemptContent.title = @"我是标题";
    self.bestAttemptContent.subtitle = @"我是子标题";
    self.bestAttemptContent.body = @"一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十";
    
    /*- categoryIdentifier应与服务器协定，与NotificationContent info.plise上面的category对应，所以最好在推送的userInfo中带有categoryIdentifier -*/
    // 这里定了categoryIdentifier，将会使用自定义的NotificationView
//    self.bestAttemptContent.categoryIdentifier = @"category1";
    
    // 附件
    // 简单来说就是远程推送无法直接带attachment，所以通过userinfo带上附件的参数，然后在这通过NSURLSession自己下载附件，然后组装成attachment再显示。
    NSDictionary *dict =  self.bestAttemptContent.userInfo;
    NSString *imgUrl = [NSString stringWithFormat:@"%@",dict[@"imageAbsoluteString"]];
    
    if (!imgUrl.length) {
        self.contentHandler(self.bestAttemptContent);
    }
    
    [self loadAttachmentForUrlString:imgUrl withType:@"image" completionHandle:^(UNNotificationAttachment *attach) {
        
        if (attach) {
            self.bestAttemptContent.attachments = [NSArray arrayWithObject:attach];
        }
        self.contentHandler(self.bestAttemptContent);
        
    }];
}

- (void)loadAttachmentForUrlString:(NSString *)urlStr
                          withType:(NSString *)type
                  completionHandle:(void(^)(UNNotificationAttachment *attach))completionHandler{
    __block UNNotificationAttachment *attachment = nil;
    NSURL *attachmentURL = [NSURL URLWithString:urlStr];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:attachmentURL
                                                completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                    if (error != nil) {
                                                        NSLog(@"%@", error.localizedDescription);
                                                    }
                                                    else {
                                                        NSString *fullpath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
                                                                              stringByAppendingPathComponent:response.suggestedFilename];
                                                        NSURL *localURL = [NSURL fileURLWithPath:fullpath];
                                                        
                                                        [[NSFileManager defaultManager] moveItemAtURL:location toURL:localURL error:nil];
                                                        
                                                        NSError *attachmentError = nil;
                                                        attachment = [UNNotificationAttachment attachmentWithIdentifier:@"" URL:localURL options:nil error:&attachmentError];
                                                        if (attachmentError) {
                                                            NSLog(@"%@", attachmentError.localizedDescription);
                                                        }
                                                    }
                                                    completionHandler(attachment);
                                                }];
    [task resume];
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
