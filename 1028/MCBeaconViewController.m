//
//  MCBeaconViewController.m
//  FG
//
//  Created by fg on 2016/7/18.
//  Copyright © 2016年 FG. All rights reserved.
//

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define GOOGLEMAPGEO @"https://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&language=zh-TW&key=AIzaSyAMtnU1LNq9NT9GzSb-z3k9TUffvozjWqk"
#define QUESTION_URL @"http://specialevent.fashionguide.com.tw/question/index.php?member_id=%@&event=%@"
#define REWARD_URL @"http://specialevent.fashionguide.com.tw/winning/index.php?member_id=%@&event=%@"
#define MESSAGE_SPACE 8
#define MAX_FERQUENCY 3

#import "MCBeaconViewController.h"
#import "../Framework/SDWebImage/UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <AudioToolbox/AudioToolbox.h>
#import "UILabel+StringFrame.h"
#import "AlertLabel.h"
#import "ActivityDetailClass.h"
#import "MyManager.h"
#import "ApiBuilder.h"
#import "Reachability.h"
#import "../Framework/AFNetworking/AFNetworkReachabilityManager.h"

@interface MCBeaconViewController ()<CBCentralManagerDelegate,UIWebViewDelegate,CLLocationManagerDelegate>{
    UIView *showView;
    UIButton *closeBtn;
    UILabel *messageLabel;
    
    AVPlayerItem *playerItem;
    AVPlayer *player;
    AVPlayerLayer *playerLayer;
    BOOL getBeacon;
    UILabel *titleLabel;
    UIView *tmpView;
    MCTaskClass *myTask;
    CLLocationCoordinate2D userCorrdinate;
    CLLocationCoordinate2D leftupCorrdinate;
    CLLocationCoordinate2D rightdownCorrdinate;
    BOOL BTStatus;
    BOOL shakeStatus;
    UILabel *resultLabel;
    
    int ferquency;
    NSMutableArray *beaconArray;


}

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, strong)CBCentralManager *centralManager;

@property (nonatomic,strong) NSString *locationPermissionStatus;
@property (nonatomic ,assign) float videoLength;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, strong) IBOutlet UIImageView *launchView;
@property (strong, nonatomic) IBOutlet UILabel *noteLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *noteLabelWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *noteLabelHeight;
@property (strong, nonatomic) CLBeaconRegion *beaconRegion;

@end

@implementation MCBeaconViewController


-(id)initWithActivityTask:(MCTaskClass *)task{
    self = [super init];
    if (self) {
        myTask = task;
    }
    return self;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion
          withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake && !showView && BTStatus && !shakeStatus) {
        
        shakeStatus = YES;
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        titleLabel.text = @"尋找好康";
        self.noteLabel.text = @"尋找好康";
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
#if TARGET_IPHONE_SIMULATOR
        NSLog(@"模擬器不支援Beaocn");
#else
        [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];

//        if ([[MyManager shareManager] netWork])
//        {
//            [[FGManager shareManager] getRequest:[ApiBuilder getIndexShortcut] httpType:@"GET" parmeter:nil success:^(AFHTTPRequestOperation *operation, id data) {
//                if (data) {
//                    
//                    if ([myTask.taskid intValue] == 19 || [myTask.taskid intValue] == 20 || [myTask.taskid intValue] == 21 || [myTask.taskid intValue] == 22) {
//                        [self passActivity];
//                    }
//                    else{
//                        [_engine startScan];
//                        [self checkBeaconExist];
//                    }
//                }
//            } error:^(AFHTTPRequestOperation *operation, NSError *error) {
//                if (error) {
//                    [MBProgressHUD hideHUDForView:self.view animated:YES];
//
//                    if ([[error localizedDescription] isEqualToString:@"要求逾時。"]) {
//                        [AlertLabel ShowAlertInView:PublicAppDelegate.window alertMessage:@"喔喔～\n你的網路太不給力了@@\n請重新尋找收訊好的地方嚕..."];
//                    }
//                    else{
//                        [AlertLabel ShowAlertInView:PublicAppDelegate.window alertMessage:[error localizedDescription]];
//                    }
//                    
//                }
//                shakeStatus = NO;
//            }];
//        }
//        else
//        {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            [AlertLabel ShowAlertInView:PublicAppDelegate.window alertMessage:@"目前偵測不到網路，請檢查您的網路狀態"];
//            shakeStatus = NO;
//        }

#endif
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
//    if (showView) {
//        [self closeDM:nil];
//    }
//#if TARGET_IPHONE_SIMULATOR
//    NSLog(@"模擬器不支援Beacon");
//#else
//    [_engine pauseScan];
//    [self removeBeaconNotic];
//#endif
//    [playerLayer removeFromSuperlayer];
//    player = nil;
//    
//    
//    //    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortraitUpsideDown] forKey:@"orientation"];
//    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [PublicAppDelegate.mainTabBarController.tabBar setHidden:YES];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButtonItem];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    [titleLabel setTextColor:[UIColor colorWithRed:248.0/255.0 green:134.0/255.0 blue:134.0/255.0 alpha:1]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    NSLog(@"navi = %@",self.navigationItem.titleView);
    self.navigationItem.titleView = titleLabel;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(0, 20, 25, 25)];
    [cancelBtn addTarget:self action:@selector(cancelHandler:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"ic_arrow_white"] forState:UIControlStateNormal];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, cancelItem]];
    
    //    [self.noteLabel setText:[myTask.content objectForKey:@"desc"]];
