// AutoTimezone - 自动根据IP地址修改时区
// 支持 iPhone 16.1.1 RootHide 越狱环境

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <notify.h>

// 私有框架接口
extern void SetTimeZoneWithName(CFStringRef);
extern CFStringRef CopyTimeZoneName(void);

// 插件配置（简化版本，始终启用）
static NSString *currentTimezone = nil;
static NSTimer *updateTimer = nil;

// 从IP地址获取地理位置和时区信息
static void fetchTimezoneFromIP(void(^completion)(NSString *timezone)) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 使用 ip-api.com 获取IP信息（免费API）
        NSURL *url = [NSURL URLWithString:@"http://ip-api.com/json/?fields=timezone"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url
                                                 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                             timeoutInterval:10.0];

        // 使用现代API替代已废弃的NSURLConnection
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config];

        NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (data && !error) {
                NSError *jsonError = nil;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:0
                                                                      error:&jsonError];
                NSString *timezone = json[@"timezone"];

                if (timezone && [timezone length] > 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(timezone);
                    });
                    return;
                }
            }

            // API调用失败，尝试备用API
            NSLog(@"[AutoTimezone] Primary API failed, trying fallback...");
            NSURL *fallbackUrl = [NSURL URLWithString:@"https://ipapi.co/json/"];
            NSURLRequest *fallbackRequest = [NSURLRequest requestWithURL:fallbackUrl
                                                             cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                         timeoutInterval:10.0];

            NSURLSessionDataTask *fallbackTask = [session dataTaskWithRequest:fallbackRequest
                                                            completionHandler:^(NSData *fallbackData, NSURLResponse *fallbackResponse, NSError *fallbackError) {
                if (fallbackData && !fallbackError) {
                    NSError *jsonError = nil;
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:fallbackData
                                                                        options:0
                                                                          error:&jsonError];
                    NSString *timezone = json[@"timezone"];

                    if (timezone && [timezone length] > 0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(timezone);
                        });
                        return;
                    }
                }

                // 所有API调用失败，返回nil
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil);
                });
            }];

            [fallbackTask resume];
        }];

        [task resume];
    });
}

// 设置系统时区
static void setSystemTimezone(NSString *timezone) {
    if (!timezone || [timezone length] == 0) {
        NSLog(@"[AutoTimezone] Invalid timezone: %@", timezone);
        return;
    }

    // 验证时区是否有效
    NSTimeZone *tz = [NSTimeZone timeZoneWithName:timezone];
    if (!tz) {
        NSLog(@"[AutoTimezone] Unknown timezone: %@", timezone);
        return;
    }

    // 如果时区相同，不需要更新
    if ([timezone isEqualToString:currentTimezone]) {
        NSLog(@"[AutoTimezone] Timezone unchanged: %@", timezone);
        return;
    }

    NSLog(@"[AutoTimezone] Updating timezone from %@ to %@", currentTimezone, timezone);
    currentTimezone = timezone;

    // 方法1: 使用私有API设置系统时区（最可靠）
    @try {
        SetTimeZoneWithName((__bridge CFStringRef)timezone);
        NSLog(@"[AutoTimezone] Set timezone using private API");
    } @catch (NSException *exception) {
        NSLog(@"[AutoTimezone] Private API failed: %@", exception);
    }

    // 方法2: 设置系统默认时区
    [NSTimeZone setDefaultTimeZone:tz];

    // 方法3: 更新多个配置位置
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:timezone forKey:@"com.apple.TimeZone"];
    [defaults synchronize];

    // 更新全局域
    CFPreferencesSetValue(CFSTR("timezone"),
                          (__bridge CFStringRef)timezone,
                          CFSTR("com.apple.preferences.datetime"),
                          kCFPreferencesAnyUser,
                          kCFPreferencesCurrentHost);
    CFPreferencesSynchronize(CFSTR("com.apple.preferences.datetime"),
                            kCFPreferencesAnyUser,
                            kCFPreferencesCurrentHost);

    // 方法4: 更新时区符号链接（传统方法）
    NSString *zoneinfoPath = [NSString stringWithFormat:@"/usr/share/zoneinfo/%@", timezone];
    NSString *localtimePath = @"/var/db/timezone/localtime";
    NSFileManager *fileManager = [NSFileManager defaultManager];

    if ([fileManager fileExistsAtPath:zoneinfoPath]) {
        // 删除旧的符号链接
        [fileManager removeItemAtPath:localtimePath error:nil];

        // 创建新的符号链接
        NSError *linkError = nil;
        [fileManager createSymbolicLinkAtPath:localtimePath
                          withDestinationPath:zoneinfoPath
                                        error:&linkError];
        if (linkError) {
            NSLog(@"[AutoTimezone] Failed to create symlink: %@", linkError);
        } else {
            NSLog(@"[AutoTimezone] Created symlink: %@ -> %@", localtimePath, zoneinfoPath);
        }
    }

    // 发送系统通知
    [[NSNotificationCenter defaultCenter] postNotificationName:NSSystemTimeZoneDidChangeNotification
                                                        object:nil];

    // 发送Darwin通知给其他进程
    notify_post("SignificantTimeChangeNotification");
    notify_post("NSSystemTimeZoneDidChangeNotification");

    NSLog(@"[AutoTimezone] Timezone updated successfully to: %@", timezone);
}

// 更新时区
static void updateTimezone() {
    NSLog(@"[AutoTimezone] Fetching timezone from IP...");

    fetchTimezoneFromIP(^(NSString *timezone) {
        if (timezone) {
            setSystemTimezone(timezone);
        } else {
            NSLog(@"[AutoTimezone] Failed to fetch timezone from IP");
        }
    });
}

// 启动定时器
static void startUpdateTimer() {
    if (updateTimer) {
        [updateTimer invalidate];
        updateTimer = nil;
    }

    // 每30分钟检查一次时区
    updateTimer = [NSTimer scheduledTimerWithTimeInterval:1800.0 // 30分钟
                                                   repeats:YES
                                                     block:^(NSTimer *timer) {
        updateTimezone();
    }];

    NSLog(@"[AutoTimezone] Update timer started (30 min interval)");
}

// Hook SpringBoard启动
%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)application {
    %orig;

    NSLog(@"[AutoTimezone] Plugin loaded - Simple version");

    // 延迟5秒后第一次更新（等待网络初始化）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        updateTimezone();
        startUpdateTimer();
    });
}

%end

// Hook 网络状态变化
%hook SBWiFiManager

- (void)_updateWiFiState {
    %orig;

    // 当WiFi状态改变时，等待3秒后更新时区
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        updateTimezone();
    });
}

%end

// 插件构造函数
%ctor {
    @autoreleasepool {
        NSLog(@"[AutoTimezone] Constructor called - Simple version (always enabled)");
    }
}
