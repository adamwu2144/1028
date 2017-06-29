//
//  AttestationCheckViewController.m
//  1028
//
//  Created by fg on 2017/5/31.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "AttestationCheckViewController.h"
#import "MyManager.h"
#import "ApiBuilder.h"
#import "../Framework/AFNetworking/AFHTTPSessionManager.h"
#import "MemberRegisterData.h"
#import "MSAlertController.h"
#import "MBProgressHUD.h"

#define TEXTFIELD_TAG 1000

@interface AttestationCheckViewController (){
    NSTimer *checkTimer;
}

@end

@implementation AttestationCheckViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(!self.navigationItem.titleView){
        UIImageView *logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_s"]];
        [logoImage setFrame:CGRectMake(0, 0, 120, 33)];
        logoImage.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.navigationItem setTitleView:logoImage];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.AttestationTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.navigationController.navigationBarHidden = NO;
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem=newBackButton;
    
    [self setTimer];
}

-(void)back:(UIBarButtonItem *)sender
{

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

- (IBAction)ConfirmBtnClicked:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.AttestationTextField resignFirstResponder];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    [param setValue:self.AttestationTextField.text forKey:@"sms_verification_code"];
    
    [[MyManager shareManager] addJWT];
   
    [[MyManager shareManager] requestWithMethod:POST WithPath:[ApiBuilder getSMSVerify] WithParams:param WithSuccessBlock:^(NSDictionary *dic) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if ([[dic objectForKey:@"code"] intValue] == 200) {
            [self showVaildMessageWithTitle:@"註冊成功" content:@"恭喜您成為1028時尚特務" action:1];
        }
        
    } WithFailurBlock:^(NSError *error, int statusCode) {

        [MBProgressHUD hideHUDForView:self.view animated:YES];

        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
        NSString *message = [serializedData objectForKey:@"message"];
        [self showVaildMessageWithTitle:message content:message action:0];
    }];
    
}

- (IBAction)resetBtnClicked:(id)sender {
    MSAlertController *alertController = [MSAlertController alertControllerWithTitle:@"使用其他電話收認證碼" message:@"手機電話" preferredStyle:MSAlertControllerStyleAlert];
    alertController.alertBackgroundColor = [UIColor whiteColor];
    alertController.separatorColor = DEFAULT_GARY_COLOR;
    alertController.alpha = 0.3f;
    
    MSAlertAction *action = [MSAlertAction actionWithTitle:@"取消" style:MSAlertActionStyleCancel handler:^(MSAlertAction *action) {
        NSLog(@"Cancel action tapped %@", action);
    }];
    
    action.normalColor = [UIColor whiteColor];
    action.highlightedColor = [UIColor whiteColor];
    action.titleColor = DEFAULT_COLOR;
    
    [alertController addAction:action];
    
    MSAlertAction *action2 = [MSAlertAction actionWithTitle:@"確定" style:MSAlertActionStyleDestructive handler:^(MSAlertAction *action) {
        NSLog(@"Destructive action tapped %@", action);
        
        NSArray *textFieldArrays = alertController.textFields;
        
        for (UITextField *tmpTextField in textFieldArrays) {
            if (tmpTextField.tag == TEXTFIELD_TAG + 1) {
                if (![self NSStringIsValidMobile:tmpTextField.text]) {
                    double delayInSeconds = 0.5;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                    
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [self showVaildMessageWithTitle:@"手機號碼格式錯誤" content:@"請填寫正確的電話號碼"action:0];
                    });
                }
                else{
                    
                    NSMutableDictionary *changeParam = [[NSMutableDictionary alloc] init];
                    
                    [changeParam setValue:tmpTextField.text forKey:@"mobile"];
                    
                    NSParameterAssert(changeParam);
                    
                    [[MyManager shareManager] requestWithMethod:PATCH WithPath:[ApiBuilder getUpdateUserData] WithParams:changeParam WithSuccessBlock:^(NSDictionary *dic) {
                        
                        [[MyManager shareManager] setAttestationTime:tmpTextField.text];
                        [self showVaildMessageWithTitle:@"成功" content:@"請填入新的簡訊認證碼" action:0];
                    } WithFailurBlock:^(NSError *error, int statusCode) {
                        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                        NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
                        NSString *message = [serializedData objectForKey:@"message"];
                        NSLog(@"message = %@",message);
                    }];
                }
            }
        }
    }];
    
    action2.normalColor = [UIColor whiteColor];
    action2.highlightedColor = [UIColor whiteColor];
    action2.titleColor = DEFAULT_COLOR;
    
    [alertController addAction:action2];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        [textField setTag:TEXTFIELD_TAG+1];
        textField.placeholder = @"請輸入正確的手機號碼";
    }];
    
    [self presentViewController:alertController animated:YES completion:nil];

}

