//
//  MainTabBarController.h
//  1028
//
//  Created by fg on 2017/4/17.
//  Copyright © 2017年 fg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskViewController.h"
#import "BeaconViewController.h"
#import "BarcodeViewController.h"
#import "../Framework/ICSDrawerController/ICSDrawerController.h"
#import "MemberViewController.h"
#import "ICSNavigationController.h"

@interface MainTabBarController : UITabBarController

@property(strong, nonatomic)TaskViewController *taskViewController;
@property(strong, nonatomic)BeaconViewController *beaconViewController;
@property(strong, nonatomic)BarcodeViewController *barcodeViewController;
@property(strong, nonatomic)MemberViewController *memberViewController;


@property(strong, nonatomic)UINavigationController *taskNavi;
@property(strong, nonatomic)UINavigationController *beaconNavi;
@property(strong, nonatomic)UINavigationController *barcodeNavi;

@property(strong, nonatomic)ICSNavigationController *memberNavi;



@end
