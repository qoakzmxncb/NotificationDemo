//
//  NotificationViewController.m
//  NotificationContent
//
//  Created by Chason on 16/10/25.
//  Copyright © 2016年 Chason. All rights reserved.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

@interface ImageCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *kikm;

@end

@implementation ImageCollectionCell

@end

@interface NotificationViewController () <UNNotificationContentExtension,UITextFieldDelegate>

@property IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIView *mediaVIew;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (strong, nonatomic) NSMutableArray *imageArray;
@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;

@end


/**
 自定义View无法实现滑动手势，所以实现ScrollView有些徒劳
 */
@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageArray = [[NSMutableArray alloc] init];
    // Do any required interface initialization here.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_imageArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imagecollectioncell" forIndexPath:indexPath];
    UNNotificationAttachment *attachment = self.imageArray[indexPath.item];
    
    NSData *imagedata = [NSData dataWithContentsOfURL:attachment.URL];
    UIImage *image = [UIImage imageWithData:imagedata];
    cell.kikm.image = image;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.imageCollectionView.frame.size.width, self.imageCollectionView.frame.size.width);
}

#pragma mark - UNNotificationContentExtension
- (void)didReceiveNotification:(UNNotification *)notification {
    UNNotificationContent *content = notification.request.content;
    NSDictionary *userinfo = content.userInfo;
    NSLog(@"NotificationViewController -- %@",userinfo);
    
    NSArray *attachments = content.attachments;
    
    for (UNNotificationAttachment *attachment in attachments) {
        if (![attachment.type isEqualToString:@"public.png"]) {
            continue;
        }
        [self.imageArray addObject:attachment];
    }
    
    [self.imageCollectionView reloadData];
    
    self.label.text = content.title;
    
//    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:self.imageCollectionView.frame];
//    scrollview.backgroundColor = [UIColor yellowColor];
//    [self.view addSubview:scrollview];
//    
//    scrollview.contentSize = CGSizeMake(1000, 300);
//    
//    UIView *square = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
//    square.backgroundColor = [UIColor redColor];
//    [scrollview addSubview:square];
    
    [self.inputTextField becomeFirstResponder];
}

- (IBAction)inputTextFieldDidEndOnExit:(UITextField *)sender {
    NSString *inputtext = sender.text;
    NSLog(@"输入了3:%@",inputtext);
}

//- (UNNotificationContentExtensionMediaPlayPauseButtonType)mediaPlayPauseButtonType{
//    return UNNotificationContentExtensionMediaPlayPauseButtonTypeOverlay;
//}
//
//- (CGRect)mediaPlayPauseButtonFrame{
//    return CGRectMake(100, 100, 100, 100);
//}
//
//- (UIColor *)mediaPlayPauseButtonTintColor{
//    return [UIColor redColor];
//}
//
//- (void)mediaPlay{
//    NSLog(@"mediaPlay,开始播放");
//    // 点击播放按钮后，4s后暂停播放
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.extensionContext mediaPlayingPaused];
//    });
//    
//}
//- (void)mediaPause{
//    NSLog(@"mediaPause，暂停播放");
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.extensionContext mediaPlayingStarted];
//    });
//}
@end
