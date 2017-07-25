//
//  SuperMainViewController.m
//  1028
//
//  Created by fg on 2017/6/1.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "SuperMainViewController.h"
#import "UIBarButtonItem+Badge.h"
#import "MessageCenterViewController.h"
#import "MemberRegisterData.h"
#import "NotificationViewController.h"
#import "MBProgressHUD.h"
#import "MyManager.h"

@interface SuperMainViewController ()<NotificationViewControllerDelegate>

@property(nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation SuperMainViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:240.0/255.0 green:145.0/255.0 blue:146.0/255.0 alpha:1.0f];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButtonItem];
    
    self.navigationItem.rightBarButtonItem.badgeValue = [[[MyManager shareManager] memberData].notification stringValue];

//    UIImageView *logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_s"]];
//    [logoImage setFrame:CGRectMake(0, 0, 120, 33)];
//    logoImage.contentMode = UIViewContentModeScaleAspectFit;
//    
//    [self.navigationItem setTitleView:logoImage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initMyNavigation];
    
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    self.panGestureRecognizer.maximumNumberOfTouches = 1;
    self.panGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.panGestureRecognizer];
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)panGestureRecognizer{
    
    
//        for (UIViewController *controller in self.navigationController.viewControllers) {
//    
//            if (![controller isKindOfClass:@"MainTabBarController"]) {
//    
//            }
//        }
//    
//        if (self.navigationController.viewControllers) {
//            <#statements#>
//        }
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if ([[self.navigationController viewControllers] count] > 1) {
        return YES;
    }
    return NO;
}

-(void)initMyNavigation{
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn addTarget:self action:@selector(moreHandler:) forControlEvents:UIControlEventTouchUpInside];
    moreBtn.frame = CGRectMake(0, 0, 25, 20);
    
    [moreBtn setBackgroundImage:[UIImage imageNamed:@"hambuger"] forState:UIControlStateNormal];
    [moreBtn setBackgroundImage:[UIImage imageNamed:@"hambuger"] forState:UIControlStateSelected];
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc]initWithCustomView:moreBtn];
    UIBarButtonItem *moreSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    moreSpacer.width = 0.0f;
    
    [self.navigationItem setLeftBarButtonItems:@[moreSpacer, moreItem]];
    
    // Build your regular UIBarButtonItem with Custom View
    UIImage *image = [UIImage imageNamed:@"iconMessage"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0,0,image.size.width, image.size.height);
    [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchDown];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    // Make BarButton Item
    UIBarButtonItem *navrightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = navrightButton;
    
    // this is the key entry to change the badgeValue
    
    NSLog(@"bageValue = %@",[[[MyManager shareManager] memberData].notification stringValue]);
    self.navigationItem.rightBarButtonItem.badgeValue = [[[MyManager shareManager] memberData].notification stringValue];
    self.navigationItem.rightBarButtonItem.badgeOriginY = 13;
    
    UIImageView *logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_s"]];
    [logoImage setFrame:CGRectMake(0, 0, 120, 33)];
    logoImage.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.navigationItem setTitleView:logoImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)showVaildMessageWithTitle:(NSString *)title content:(NSString *)message{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    alertController.view.tintColor = DEFAULT_COLOR;
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:confirmAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Open drawer button

-(void)moreHandler:(UIButton *)sender{
    
    ICSDrawerController *tmp = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).drawer;
    
    if (tmp.drawerState == ICSDrawerControllerStateOpen) {
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]).drawer close];
    }
    else if(tmp.drawerState == ICSDrawerControllerStateClosed){
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]).drawer open];
    }
    
}

-(void)buttonPress:(UIButton *)sender{
//    MessageCenterViewController *messageCenterViewController = [[MessageCenterViewController alloc] initWithNibName:@"MessageCenterViewController" bundle:nil];
//    [self.navigationController pushViewController:messageCenterViewController animated:YES];
    
    if (![[MyManager shareManager] loginStatus]) {
        [self showVaildMessageWithTitle:@"尚未登入" content:@"請登入"];
    }
    
    NotificationViewController *notificationViewController = [[NotificationViewController alloc] initWithNibName:@"NotificationViewController" bundle:nil];
    notificationViewController.delegate = self;

    [self.navigationController pushViewController:notificationViewController animated:YES];
    
}

#pragma mark - NotificationViewControllerDelegate

-(void)refreshUserData{
    [MBProgressHUD showHUDAddedTo:PublicAppDelegate.window.rootViewController.view animated:YES];
    [[MyManager shareManager] getUserDataWithJWT:nil WithComplete:^(BOOL status, int statusCode) {
        if (status) {
            self.navigationItem.rightBarButtonItem.badgeValue = [[[MyManager shareManager] memberData].notification stringValue];
        }
        [MBProgressHUD hideHUDForView:PublicAppDelegate.window.rootViewController.view animated:YES];
    }];
}


@end
