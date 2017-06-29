//
//  MainTabBarController.m
//  1028
//
//  Created by fg on 2017/4/17.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "MainTabBarController.h"
#import "AppDelegate.h"


@interface MainTabBarController ()<UITabBarControllerDelegate>{
    BOOL drawerOpenStatus;
}

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    drawerOpenStatus = NO;
    
    // Do any additional setup after loading the view from its nib.
    self.taskViewController = [[TaskViewController alloc] init];
    self.taskNavi = [[UINavigationController alloc] initWithRootViewController:self.taskViewController];
    self.taskNavi.tabBarItem.title = @"任務間";
    self.taskNavi.tabBarItem.image = [[UIImage imageNamed:@"home"]  imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    self.beaconViewController = [[BeaconViewController alloc] init];
    self.beaconNavi = [[UINavigationController alloc] initWithRootViewController:self.beaconViewController];
    self.beaconNavi.tabBarItem.title = @"化一下";
    self.beaconNavi.tabBarItem.image = [[UIImage imageNamed:@"iconShake"]  imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    self.barcodeViewController = [[BarcodeViewController alloc] init];
    self.barcodeNavi = [[UINavigationController alloc] initWithRootViewController:self.barcodeViewController];
    self.barcodeNavi.tabBarItem.title = @"刷一下";
    self.barcodeNavi.tabBarItem.image = [[UIImage imageNamed:@"iconQrW"]  imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    self.memberViewController = [[MemberViewController alloc] init];
    self.memberNavi = [[ICSNavigationController alloc] initWithRootViewController:self.memberViewController];
    self.memberNavi.tabBarItem.title = @"我的機密";
    self.memberNavi.tabBarItem.image = [[UIImage imageNamed:@"member"]  imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    [self setViewControllers:@[self.taskNavi, self.beaconNavi, self.barcodeNavi,self.memberNavi]];
    
    self.tabBar.translucent = NO;
    
    NSLog(@"self.tabar = %@",NSStringFromCGRect(self.tabBar.frame));
    
    [self setDelegate:self];
    
//    self.tabBar.unselectedItemTintColor = [UIColor blackColor];
    self.tabBar.tintColor = [UIColor whiteColor];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    UITabBar *tabBar = self.tabBar;
    CGSize imgSize = CGSizeMake(tabBar.frame.size.width/tabBar.items.count,tabBar.frame.size.height);
    
    UIGraphicsBeginImageContextWithOptions(imgSize, NO, 0);
    UIBezierPath* p =
    [UIBezierPath bezierPathWithRect:CGRectMake(0,0,imgSize.width,imgSize.height)];
    [[UIColor colorWithRed:240.0/255.0 green:145.0/255.0 blue:146.0/255.0 alpha:1.0f] setFill];
    [p fill];
    UIImage* finalImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
 
    [tabBar setSelectionIndicatorImage:finalImg];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    
    switch (self.selectedIndex) {
//        case 0:{
//            TaskViewController *tmp = (TaskViewController *)[[self.taskNavi viewControllers] firstObject];
//            [tmp setData];
//        }
//            break;
//        case 1:{
//            BeaconViewController *tmp = (BeaconViewController *)[[self.beaconNavi viewControllers] firstObject];
//            if ([tmp isViewLoaded]) {
////                [tmp getActivity];
//            }
//        }
//            break;
//        case 2:{
//            BarcodeViewController *tmp = (BarcodeViewController *)[[self.barcodeNavi viewControllers] firstObject];
//            if ([tmp isViewLoaded]) {
////                [tmp getQRActivity];
//            }
//        }
//            break;
        case 3:{
            MemberViewController *tmp = (MemberViewController *)[[self.memberNavi viewControllers] firstObject];
            if ([tmp isViewLoaded]) {
                [tmp showLoginView];
            }
        }
            break;
        default:
            break;
    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
