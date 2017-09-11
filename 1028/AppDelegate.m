//
//  AppDelegate.m
//  1028
//
//  Created by fg on 2017/4/17.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "AppDelegate.h"
#import "../Framework/ICSDrawerController/ICSDrawerController.h"
#import "../Framework/AFNetworkActivityLogger/AFNetworkActivityLogger.h"
#import <AVOSCloud/AVOSCloud.h>
#import <UserNotifications/UserNotifications.h>
#import <CoreLocation/CoreLocation.h>
#import "ICSColorsViewController.h"
#import "ShakeViewController.h"
#import "MCScannerViewController.h"
#import "ActivityDetailViewController.h"

//#import "RtlsEngine.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "UIDevice+NTNUExtensions.h"
#import "MenuViewController.h"

#define LEARNCLOUD_APP_ID @"yb6AFbFqre9XMNKbwDmnP1bR-gzGzoHsz"
#define LEARNCLOUD_APP_KEY @"o0mi3LScA0yFvWd4uQq1y4ww"
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)


@interface AppDelegate ()

//@property (nonatomic, strong) RtlsEngine *engine;
@property (strong, nonatomic) CLLocationManager *locationManager;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [UITabBarItem.appearance setTitleTextAttributes:
     @{NSForegroundColorAttributeName : [UIColor blackColor]}
                                           forState:UIControlStateNormal];
    [UITabBarItem.appearance setTitleTextAttributes:
     @{NSForegroundColorAttributeName : [UIColor whiteColor]}
                                           forState:UIControlStateSelected];
    
#ifdef DEBUG
    [[AFNetworkActivityLogger sharedLogger] startLogging];
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);

#endif
        
    UIDevice *device = [UIDevice currentDevice];
    NSLog(@"device = %lu",(unsigned long)[device ntnu_deviceType]);
    
    NTNUDeviceType type = [device ntnu_deviceType];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [AVOSCloud setApplicationId:LEARNCLOUD_APP_ID clientKey:LEARNCLOUD_APP_KEY];
    
    //追蹤app打開情況
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    //註冊推播
    [self registerForRemoteNotification];
    
    //確認定位
//    [self checkLocationPremission];
    
    
    //FB init
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    MenuViewController *menuVC = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];
    
    self.mainTabBarController = [[MainTabBarController alloc] initWithNibName:@"MainTabBarController" bundle:nil];

    self.drawer = [[ICSDrawerController alloc] initWithLeftViewController:menuVC  centerViewController:self.mainTabBarController];
    
    [self.window setRootViewController:self.drawer];

    [self.window makeKeyAndVisible];
    
    //推播處理
    
//    if([[[UIDevice currentDevice] systemVersion] floatValue] < 10.0){
//        NSDictionary *userInfo;
//        @try {
//            userInfo = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
//        } @catch (NSException *exception) {}
//     
//        if(userInfo != nil){
//            [self application:application didReceiveRemoteNotification:userInfo];
//        }
//    }
    

    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                    ];
    // Add any custom logic here.
    return handled;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //回來處理是否開啟location
    if (_mainTabBarController.selectedViewController != nil) {
        UINavigationController *currentNavi = _mainTabBarController.selectedViewController;
        
        if([[currentNavi visibleViewController] isKindOfClass:[ShakeViewController class]]){
            ShakeViewController *viewController = (ShakeViewController *)[currentNavi visibleViewController];
            [viewController checkLocationPremission];
            //            [viewController checkBlueToothPowerState];
        }
        else if([[currentNavi visibleViewController] isKindOfClass:[MCScannerViewController class]]){
            MCScannerViewController *viewController = (MCScannerViewController *)[currentNavi visibleViewController];
            [viewController dissmissScannerView];
        }
        else if([[currentNavi visibleViewController] isKindOfClass:[ActivityDetailViewController class]]){
            if (self.openOutSideWeb) {
                self.openOutSideWeb = NO;
                ActivityDetailViewController *viewController = (ActivityDetailViewController *)[currentNavi visibleViewController];
                [viewController doRefreshContent];
            }
        }
        
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/**
 * 初始化UNUserNotificationCenter
 */
- (void)registerForRemoteNotification {
    // iOS10 兼容
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        // 使用 UNUserNotificationCenter 来管理通知
        UNUserNotificationCenter *uncenter = [UNUserNotificationCenter currentNotificationCenter];
        // 监听回调事件
        [uncenter setDelegate:self];
        //iOS10 使用以下方法注册，才能得到授权
        [uncenter requestAuthorizationWithOptions:(UNAuthorizationOptionAlert+UNAuthorizationOptionBadge+UNAuthorizationOptionSound)
                                completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                                    //TODO:授权状态改变
                                    NSLog(@"%@" , granted ? @"授权成功" : @"授权失败");
                                }];
        // 获取当前的通知授权状态, UNNotificationSettings
        [uncenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            NSLog(@"%s\nline:%@\n-----\n%@\n\n", __func__, @(__LINE__), settings);
            /*
             UNAuthorizationStatusNotDetermined : 没有做出选择
             UNAuthorizationStatusDenied : 用户未授权
             UNAuthorizationStatusAuthorized ：用户已授权
             */
            if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined) {
                NSLog(@"未选择");
            } else if (settings.authorizationStatus == UNAuthorizationStatusDenied) {
                NSLog(@"未授权");
            } else if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
                NSLog(@"已授权");
            }
        }];
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        UIUserNotificationType types = UIUserNotificationTypeAlert |
        UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        UIRemoteNotificationType types = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    }