//    self.noteLabel.numberOfLines = 0;
//    CGSize size = [self.noteLabel boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-30, 0)];
//    self.noteLabelWidth.constant = SCREEN_WIDTH-30;
//    self.noteLabelHeight.constant = size.height+MESSAGE_SPACE;
//    [self.noteLabel setTextColor:[UIColor colorWithRed:248.0/255.0 green:134.0/255.0 blue:134.0/255.0 alpha:1]];
    
    [self checkLocationPremission];
}

-(void)cancelHandler:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//-(void)addBeaconNotic{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnPushMessageFile:) name:@"Notification_PushMessage" object:nil];
//}

//-(void)removeBeaconNotic{
//    @try {
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Notification_PushMessage" object:nil];
//        NSLog(@"removBeaconNoticSuccess");
//    } @catch (NSException *exception) {
//        NSLog(@"removeBeaconNoticError:%@",exception.reason);
//    }
//}

//-(void)checkBeaconExist{
//    _timer = [NSTimer scheduledTimerWithTimeInterval:20.0f
//                                              target:self
//                                            selector:@selector(timerFire:)
//                                            userInfo:nil
//                                             repeats:NO];
//}

//-(void)timerFire:(id)userinfo {
//    NSLog(@"Fire");
//    if (!getBeacon) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [_engine pauseScan];
//        [_timer invalidate];
//        [AlertLabel ShowAlertInView:PublicAppDelegate.window alertMessage:@"附近沒有活動喔!"];
//        titleLabel.text = @"請搖一搖";
//        self.noteLabel.text = @"請搖一搖";
//        shakeStatus = NO;
//    }
//    
//}

//-(void)returnPushMessageFile:(NSNotification *)notification{
//    
//    getBeacon = YES;
//    
//    //    titleLabel.text = @"處理中...";
//    //    self.noteLabel.text = @"處理中...";
//    
//    NSDictionary *receiveInfo = [notification userInfo];
//    
//    [self sendLocalNotificationWithMessage:receiveInfo];
//}

