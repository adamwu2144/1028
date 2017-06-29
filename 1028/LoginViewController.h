//
//  LoginViewController.h
//  1028
//
//  Created by fg on 2017/5/24.
//  Copyright © 2017年 fg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *fbLoginButton;
@property (strong, nonatomic) IBOutlet UIButton *guestLoginButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
- (IBAction)fbLoginButtonClicked:(id)sender;
- (IBAction)guestLoginButtonClicked:(id)sender;


@end