#pragma clang diagnostic pop
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation setObject:@YES forKey:@"EnableNotification"];
    [currentInstallation saveInBackground];
    
    
//    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
//    AVUser *currentUser = [AVUser currentUser];
//    AVObject *user_installation = [AVObject objectWithClassName:@"UserInstallation"];
//    [user_installation setObject:currentUser forKey:@"user"];
//    [user_installation setObject:currentInstallation forKey:@"installation"];
//    [user_installation setObject:currentInstallation.deviceToken forKey:@"deviceToken"];
//
//    [user_installation saveInBackground];
    
    
// 針對使用者更新notification資料
//    if (currentInstallation.objectId != nil) {
//        AVQuery *query = [AVInstallation query];
//        [query whereKey:@"objectId" equalTo:currentInstallation.objectId];
//        
//        [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
//            if (!error) {
//                [currentInstallation setObject:@"574179" forKey:@"member_id"];
//                [currentInstallation saveInBackground];
//            }
//        }];
//    }
    
}

/*!
 * Required for iOS 7+
 */
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))handler {
//    // Create empty photo object
    NSString *action = [userInfo objectForKey:@"category"];
    
//暫時    [self.mainTabBarController setSelectedIndex:[action intValue]];

    
//    AVObject *targetPhoto = [AVObject objectWithoutDataWithClassName:@"Photo"
//                                                            objectId:photoId];
//    
//    // Fetch photo object
//    [targetPhoto fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
//        // Show photo view controller
//        if (error) {
//            handler(UIBackgroundFetchResultFailed);
//        } else if ([AVUser currentUser]) {
//            PhotoVC *viewController = [[PhotoVC alloc] initWithPhoto:object];
//            [self.navController pushViewController:viewController animated:YES];
//        } else {
//            handler(UIBackgroundFetchResultNoData);
//        }
//    }];
}

/**
 * Required for iOS10+
 * 在前台收到推送内容, 执行的方法
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary *userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //TODO:处理远程推送内容
        NSLog(@"%@", userInfo);
    }
    // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
    completionHandler(UNNotificationPresentationOptionAlert);
}

/**
 * Required for iOS10+
 * 在后台和启动之前收到推送内容, 点击推送内容后，执行的方法
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)())completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //TODO:处理远程推送内容
        NSDictionary *aps = [userInfo objectForKey:@"aps"];
        NSString *action = [aps objectForKey:@"category"];
        
        //暫時[self.mainTabBarController setSelectedIndex:[action intValue]];
        NSLog(@"%@", userInfo);
    }
    completionHandler();
}

-(void)addBeaconNotic{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnPushMessageFile:) name:@"Notification_PushMessage" object:nil];
}

-(void)returnPushMessageFile:(NSNotification *)notification{
    
    NSDictionary *receiveInfo = [notification userInfo];
    
}

@end