- (IBAction)resendBtnClicked:(id)sender {
    
    
    if (![[MyManager shareManager] getAttestationTime]) {
        [self showVaildMessageWithTitle:@"提醒" content:@"您的點擊過於頻繁，請過五分鐘後再次點選" action:0];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[MyManager shareManager] addJWT];
    
    [[MyManager shareManager] requestWithMethod:POST WithPath:[ApiBuilder getResendSMSCodeToMobile] WithParams:nil WithSuccessBlock:^(NSDictionary *dic) {
        if (dic) {
            [self showVaildMessageWithTitle:@"成功" content:@"請填入新的簡訊認證碼" action:0];
        }
    } WithFailurBlock:^(NSError *error, int statusCode) {
        
    }];
}

-(void)showVaildMessageWithTitle:(NSString *)title content:(NSString *)message action:(int)aAction{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    
//    alertController.view.tintColor = [UIColor redColor];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        switch (aAction) {
            case 0:
                break;
            case 1:{
                [self stopTimer];
                [self dismissViewControllerAnimated:YES completion:^{
                    [[MyManager shareManager] getUserDataWithJWT:nil WithComplete:^(BOOL status, int code) {
                        if(status){
                            TaskViewController *tmp = (TaskViewController *)PublicAppDelegate.mainTabBarController.taskNavi.viewControllers.firstObject;
                            [tmp setData];
                        }
                    }];
                }];
            }
                break;
            case 2:{
            }
                break;
            default:
                break;
        }
    }];
    
    [alertController addAction:confirmAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(BOOL) NSStringIsValidMobile:(NSString *)checkString
{
    NSString *stricterFilterString = @"^[0]+[9]+[0-9]{2,8}$";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    return [mobileTest evaluateWithObject:checkString];
}

//+(BOOL)getAttestationTime{
//    
//    NSDate *lastAttestationTime = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ATTESTATION_TIME];
//    
//    if(lastAttestationTime == nil) {
//        return YES;
//    }
//    else{
//        NSTimeInterval now = [[NSDate date] timeIntervalSinceDate:lastAttestationTime];
//        long nowDate = (long)now;
//        
//        if(nowDate >= USER_ATTESTATION_TIMEOUT-1){
//            return YES;
//        }
//        else{
//            return NO;
//        }
//    }
//}

-(void)setTimer{
    checkTimer =[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkRestBtnStatus) userInfo:nil repeats:YES];
}

-(void)pauseTimer{
    [checkTimer setFireDate:[NSDate distantFuture]];
}

-(void)replyTimer{
    [checkTimer setFireDate:[NSDate date]];
}

-(void)stopTimer{
    [checkTimer invalidate];
    checkTimer = nil;
}

-(void)checkRestBtnStatus{
    if ([[MyManager shareManager] getAttestationTime]) {
//        self.resetBtn.userInteractionEnabled = YES;
        [self.resendBtn setTitleColor:DEFAULT_COLOR forState:UIControlStateNormal];
    }
    else{
//        self.resetBtn.userInteractionEnabled = NO;
        [self.resendBtn setTitleColor:DEFAULT_GARY_COLOR forState:UIControlStateNormal];
    }
}

@end
