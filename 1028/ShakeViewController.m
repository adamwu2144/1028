//
//  ShakeViewController.m
//  1028
//
//  Created by fg on 2017/6/9.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "ShakeViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <AVFoundation/AVFoundation.h>
#import "MBProgressHUD.h"
#import "MyManager.h"
#import "ApiBuilder.h"
#import "BeaconClass.h"
#import "../Framework/AFNetworking/AFHTTPSessionManager.h"

#define DETECT_FREQUENCY 3
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface ShakeViewController ()<CLLocationManagerDelegate, CBCentralManagerDelegate>{
    BOOL BTStatus;
    BeaconClass *beaconClass;
    NSNumber *taskID;
    BOOL shakeStatus;
    BOOL withBeacon;
    NSString *resultURL;
}

@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSString *locationPermissionStatus;
@property (nonatomic, strong) CBCentralManager *centralManager;

@end

@implementation ShakeViewController{
    int ferquency;
    NSMutableArray *beaconArray;
    int currentMode;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withTask:(ActivityDetailClass *)aTask withBeacon:(BOOL)aBeacon{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        taskID = aTask.task_id;
        resultURL = aTask.result_url;
        withBeacon = aBeacon;
    }
    return self;
};

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion
          withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake && BTStatus && !shakeStatus) {

        shakeStatus = YES;
    
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

//        self.title = @"尋找好康";
        self.messageLabel.text = @"尋找好康";
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
#if TARGET_IPHONE_SIMULATOR
        NSLog(@"模擬器不支援Beaocn");
#else
        if (withBeacon) {
            [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
        }
        else{
            [self.myWebView setHidden:NO];
            [self.myWebView setRequestWithURL:resultURL];
        }

#endif
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    beaconArray = [[NSMutableArray alloc] init];
    [self.myWebView setHidden:YES];
    [self initMyNavi];
    [self checkLocationPremission];
//    self.title = [taskID stringValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initMyNavi{
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(0, 0, 35, 35)];
    [cancelBtn addTarget:self action:@selector(cancelHandler:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"ic_arrow_white"] forState:UIControlStateNormal];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, cancelItem]];
    
    self.navigationItem.titleView.tintColor = [UIColor whiteColor];
    
    UIImageView *logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_s"]];
    [logoImage setFrame:CGRectMake(0, 0, 120, 33)];
    logoImage.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.navigationItem setTitleView:logoImage];
}

-(void)checkLocationPremission{
    
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusAuthorizedAlways:
            NSLog(@"Authorized Always");
            self.locationPermissionStatus = @"Always";
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"Authorized when in use");
            self.locationPermissionStatus = @"when in use";
            [self initLocaltion];
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
            [self initLocaltion];
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog(@"Restricted");
            self.locationPermissionStatus = @"Restricted";
            break;
            
        default:
            break;
    }
}

-(void)initLocaltion{
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    
    //設定需要重新定位的距離差距(10m)
    self.locationManager.distanceFilter = 10;
    //設定定位時的精準度
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.allowsBackgroundLocationUpdates = NO;
    self.locationManager.pausesLocationUpdatesAutomatically = NO;


    if(IS_OS_8_OR_LATER) {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager startUpdatingLocation];
    }
    
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
//            self.title = @"請搖一搖";
            self.messageLabel.text = @"請搖一搖";
            [self setBeacon];
        }
    } else if(central.state == CBCentralManagerStatePoweredOff) {
        //        [self openBlueTooth];
        BTStatus = NO;
//        self.title = @"請開啟藍芽";
        self.messageLabel.text = @"請開啟藍芽";

//        if (_engine) {
//            [_engine pauseScan];
//        }
    }
}

-(void)setBeacon{

    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"];

    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"FashionGuide"];
//    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];

}

-(void)locationManager:(CLLocationManager*)manager didRangeBeacons:(NSArray*)beacons inRegion:(CLBeaconRegion*)region
{
    // Beacon found!
    if (ferquency == DETECT_FREQUENCY) {
        [self processBeaconData:beacons];
    }
    ferquency ++;

}

-(void)processBeaconData:(NSArray *)data{

    for (CLBeacon *obj in data) {
        NSMutableDictionary *beaconInfo = [[NSMutableDictionary alloc] init];
        
        NSString *major = [obj.major stringValue];
        NSString *minor = [obj.minor stringValue];

        [beaconInfo setValue:major forKey:@"major"];
        [beaconInfo setValue:minor forKey:@"minor"];
        
        [beaconArray addObject:beaconInfo];
    }
    [self.locationManager stopRangingBeaconsInRegion: self.beaconRegion];
    
    [self getResult];

}

-(void)checkSetting:(NSString *)title message:(NSString *)aMessage{
    
//    self.title = @"請允許使用您的位置";
    self.messageLabel.text = @"請允許使用您的位置";
    
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

- (void)openSettingsScreenForApp {
    NSURL *settingsURL = [[NSURL alloc] initWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:settingsURL];
}

-(void)cancelHandler:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(doRefreshContentFromBeacon)]) {
        [self.delegate doRefreshContentFromBeacon];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)getResult{
    
    
    if ([beaconArray count] < 1) {
        [self showVaildMessageWithTitle:@"訊息" content:@"附近沒有活動喔！"];
    }
    else{
        NSMutableDictionary *beaconParam = [[NSMutableDictionary alloc] init];
        
        [beaconParam setValue:taskID forKey:@"event_id"];
        [beaconParam setValue:beaconArray forKey:@"beacons"];
        
        [self.myWebView setHidden:NO];
        
        [[MyManager shareManager] addJWT];
        
        [[MyManager shareManager] requestWithMethod:PUT WithPath:[ApiBuilder getEventsResultFromBeacon] WithParams:beaconParam WithSuccessBlock:^(NSDictionary *dic) {
            
            NSDictionary *tmp = [dic objectForKey:@"items"];
            
            beaconClass = [BeaconClass initWithDic:tmp];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [self.myWebView setRequestWithURL:beaconClass.url];
            
        } WithFailurBlock:^(NSError *error, int statusCode) {
            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
            NSString *message = [serializedData objectForKey:@"message"];
            NSLog(@"message = %@",message);
            
            [self showVaildMessageWithTitle:@"訊息" content:message];
        }];
    }
    
    
}

-(void)showVaildMessageWithTitle:(NSString *)title content:(NSString *)message{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    alertController.view.tintColor = DEFAULT_COLOR;
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [[MyManager shareManager] getUserDataWithJWT:nil WithComplete:^(BOOL status, int code) {
            if (status) {
                
                [PublicAppDelegate.mainTabBarController.taskViewController setData];
                
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                }];
            }
        }];
        
    }];
    
    [alertController addAction:confirmAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