//-(void)addRotationNotic{
//    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
//    //    [self.view addObserver:self forKeyPath:@"bounds" options:0 context:nil];
//    
//}
//
//-(void)removeRotationNotic{
//    @try {
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceOrientationDidChangeNotification" object:nil];
//        NSLog(@"removeRotationNoticSuccess");
//    } @catch (NSException *exception) {
//        NSLog(@"removeRotationNoticError:%@",exception.reason);
//    }
//    
//}
//
//-(void)orientationChanged:(NSNotification *)notification{
//    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
//    //[UIApplication sharedApplication].statusBarOrientation
//    CGFloat radian = 0;
//    switch (orientation) {
//        case UIInterfaceOrientationPortrait:
//            radian = -90;
//            NSLog(@"轉啦！正常直向");
//            NSLog(@"self.bounce = %@",NSStringFromCGRect(self.view.bounds));
//            [self nonTitleRotationView:self.view.bounds];
//            
//            break;
//        case UIInterfaceOrientationPortraitUpsideDown:
//            radian = 90;
//            NSLog(@"轉啦！反直向");
//            break;
//        case UIInterfaceOrientationLandscapeLeft:
//            radian = 180;
//            NSLog(@"轉啦！按鈕左邊橫向");
//            NSLog(@"self.bounce = %@",NSStringFromCGRect(self.view.frame));
//            [self nonTitleRotationView:self.view.bounds];
//            break;
//        case UIInterfaceOrientationLandscapeRight:
//            radian = 0;
//            NSLog(@"轉啦！按鈕右邊橫向");
//            [self nonTitleRotationView:self.view.bounds];
//            break;
//        default:
//            break;
//    }
//}
//
//-(void)rotationView:(CGRect)newFrame{
//    
//    CALayer *newLayer = [[CALayer alloc] init];
//    
//    if (newFrame.size.width > newFrame.size.height) {
//        
//        showView.frame = newFrame;
//        NSLog(@"newFrame = %@",NSStringFromCGRect(newFrame));
//        NSLog(@"navi_hight = %f",self.navigationController.navigationBar.frame.size.height);
//        CGSize size = [messageLabel boundingRectWithSize:CGSizeMake(newFrame.size.width, 0)];
//        messageLabel.frame = CGRectMake(newFrame.origin.x, newFrame.origin.y+self.navigationController.navigationBar.frame.size.height, newFrame.size.width, size.height+MESSAGE_SPACE);
//        closeBtn.frame = CGRectMake(newFrame.size.width-30, newFrame.origin.y, 30, 30);
//        
//        newLayer.frame = CGRectMake((newFrame.size.width - ((newFrame.size.height-size.height-MESSAGE_SPACE-self.navigationController.navigationBar.frame.size.height)*16)/9)/2, messageLabel.frame.origin.y+size.height+MESSAGE_SPACE,((newFrame.size.height-size.height-MESSAGE_SPACE-self.navigationController.navigationBar.frame.size.height)*16)/9, newFrame.size.height-size.height-MESSAGE_SPACE-self.navigationController.navigationBar.frame.size.height);
//        NSLog(@"lastframe = %@",NSStringFromCGRect(newLayer.frame));
//        playerLayer.frame = newLayer.frame;
//        newLayer = nil;
//    }
//    else{
//        NSLog(@"navi_hight2 = %f",self.navigationController.navigationBar.frame.size.height);
//        
//        showView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
//        
//        CGSize size = [messageLabel boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 0)];
//        [messageLabel setFrame:CGRectMake(0, 64, SCREEN_WIDTH, size.height+MESSAGE_SPACE)];
//        closeBtn.frame = CGRectMake(SCREEN_WIDTH-30, 0, 30, 30);
//        
//        newLayer.frame = CGRectMake(0, (SCREEN_HEIGHT-SCREEN_WIDTH/16*9)/2+self.navigationController.navigationBar.frame.size.height-size.height+MESSAGE_SPACE,SCREEN_WIDTH, SCREEN_WIDTH/16*9);
//        playerLayer.frame = newLayer.frame;
//        newLayer = nil;
//    }
//}
//
//-(void)nonTitleRotationView:(CGRect)newFrame{
//    CALayer *newLayer = [[CALayer alloc] init];
//    
//    if (newFrame.size.width > newFrame.size.height) {
//        
//        showView.frame = newFrame;
//
//        newLayer.frame = CGRectMake((newFrame.size.width - ((newFrame.size.height-self.navigationController.navigationBar.frame.size.height)*16)/9)/2, self.navigationController.navigationBar.frame.size.height,((newFrame.size.height-self.navigationController.navigationBar.frame.size.height)*16)/9, newFrame.size.height-self.navigationController.navigationBar.frame.size.height);
//        NSLog(@"lastframe = %@",NSStringFromCGRect(newLayer.frame));
//        playerLayer.frame = newLayer.frame;
//        newLayer = nil;
//    }
//    else{
//        showView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
//        
//        newLayer.frame = CGRectMake(0, (SCREEN_HEIGHT-SCREEN_WIDTH/16*9-64)/2,SCREEN_WIDTH, SCREEN_WIDTH/16*9);
//        playerLayer.frame = newLayer.frame;
//        newLayer = nil;
//    }
//
//}
//
//- (void)addVideoKVO
//{
//    //KVO
//    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
//    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
//    [playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
//}
//- (void)removeVideoKVO {
//    
//    @try {
//        [playerItem removeObserver:self forKeyPath:@"status"];
//        [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
//        [playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
//        NSLog(@"removeVideoKVOSuccess");
//    } @catch (NSException *exception) {
//        NSLog(@"removeVideoKVOError:=%@",exception.reason);
//    }
//}
//
//- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSString*, id> *)change context:(nullable void *)context {
//    
//    if ([keyPath isEqualToString:@"status"]) {
//        AVPlayerItemStatus status = playerItem.status;
//        NSLog(@"status = %ld",(long)status);
//        switch (status) {
//            case AVPlayerItemStatusReadyToPlay:
//            {
//                NSLog(@"AVPlayerItemStatusReadyToPlay");
//                [player play];
//                if([myTask.times intValue] < [myTask.total intValue]){
//                    [self getMissionComplete];
//                }
//                _videoLength = floor(playerItem.asset.duration.value * 1.0/ playerItem.asset.duration.timescale);
//                
//            }
//                break;
//            case AVPlayerItemStatusUnknown:
//            {
//                NSLog(@"AVPlayerItemStatusUnknown");
//            }
//                break;
//            case AVPlayerItemStatusFailed:
//            {
//                NSLog(@"AVPlayerItemStatusFailed");
//                NSLog(@"%@",playerItem.error);
//            }
//                break;
//                
//            default:
//                break;
//        }
//    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
//        NSLog(@"loaded");
//        [self availableDurationWithPlayItem:playerItem];
//    } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
//        NSLog(@"empty");
//    }
//}
//-(void)availableDurationWithPlayItem:(AVPlayerItem *)aPlayerItem{
//    NSArray *timeRangeArray = playerItem.loadedTimeRanges;
//    CMTimeRange timeRange = [timeRangeArray.firstObject CMTimeRangeValue];
//    NSTimeInterval startTime = CMTimeGetSeconds(timeRange.start);
//    NSTimeInterval loadedDuration = CMTimeGetSeconds(timeRange.duration);
//    
//    NSTimeInterval current = CMTimeGetSeconds(player.currentTime);
//    
//    NSLog(@"time = %f,currenttime = %f",startTime+loadedDuration,current);
//}

