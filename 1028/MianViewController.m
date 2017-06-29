//
//  MianViewController.m
//  1028
//
//  Created by fg on 2017/4/17.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "MianViewController.h"
#import "../Framework/AFNetworking/AFHTTPSessionManager.h"
#import "MyManager.h"
#import "AppDelegate.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface MianViewController (){
    BOOL drawerStatus;
}
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height;
@property (strong, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
@property (strong, nonatomic) FBSDKLoginManager *loginManager;


@end

@implementation MianViewController

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    CGSize sizeThatFitsTextView = [_mytextView sizeThatFits:CGSizeMake(_mytextView.frame.size.width, MAXFLOAT)];
    _height.constant = sizeThatFitsTextView.height;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
//    UIViewController *tmp = [[UIViewController alloc] init];
//    tmp.view.frame = self.view.frame;
//    [tmp.view setBackgroundColor:[UIColor purpleColor]];
//    [self.navigationController presentViewController:tmp animated:NO completion:^{
//        
//    }];
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn addTarget:self action:@selector(moreHandler:) forControlEvents:UIControlEventTouchUpInside];
    moreBtn.frame = CGRectMake(0, 0, 40, 44);
    
    [moreBtn setBackgroundImage:[UIImage imageNamed:@"text-align-justify-7"] forState:UIControlStateNormal];
    [moreBtn setBackgroundImage:[UIImage imageNamed:@"text-align-justify-7"] forState:UIControlStateSelected];
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc]initWithCustomView:moreBtn];
    UIBarButtonItem *moreSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    moreSpacer.width = -10.0f;
    [self.navigationItem setLeftBarButtonItems:@[moreSpacer, moreItem]];
    
    self.view.backgroundColor = [UIColor yellowColor];
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    _mytextView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    _mytextView.text = @"有種悲情，叫相信女友，卻從電視新聞上才發現自己戴了綠帽。一名網友在網站Dcard https://www.dcard.tw/f/relationship/p/226219429?utm_source=dcard_fb&utm_medium=post&utm_campaign=201704211100_fbpost_relationship發文表示，自己一直很相信女友，即使知道女友跟男性朋友交情好，也不會阻止對方出去或吃醋，直到日前在看電視新聞時，突然看到一名男生受訪時旁邊牽著一個女生的手，赫然發現那個女生竟是自己的女友，這讓他晴天霹靂，向女友宣告分手。事後女友坦承劈腿，但表示仍愛她，希望挽回，但男網友選擇放手。\r網友支持「分手吧！這樣的女生不要了、「別心軟，讓自己好過一點吧」，還有網友說「太剛好被你看到新聞了吧！根本天意。」但也有網友認為原PO將過程放上網「真的怨念很重！」（即時新聞中心／綜合報導）. www.facebook.com";
    _mytextView.dataDetectorTypes = UIDataDetectorTypeAll;
    
//    [_mytextView sizeToFit];

//    _mytextView.backgroundColor = [UIColor clearColor];
//    _mytextView.text = @"\r\n我的手机号不是： 13888888888 \r\n\r\n"
//    "我的博客刚刚在线网址： www.xxxxxx.com \r\n\r\n"
//    "我的邮箱： worldligang@163.com \r\n\r\n";
 
    
    if ([FBSDKAccessToken currentAccessToken]) {
        NSLog(@"YES");
    }
    else{
        NSLog(@"NO");
    }
    
//    self.loginButton.loginBehavior = FBSDKLoginBehaviorBrowser;
//    self.loginButton.readPermissions = @[@"public_profile",@"email"];
//    self.loginButton.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)loginBtnClicked:(id)sender{
//    self.loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//    UINavigationController *loginNavi = [[UINavigationController alloc] initWithRootViewController:self.loginViewController];
//    [self presentViewController:loginNavi animated:YES completion:nil];
//}

- (void)  loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error{
    if (error) {
        NSLog(@"error");
    }
    else if([result isCancelled]){
        
    }
    else{
        NSLog(@"token = %@",result.token.tokenString);
        [self loginProcess:result.token.tokenString];
        
//        [self getFaceBookProfileInfos];
    }
    if ([result.grantedPermissions containsObject:@"email"]) {
        NSLog(@"getEmail");
    }
    else{
        NSLog(@"not get email");
    }
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{

}


-(void)getFaceBookProfileInfos{
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"/me?fields=id,name,cover,email,picture.type(large)" parameters:nil];
    
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

    NSString *coverURL = @"";
    
    if ([[data allKeys] containsObject:@"cover"]) {
        NSDictionary *tmp = [data objectForKey:@"cover"];
        if ([[tmp allKeys] containsObject:@"source"]) {
            coverURL = [tmp objectForKey:@"source"];
        }
    }
    
    NSMutableDictionary *userData = [[NSMutableDictionary alloc] init];
    [userData setValue:[data objectForKey:@"email"] forKey:@"email"];
    [userData setValue:[data objectForKey:@"name"] forKey:@"nickname"];
    [userData setValue:[data objectForKey:@"id"] forKey:@"facebook_id"];
    [userData setValue:coverURL forKey:@"cover"];
    
    NSLog(@"userdata = %@",userData);
    
    NSURL *url = [[FBSDKProfile currentProfile] imageURLForPictureMode:FBSDKProfilePictureModeNormal size:CGSizeMake(1080, 1080)];
    NSLog(@"oioioio = %@",[url absoluteString]);
    
}

-(void)loginProcess:(NSString *)tokenString{
    
    NSDictionary *parameters = @{@"token":tokenString};
    
    [[MyManager shareManager] requestWithMethod:POST WithPath:[ApiBuilder getLogin] WithParams:parameters WithSuccessBlock:^(NSDictionary *dic) {
        NSLog(@"responseObject = %@",dic);
    } WithFailurBlock:^(NSError *error,int statusCode) {
        
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
        NSString *message = [serializedData objectForKey:@"message"];
        
        if(statusCode == 422){
            //TODO:
        }
        
    }];
}

#pragma mark - Configuring the view’s layout behavior

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - ICSDrawerControllerPresenting

- (void)drawerControllerWillOpen:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = NO;
}

- (void)drawerControllerDidClose:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = YES;
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

@end
