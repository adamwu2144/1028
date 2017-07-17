//
//  AppDelegate.h
//  1028
//
//  Created by fg on 2017/4/17.
//  Copyright © 2017年 fg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTabBarController.h"
#import "ProductViewController.h"
#import "JPCollectionViewController.h"
#import "UserRegisterViewController.h"
#import "LoginViewController.h"
#import "../Framework/ICSDrawerController/ICSDrawerController.h"
#import "RegisterViewController.h"
#import "AttestationCheckViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainTabBarController *mainTabBarController;
@property (strong, nonatomic)ICSDrawerController *drawer;
//@property (strong, nonatomic) ProductViewController *mainTabBarController;
//@property (strong, nonatomic) JPCollectionViewController *mainTabBarController;
//@property (strong, nonatomic) UserRegisterViewController *mainTabBarController;
//@property (strong, nonatomic) LoginViewController *mainTabBarController;
@property (strong, nonatomic) AttestationCheckViewController *attestationCheckViewController;



@end