//- (void)upadte
//{
//    NSTimeInterval current = CMTimeGetSeconds(player.currentTime);
//    NSTimeInterval total = CMTimeGetSeconds(player.currentItem.duration);
//
//    if (current!=self.lastTime) {
//        NSLog(@"upfate.text = %@",[NSString stringWithFormat:@"%f/%f",current, total]);
//    }else{
//        NSLog(@"lag");
//    }
//    self.lastTime = current;
//}
//- (void)addVideoNotic {
//    
//    //Notification
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieJumped:) name:AVPlayerItemTimeJumpedNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieStalle:) name:AVPlayerItemPlaybackStalledNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backGroundPauseMoive) name:UIApplicationDidEnterBackgroundNotification object:nil];
//    
//}
//- (void)removeVideoNotic {
//    //
//    @try {
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemPlaybackStalledNotification object:nil];
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemTimeJumpedNotification object:nil];
//        NSLog(@"removeVideoNoticSuccess");
//    } @catch (NSException *exception) {
//        NSLog(@"removeVideoNoticError:%@",exception.reason);
//    }
//}
//
//- (void)movieToEnd:(NSNotification *)notic {
//    NSLog(@"%@",NSStringFromSelector(_cmd));
//    [self closeDM:nil];
//    
//}
//- (void)movieJumped:(NSNotification *)notic {
//    NSLog(@"%@",NSStringFromSelector(_cmd));
//}
//- (void)movieStalle:(NSNotification *)notic {
//    NSLog(@"%@",NSStringFromSelector(_cmd));
//}
//- (void)backGroundPauseMoive {
//    NSLog(@"%@",NSStringFromSelector(_cmd));
//}

-(void)checkSetting:(NSString *)title message:(NSString *)aMessage{
    
    titleLabel.text = @"請允許使用您的位置";
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:aMessage
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    UIAlertAction *settingAction = [UIAlertAction actionWithTitle:@"前往設定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self openSettingsScreenForApp];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:settingAction];
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}

-(void)openBlueTooth{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Bluetooth"]];
}

-(void)setRTLS{
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"模擬器不支援Beacon");
#else
    titleLabel.text = @"請搖一搖";
    self.noteLabel.text = @"請搖一搖";
    
//    NSString *url = @"http://fg-rtls.doubleservice.com/";
//    _engine = [[RtlsEngine new] initRtlsEngineWithServerURL:url];
//    [_engine setBeaconUUID:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"];
//    [_engine initLBS];
//    [_engine setScanTimesPerLocatePosition:3];
//    
//    [self addBeaconNotic];
    
    beaconArray = [[NSMutableArray alloc] init];

    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"];
    
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"FashionGuide"];
#endif
}

