//
//  LoginViewController.m
//  1028
//
//  Created by fg on 2017/5/24.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "../Framework/AFNetworking/AFHTTPSessionManager.h"
#import "RegisterViewController.h"
#import "AttestationCheckViewController.h"
#import "MBProgressHUD.h"
#import "MemberRulesViewController.h"

@interface LoginViewController (){
    NSString *tokenString;
    NSString *fbID;
}

@end

@implementation LoginViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButtonItem];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self.titleLabel setText:@"現在展開\n美無極限時尚任務"];
    [self.fbLoginButton.layer setCornerRadius:20];
    [self.guestLoginButton.layer setCornerRadius:20];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:240.0/255.0 green:145.0/255.0 blue:146.0/255.0 alpha:1.0f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)fbLoginButtonClicked:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];

//    login.loginBehavior = FBSDKLoginBehaviorWeb;
    [login logOut];

    [login
     logInWithReadPermissions: @[@"public_profile",@"email"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
             NSLog(@"error = %@",[error localizedDescription]);
             [MBProgressHUD hideHUDForView:self.view animated:YES];
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
             [MBProgressHUD hideHUDForView:self.view animated:YES];
         } else {
             NSLog(@"Logged in");
             tokenString = result.token.tokenString;
            [self getFaceBookProfileInfos];
         }
     }];

}

- (IBAction)guestLoginButtonClicked:(id)sender {
    [PublicAppDelegate.mainTabBarController.taskViewController setData];
    [PublicAppDelegate.mainTabBarController setSelectedIndex:0];

    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];

}

-(void)loginProcess:(NSString *)userTokenString{
    
    NSDictionary *parameters = @{@"token":userTokenString};
    
    [[MyManager shareManager] saveUserFBTokenToKeyChain:userTokenString];
    
    [[MyManager shareManager] requestWithMethod:POST WithPath:[ApiBuilder getLogin] WithParams:parameters WithSuccessBlock:^(NSDictionary *dic) {
        
        if (dic) {
            [[MyManager shareManager] getUserDataWithJWT:dic WithComplete:^(BOOL status, int code) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (status) {
                    if([[dic objectForKey:@"code"] intValue] == 202){
                        AttestationCheckViewController *attestationCheckViewController = [[AttestationCheckViewController alloc] initWithNibName:@"AttestationCheckViewController" bundle:nil];
                        [self.navigationController pushViewController:attestationCheckViewController animated:YES];
                    }
                    else{
                        
                        [PublicAppDelegate.mainTabBarController.taskViewController setData];
                        
                        [[MyManager shareManager] refreshALLViewData];
                        
                        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    }
                }
            }];
        }
        
    } WithFailurBlock:^(NSError *error,int statusCode) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
        NSString *message = [serializedData objectForKey:@"message"];
        int code = [[serializedData objectForKey:@"code"] intValue];
        
        if(code == 201){
            //TODO:
            MemberRulesViewController *memberRulesViewController = [[MemberRulesViewController alloc] initWithNibName:@"MemberRulesViewController" bundle:nil fbid:fbID];
            [self.navigationController pushViewController:memberRulesViewController animated:YES];
//            RegisterViewController *registerViewController = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil fbid:fbID];
//            [self.navigationController pushViewController:registerViewController animated:YES];
        }
        
    }];
}

-(void)getFaceBookProfileInfos{
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"/me?fields=id,name,cover,email,picture.width(720).height(720)" parameters:nil];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        NSLog(@"result = %@",result);
        if (error) {
            NSLog(@"Get Profile ERROR");
        }
        else{
            [self processFBData:result];
        }
    }];
}

-(void)processFBData:(id)data{
    
//    NSString *coverURL = @"";
//    
//    if ([[data allKeys] containsObject:@"cover"]) {
//        NSDictionary *tmp = [data objectForKey:@"cover"];
//        if ([[tmp allKeys] containsObject:@"source"]) {
//            coverURL = [tmp objectForKey:@"source"];
//        }
//    }
//    
//    NSMutableDictionary *userData = [[NSMutableDictionary alloc] init];
//    [userData setValue:[data objectForKey:@"email"] forKey:@"email"];
//    [userData setValue:[data objectForKey:@"name"] forKey:@"nickname"];
//    [userData setValue:[data objectForKey:@"id"] forKey:@"facebook_id"];
//    [userData setValue:coverURL forKey:@"cover"];
    
    fbID = [data objectForKey:@"id"];

    [self loginProcess:tokenString];
}


@end
