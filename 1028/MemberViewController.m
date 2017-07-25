//
//  MemberViewController.m
//  1028
//
//  Created by fg on 2017/6/1.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "MemberViewController.h"
#import "MemberSettingViewController.h"
#import "GiftDetailViewController.h"
#import "LoginViewController.h"
#import "MyManager.h"
#import "MemberRegisterData.h"
#import "UIBarButtonItem+Badge.h"
#import "MCScannerViewController.h"

@interface MemberViewController (){
}

@end

@implementation MemberViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"viewDidLoad");
    
//    [self.DetailView setViewFirstColor:[UIColor colorWithRed:112.0/255.0 green:184.0/255.0 blue:208.0/255.0 alpha:1.0f] secondColor:[UIColor colorWithRed:160.0/255.0 green:218.0/255.0 blue:237.0/255.0 alpha:1.0]];
//    [self.numberView setViewFirstColor:[UIColor colorWithRed:248.0/255.0 green:147.0/255.0 blue:154.0/255.0 alpha:1.0f] secondColor:[UIColor colorWithRed:160.0/255.0 green:218.0/255.0 blue:237.0/255.0 alpha:1.0]];
//    [self.settingView setViewFirstColor:[UIColor colorWithRed:255.0/255.0 green:234.0/255.0 blue:160.0/255.0 alpha:1.0f] secondColor:[UIColor colorWithRed:239.0/255.0 green:236.0/255.0 blue:188.0/255.0 alpha:1.0]];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewClicked:)];
    
    [self.view addGestureRecognizer:tapGestureRecognizer];

//    [self initNavi];
    [self showLoginView];
    
}

-(void)initNavi{
    
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
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:240.0/255.0 green:145.0/255.0 blue:146.0/255.0 alpha:1.0f];
    UIImage *logoImage = [UIImage imageNamed:@"logo_s"];
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:logoImage];
    
    [self.navigationItem setTitleView:logoImageView];
}

-(void)tapViewClicked:(UITapGestureRecognizer *)gesture{
    CGPoint aPoint = [gesture locationInView:self.view];

    ICSDrawerController *tmp = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).drawer;
    
    if(CGRectContainsPoint(self.DetailView.frame,aPoint)){
        if (tmp.drawerState == ICSDrawerControllerStateOpen) {
            [((AppDelegate *)[[UIApplication sharedApplication] delegate]).drawer close];
            
            double delayInSeconds = 0.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                GiftDetailViewController *giftDetailViewController = [[GiftDetailViewController alloc] initWithNibName:@"GiftDetailViewController" bundle:nil];
                [self.navigationController pushViewController:giftDetailViewController animated:YES];
                
            });
        }else if(tmp.drawerState == ICSDrawerControllerStateClosed){
            GiftDetailViewController *giftDetailViewController = [[GiftDetailViewController alloc] initWithNibName:@"GiftDetailViewController" bundle:nil];
            [self.navigationController pushViewController:giftDetailViewController animated:YES];
        }

    }
    else if(CGRectContainsPoint(self.numberView.frame,aPoint)){
//        if (tmp.drawerState == ICSDrawerControllerStateOpen) {
//            [((AppDelegate *)[[UIApplication sharedApplication] delegate]).drawer close];
//            
//            double delayInSeconds = 0.5;
//            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//            
//            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                MCScannerViewController *memberSettingViewController = [[MCScannerViewController alloc] initWithNibName:@"MCScannerViewController" bundle:nil];
//                [self.navigationController pushViewController:memberSettingViewController animated:YES];
////                MemberSettingViewController *memberSettingViewController = [[MemberSettingViewController alloc] initWithNibName:@"MemberSettingViewController" bundle:nil];
////                [self.navigationController pushViewController:memberSettingViewController animated:YES];
//            });
//        }else if(tmp.drawerState == ICSDrawerControllerStateClosed){
////            MemberSettingViewController *memberSettingViewController = [[MemberSettingViewController alloc] initWithNibName:@"MemberSettingViewController" bundle:nil];
////            [self.navigationController pushViewController:memberSettingViewController animated:YES];
//            MCScannerViewController *memberSettingViewController = [[MCScannerViewController alloc] initWithNibName:@"MCScannerViewController" bundle:nil];
//            [self.navigationController pushViewController:memberSettingViewController animated:YES];
//
//        }
        if (tmp.drawerState == ICSDrawerControllerStateOpen) {
            [((AppDelegate *)[[UIApplication sharedApplication] delegate]).drawer close];
            
            double delayInSeconds = 0.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                MemberSettingViewController *memberSettingViewController = [[MemberSettingViewController alloc] initWithNibName:@"MemberSettingViewController" bundle:nil];
                [self.navigationController pushViewController:memberSettingViewController animated:YES];
                
            });
        }else if(tmp.drawerState == ICSDrawerControllerStateClosed){
            MemberSettingViewController *memberSettingViewController = [[MemberSettingViewController alloc] initWithNibName:@"MemberSettingViewController" bundle:nil];
            [self.navigationController pushViewController:memberSettingViewController animated:YES];
        }
    }
    else if(CGRectContainsPoint(self.settingView.frame,aPoint)){
        
        if (tmp.drawerState == ICSDrawerControllerStateOpen) {
            [((AppDelegate *)[[UIApplication sharedApplication] delegate]).drawer close];
                
            double delayInSeconds = 0.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                MemberSettingViewController *memberSettingViewController = [[MemberSettingViewController alloc] initWithNibName:@"MemberSettingViewController" bundle:nil];
                [self.navigationController pushViewController:memberSettingViewController animated:YES];
                    
            });
        }else if(tmp.drawerState == ICSDrawerControllerStateClosed){
            MemberSettingViewController *memberSettingViewController = [[MemberSettingViewController alloc] initWithNibName:@"MemberSettingViewController" bundle:nil];
            [self.navigationController pushViewController:memberSettingViewController animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    NSLog(@"viewWillLayoutSubviews");
//    [self.DetailView setViewColor];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    NSLog(@"viewDidLayoutSubviews");
//    [self.DetailView setViewColor];

}

-(void)showLoginView{
    BOOL status = [[MyManager shareManager] loginStatus];
    
    if (!status) {
        LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        UINavigationController *loginNavi = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        [self presentViewController:loginNavi animated:YES completion:nil];
    }

}
@end