-(void)locationManager:(CLLocationManager*)manager didRangeBeacons:(NSArray*)beacons inRegion:(CLBeaconRegion*)region
{
    // Beacon found!
    if (ferquency == MAX_FERQUENCY) {
        [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
        [self processBeaconData:beacons];
    }
    ferquency ++;
    
}

-(void)processBeaconData:(NSArray *)data{
    
    for (CLBeacon *obj in data) {
        NSDictionary *beaconInfo = @{@"major":obj.major,@"minor":obj.minor,@"rssi":[NSNumber numberWithInteger:obj.rssi]};
        [beaconArray addObject:beaconInfo];
    }
}



//-(void)sendLocalNotificationWithMessage:(NSDictionary*)message {
//    
//    if (showView) {
//        //        titleLabel.text = @"已有資料";
//        //        self.noteLabel.text = @"已有資料";
//        return;
//    }
//    
//    
////    [self multipeBeaconIdentify:message];
//    [self singleBeaocnIdentify:message];
////    NSLog(@"dictURL = %@",[dict objectForKey:@"url"]);
//    
//}

#pragma mark - 單辨識
- (void)singleBeaocnIdentify:(NSDictionary *)message{
//    if ([message objectForKey:@"ap_message_file"] != nil) {
//        
//        showView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
//        [showView setBackgroundColor:[UIColor whiteColor]];
//        [self.view addSubview:showView];
//        resultLabel = [[UILabel alloc] init];
//        resultLabel.numberOfLines = 0;
//        [resultLabel setTextColor:[UIColor colorWithRed:248.0/255.0 green:134.0/255.0 blue:134.0/255.0 alpha:1]];
//        
//        [showView addSubview:resultLabel];
//        
//        [_engine pauseScan];
//        
//        switch ([myTask.subType intValue]) {
//            case TaskActivitySubTypeForPic:
//                if([[message objectForKey:@"ap_message_file"] rangeOfString:@".jpg"].location != NSNotFound){
//                    
//                    [self addOtherDescription:message];
//                    
//                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, showView.frame.size.width, showView.frame.size.height-30)];
//                    [imageView setContentMode:UIViewContentModeScaleAspectFit];
//                    
//                    [showView addSubview:imageView];
//                    
//                    [imageView sd_setImageWithURL:[NSURL URLWithString:[message objectForKey:@"ap_message_file"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                        titleLabel.text = @"好康來囉";
//                        self.noteLabel.text = @"好康來囉";
//                        [self checkFirstTimeComplete];
//                        [MBProgressHUD hideHUDForView:self.view animated:YES];
//                    }];
//                    
//                }
//                else{
//                    [self closeDM:nil];
//                    [AlertLabel ShowAlertInView:PublicAppDelegate.window alertMessage:@"請選擇正確的活動主題!"];
//                    [MBProgressHUD hideHUDForView:self.view animated:YES];
//                }
//                break;
//            case TaskActivitySubTypeForVideo:
//                if ([[message objectForKey:@"ap_message_file"] rangeOfString:@".mp4"].location != NSNotFound) {
//                    
//                    [self addOtherDescription:message];
//                    
//                    [self addRotationNotic];
//                    
//                    PublicAppDelegate.shouldRotate = YES;
//                    
//                    playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:[message objectForKey:@"ap_message_file"]]];
//                    player = [AVPlayer playerWithPlayerItem:playerItem];
//                    playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
//                    
//                    UIView *preview = [[UIView alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT-SCREEN_WIDTH/16*9-64)/2,SCREEN_WIDTH, SCREEN_WIDTH/16*9)];
//                    CALayer *previewLayer = preview.layer;
//                    playerLayer.frame = previewLayer.frame;
//                    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
//                    
//                    [showView.layer addSublayer:playerLayer];
//                    
//                    [self addVideoKVO];
//                    [self addVideoNotic];
//                    
//                    //            self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(upadte)];
//                    //            [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
//                    //            [player play];
//                    
//                    titleLabel.text = @"好康來囉";
//                    self.noteLabel.text = @"好康來囉";
//                }
//                else{
//                    [self closeDM:nil];
//                    [AlertLabel ShowAlertInView:PublicAppDelegate.window alertMessage:@"請選擇正確的活動主題!"];
//                }
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
//                break;
//            case TaskActivitySubTypeForLottery:
//                if([[message objectForKey:@"ap_message"] rangeOfString:@"抽獎"].location != NSNotFound || [[message objectForKey:@"ap_message"] rangeOfString:myTask.action].location != NSNotFound){
//                    
//                    [self addOtherDescription:message];
//                    
//                    [[FGManager shareManager] getRequest:[NSString stringWithFormat:REWARD_URL,PublicAppDelegate.userLoginDataClass.memberID,myTask.taskid] httpType:@"GET" parmeter:nil success:^(AFHTTPRequestOperation *operation, id data) {
//                        
//                        titleLabel.text = @"完成抽獎";
//                        
//                        NSDictionary *dic = data;
//                        
//                        [AlertLabel ShowAlertInView:PublicAppDelegate.window alertMessage:[dic objectForKey:@"reward_message"]];
//                        
//                        resultLabel.text = [dic objectForKey:@"reward_message"];
//                        CGSize size =[resultLabel boundingRectWithSize:CGSizeMake(200, 0)];
//                        resultLabel.frame = CGRectMake((SCREEN_WIDTH-size.width)/2, (SCREEN_HEIGHT-64-size.height)/2, size.width, size.height);
//                        [MBProgressHUD hideHUDForView:self.view animated:YES];
//                        
//                    } error:^(AFHTTPRequestOperation *operation, NSError *error) {
//                        [AlertLabel ShowAlertInView:PublicAppDelegate.window alertMessage:@"抽獎錯誤"];
//                        resultLabel.text = @"抽獎錯誤";
//                        CGSize size =[resultLabel boundingRectWithSize:CGSizeMake(200, 0)];
//                        resultLabel.frame = CGRectMake((SCREEN_WIDTH-size.width)/2, (SCREEN_HEIGHT-64-size.height)/2, size.width, size.height);
//                        [MBProgressHUD hideHUDForView:self.view animated:YES];
//                        
//                    }];
//                    
//                }
//                else{
//                    [self closeDM:nil];
//                    [AlertLabel ShowAlertInView:PublicAppDelegate.window alertMessage:@"請選擇正確的活動主題!"];
//                    [MBProgressHUD hideHUDForView:self.view animated:YES];
//                }
//                break;
//            case TaskActivitySubTypeForQuestion:
//                if([[message objectForKey:@"ap_message"] rangeOfString:@"問卷"].location != NSNotFound || [[message objectForKey:@"ap_message"] rangeOfString:myTask.action].location != NSNotFound){
//                    
//                    [[FGManager shareManager] getRequest:[NSString stringWithFormat:QUESTION_URL,PublicAppDelegate.userLoginDataClass.memberID,myTask.taskid] httpType:@"GET" parmeter:nil success:^(AFHTTPRequestOperation *operation, id data) {
//                        if ([[data allKeys] containsObject:@"quest_url"]) {
//                            UIWebView *questionView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, showView.frame.size.width, showView.frame.size.height)];
//                            [showView addSubview:questionView];
//                            questionView.delegate = self;
//                            questionView.scalesPageToFit = YES;
//                            [questionView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[data objectForKey:@"quest_url"]]]];
//                        }
//                        else{
//                            [self closeDM:nil];
//                            [AlertLabel ShowAlertInView:PublicAppDelegate.window alertMessage:[data objectForKey:@"message"]];
//                        }
//                        [MBProgressHUD hideHUDForView:self.view animated:YES];
//                        
//                    } error:^(AFHTTPRequestOperation *operation, NSError *error) {
//                        [AlertLabel ShowAlertInView:PublicAppDelegate.window alertMessage:[error localizedDescription]];
////                        [AlertLabel ShowAlertInView:PublicAppDelegate.window alertMessage:@"問卷錯誤"];
////                        resultLabel.text = @"問卷錯誤";
////                        CGSize size =[resultLabel boundingRectWithSize:CGSizeMake(200, 0)];
////                        resultLabel.frame = CGRectMake((SCREEN_WIDTH-size.width)/2, (SCREEN_HEIGHT-64-size.height)/2, size.width, size.height);
//                        [MBProgressHUD hideHUDForView:self.view animated:YES];
//                    }];
//                }
//                else{
//                    [self closeDM:nil];
//                    [AlertLabel ShowAlertInView:PublicAppDelegate.window alertMessage:@"請選擇正確的活動主題!"];
//                    [MBProgressHUD hideHUDForView:self.view animated:YES];
//                }
//                break;
//            case TaskActivitySubTypeForGScroe:
//                if([[message objectForKey:@"ap_message"] rangeOfString:@"簽到"].location != NSNotFound || [[message objectForKey:@"ap_message"] rangeOfString:myTask.action].location != NSNotFound){
//                    if([myTask.times intValue] < [myTask.total intValue]){
//                        [self getMissionComplete];
//                    }
//                    else{
//                        [self getMissionComplete];
//                    }
//                }
//                else{
//                    [self closeDM:nil];
//                    [AlertLabel ShowAlertInView:PublicAppDelegate.window alertMessage:@"請選擇正確的活動主題!"];
//                    [MBProgressHUD hideHUDForView:self.view animated:YES];
//                }
//                break;
//            default:
//                break;
//        }
//    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

//-(void)addOtherDescription:(NSDictionary *)message{
//    if (!messageLabel) {
//        
//        messageLabel = [[UILabel alloc] init];
//        [messageLabel setText:[message objectForKey:@"ap_message"]];
//        messageLabel.numberOfLines = 0;
//        CGSize size = [messageLabel boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 0)];
//        [messageLabel setFrame:CGRectMake(0, 0, SCREEN_WIDTH, size.height+MESSAGE_SPACE)];
//        [messageLabel setTextColor:[UIColor whiteColor]];
//        [messageLabel setBackgroundColor:[UIColor colorWithRed:248.0/255.0 green:134.0/255.0 blue:134.0/255.0 alpha:.8]];
//        //            [messageLabel.layer setCornerRadius:15];
//        [messageLabel setTextAlignment:NSTextAlignmentCenter];
//        
//        [showView addSubview:messageLabel];
//    }
//    
//    if (!closeBtn) {
//        closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-30, 0, 30, 30)];
//        [closeBtn setImage:[UIImage imageNamed:@"btn_del"] forState:UIControlStateNormal];
//        [closeBtn addTarget:self action:@selector(closeDM:) forControlEvents:UIControlEventTouchUpInside];
//        [closeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        [closeBtn setBackgroundColor:[UIColor whiteColor]];
//        [closeBtn.layer setBorderColor:[UIColor colorWithRed:255 green:227 blue:132 alpha:1].CGColor];
//        [closeBtn.layer setBorderWidth:1.0];
//        [closeBtn.layer setCornerRadius:15];
//        
//        [showView addSubview:closeBtn];
//    }
//}
//
//-(void)closeDM:(UIButton *)sender{
//    NSLog(@"%@",NSStringFromSelector(_cmd));
//    
//    if (player) {
//        //        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortraitUpsideDown] forKey:@"orientation"];
//        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
//        
//        [self removeVideoKVO];
//        [self removeVideoNotic];
//        [self addRotationNotic];
//        [player pause];
//        PublicAppDelegate.shouldRotate = NO;
//    }
//    
//    [showView removeFromSuperview];
//    showView  = nil;
//    [closeBtn removeFromSuperview];
//    closeBtn = nil;
//    
//    [messageLabel removeFromSuperview];
//    messageLabel = nil;
//    
//    
//    titleLabel.text = @"請搖一搖";
//    self.noteLabel.text = @"請搖一搖";
//    getBeacon = NO;
//    [_timer invalidate];
//    _timer =nil;
//    shakeStatus = NO;
//}

-(void)checkLocationPremission{
    
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusAuthorizedAlways:
            NSLog(@"Authorized Always");
            self.locationPermissionStatus = @"Always";
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"Authorized when in use");
            self.locationPermissionStatus = @"when in use";
            [self checkBlueToothPowerState];
            break;
        case kCLAuthorizationStatusDenied:
            NSLog(@"Denied");
            self.locationPermissionStatus = @"Denied";
            [self checkSetting:@"尚未開啟定位服務" message:@"提供權限能參與更多優惠活動唷!"];
            break;
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"Not determined");
            self.locationPermissionStatus = @"Not determined";
            self.locationManager = [[CLLocationManager alloc] init];
            
            self.locationManager.delegate = self;
            
            //設定需要重新定位的距離差距(10m)
            self.locationManager.distanceFilter = 10;
            //設定定位時的精準度
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            if(IS_OS_8_OR_LATER) {
                [self.locationManager requestWhenInUseAuthorization];
                [self.locationManager startUpdatingLocation];
            }
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog(@"Restricted");
            self.locationPermissionStatus = @"Restricted";
            break;
            
        default:
            break;
    }
    
    //    if ([self.locationPermissionStatus isEqualToString:@"Denied"]) {
    //        [self checkSetting:@"尚未開啟定位服務" message:@"提供權限能參與更多優惠活動唷!"];
    //    }
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *) oldLocation {
    
    if (userCorrdinate.latitude == 0 && userCorrdinate.longitude == 0) {
        
        self.noteLabel.text = [NSString stringWithFormat:@"經度：%f,緯度：%f",newLocation.coordinate.longitude,newLocation.coordinate.latitude];
        userCorrdinate = newLocation.coordinate;
        [self.locationManager stopUpdatingLocation];
    }
}

