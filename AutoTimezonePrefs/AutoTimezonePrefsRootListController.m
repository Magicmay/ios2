#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>

@interface AutoTimezonePrefsRootListController : PSListController
@end

@implementation AutoTimezonePrefsRootListController

- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
    }
    return _specifiers;
}

- (void)updateNow {
    // 发送通知立即更新时区
    CFNotificationCenterPostNotification(
        CFNotificationCenterGetDarwinNotifyCenter(),
        CFSTR("com.yourdomain.autotimezone/UpdateNow"),
        NULL,
        NULL,
        true
    );

    // 显示提示
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"更新时区"
                                                                   message:@"正在根据IP地址更新时区，请稍候..."
                                                            preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDefault
                                            handler:nil]];

    [self presentViewController:alert animated:YES completion:nil];

    // 3秒后自动关闭提示
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
}

@end