- (void)openSettingsScreenForApp {
    NSURL *settingsURL = [[NSURL alloc] initWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:settingsURL];
}

-(void)checkBlueToothPowerState{
    if (_centralManager == nil) {
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }else{
        [self centralManagerDidUpdateState:_centralManager];
    }
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state == CBCentralManagerStatePoweredOn) {
        if([self.locationPermissionStatus isEqualToString:@"when in use"]){
            BTStatus = YES;
            [self setRTLS];
        }
    } else if(central.state == CBCentralManagerStatePoweredOff) {
        //        [self openBlueTooth];
        BTStatus = NO;
        titleLabel.text = @"請開啟藍芽";
        self.noteLabel.text = @"請開啟藍芽";
        
        //TODO:
        [self.locationManager stopRangingBeaconsInRegion: self.beaconRegion];

//        if (_engine) {
//            [_engine pauseScan];
//        }
    }
}

//-(void)checkFirstTimeComplete{
//    if([myTask.times intValue] < [myTask.total intValue]){
//        [self getMissionComplete];
//    }
//}

//-(void)getMissionComplete{
//    [[FGManager shareManager] getRequest:[ApiBuilder getSpecialMissionComplete] httpType:@"POST" parmeter:@{@"event_id":myTask.taskid} success:^(AFHTTPRequestOperation *operation, id data) {
//        NSLog(@"myid = %@",data);
//        myTask.times = [NSString stringWithFormat:@"%d",[myTask.times intValue]+1];
//        if ([[data allKeys] containsObject:@"message"]) {
//            if (![[data objectForKey:@"message"] isKindOfClass:[NSNull class]]) {
//                if (![[data objectForKey:@"message"] isEqualToString:@""]) {
//                    [AlertLabel ShowAlertInView:PublicAppDelegate.window alertMessage:[data objectForKey:@"message"]];
//                    resultLabel.text = [data objectForKey:@"message"];
//                    CGSize size =[resultLabel boundingRectWithSize:CGSizeMake(200, 0)];
//                    resultLabel.frame = CGRectMake((SCREEN_WIDTH-size.width)/2, (SCREEN_HEIGHT-64-size.height)/2, size.width, size.height);
//                }
//            }
//        }
//        
//    } error:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
//        
//        if(errorData == nil){
//            [PublicAppDelegate logout:@"Error 401: 發生錯誤，請稍候再試"];
//        }
//        else{
//            NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
//            if ([[serializedData allKeys] containsObject:@"message"]) {
//                [self closeDM:nil];
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
//                [AlertLabel ShowAlertInView:PublicAppDelegate.window alertMessage:[serializedData objectForKey:@"message"]];
//            }
//        }
//        
//    }];
//}

//-(void)passActivity{
//    
//    [[FGManager shareManager] getRequest:[NSString stringWithFormat:QUESTION_URL,PublicAppDelegate.userLoginDataClass.memberID,myTask.taskid] httpType:@"GET" parmeter:nil success:^(AFHTTPRequestOperation *operation, id data) {
//        if ([[data allKeys] containsObject:@"quest_url"]) {
//            showView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
//            [showView setBackgroundColor:[UIColor whiteColor]];
//            [self.view addSubview:showView];
//            UIWebView *questionView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, showView.frame.size.width, showView.frame.size.height)];
//            [showView addSubview:questionView];
//            questionView.delegate = self;
//            questionView.scalesPageToFit = YES;
//            [questionView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[data objectForKey:@"quest_url"]]]];
//        }
//        else{
//            [self closeDM:nil];
//            [AlertLabel ShowAlertInView:PublicAppDelegate.window alertMessage:[data objectForKey:@"message"]];
//        }
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        
//    } error:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if ([[error localizedDescription] isEqualToString:@"要求逾時。"]) {
//            [AlertLabel ShowAlertInView:PublicAppDelegate.window alertMessage:@"喔喔～\n你的網路太不給力了@@\n請重新尋找收訊好的地方嚕..."];
//        }
//        else{
//            [AlertLabel ShowAlertInView:PublicAppDelegate.window alertMessage:[error localizedDescription]];
//        }
//        shakeStatus = NO;
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//    }];
//}

@end
