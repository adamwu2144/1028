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
    UIView *blackView;
    UIView *superView;
    UITextField *cellPhoneTextField;
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
    
    [self.confirmBtn.layer setCornerRadius:20.0f];
    [self.resetBtn.layer setCornerRadius:20.0f];
    [self.resetBtn.layer setBorderWidth:1.0f];
    [self.resetBtn.layer setBorderColor:DEFAULT_COLOR.CGColor];
    
    [self.goTaskBtn.layer setCornerRadius:20.0f];
    
    [self.successView setHidden:YES];
    [self textFieldGropHiddenStatus:YES];
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
//            [self showVaildMessageWithTitle:@"註冊成功" content:@"恭喜您成為1028時尚特務" action:1];
            [self.successView setHidden:NO];
        }
        
    } WithFailurBlock:^(NSError *error, int statusCode) {

        [MBProgressHUD hideHUDForView:self.view animated:YES];

        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
        NSString *message = [serializedData objectForKey:@"message"];
//        [self showVaildMessageWithTitle:message content:message action:0];
        self.warningLabel.text = message;
        [self textFieldGropHiddenStatus:NO];
    }];
    
}

- (IBAction)resetBtnClicked:(id)sender {
//    MSAlertController *alertController = [MSAlertController alertControllerWithTitle:@"使用其他電話收認證碼" message:@"手機電話" preferredStyle:MSAlertControllerStyleAlert];
//    alertController.alertBackgroundColor = [UIColor whiteColor];
//    alertController.separatorColor = DEFAULT_GARY_COLOR;
//    alertController.alpha = 0.3f;
//    
//    MSAlertAction *action = [MSAlertAction actionWithTitle:@"取消" style:MSAlertActionStyleCancel handler:^(MSAlertAction *action) {
//        NSLog(@"Cancel action tapped %@", action);
//    }];
//    
//    action.normalColor = [UIColor whiteColor];
//    action.highlightedColor = [UIColor whiteColor];
//    action.titleColor = DEFAULT_COLOR;
//    
//    [alertController addAction:action];
//    
//    MSAlertAction *action2 = [MSAlertAction actionWithTitle:@"確定" style:MSAlertActionStyleDestructive handler:^(MSAlertAction *action) {
//        NSLog(@"Destructive action tapped %@", action);
//        
//        NSArray *textFieldArrays = alertController.textFields;
//        
//        for (UITextField *tmpTextField in textFieldArrays) {
//            if (tmpTextField.tag == TEXTFIELD_TAG + 1) {
//                if (![self NSStringIsValidMobile:tmpTextField.text]) {
//                    double delayInSeconds = 0.5;
//                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//                    
//                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                        [self showVaildMessageWithTitle:@"手機號碼格式錯誤" content:@"請填寫正確的電話號碼"action:0];
//                    });
//                }
//                else{
//                    
//                    NSMutableDictionary *changeParam = [[NSMutableDictionary alloc] init];
//                    
//                    [changeParam setValue:tmpTextField.text forKey:@"mobile"];
//                    
//                    NSParameterAssert(changeParam);
//                    
//                    [[MyManager shareManager] requestWithMethod:PATCH WithPath:[ApiBuilder getUpdateUserData] WithParams:changeParam WithSuccessBlock:^(NSDictionary *dic) {
//                        
//                        [[MyManager shareManager] setAttestationTime:tmpTextField.text];
//                        [self showVaildMessageWithTitle:@"成功" content:@"請填入新的簡訊認證碼" action:0];
//                    } WithFailurBlock:^(NSError *error, int statusCode) {
//                        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
//                        NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
//                        NSString *message = [serializedData objectForKey:@"message"];
//                        NSLog(@"message = %@",message);
//                    }];
//                }
//            }
//        }
//    }];
//    
//    action2.normalColor = [UIColor whiteColor];
//    action2.highlightedColor = [UIColor whiteColor];
//    action2.titleColor = DEFAULT_COLOR;
//    
//    [alertController addAction:action2];
//    
//    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//        [textField setTag:TEXTFIELD_TAG+1];
//        textField.placeholder = @"請輸入正確的手機號碼";
//    }];
//    
//    [self presentViewController:alertController animated:YES completion:nil];
    
    blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    blackView.layer.masksToBounds = YES;
    [blackView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.8f]];
    superView = [[UIView alloc] initWithFrame:CGRectMake(15, 115, SCREEN_WIDTH-15*2, 206)];
    [superView setBackgroundColor:[UIColor whiteColor]];
    [superView.layer setCornerRadius:14.5f];

    UIView *cancelView = [[UIView alloc] initWithFrame:CGRectMake(0,0, superView.frame.size.width, 30)];
//    [cancelView setClipsToBounds:YES];
    cancelView = [self roundCornersOnView:cancelView onTopLeft:YES topRight:YES bottomLeft:NO bottomRight:NO radius:14.5f];
    [cancelView setBackgroundColor:DEFAULT_COLOR];
    
    UIImage *image = [UIImage imageNamed:@"cancelcombinedShape"];
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(cancelView.frame.size.width*0.92, (cancelView.frame.size.height-image.size.height)/2, image.size.width, image.size.height)];
    [cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setImage:image forState:UIControlStateNormal];
    
    UILabel *cellPhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 45, 100, 16)];
    [cellPhoneLabel setText:@"手機電話"];
    [cellPhoneLabel setFont:[UIFont systemFontOfSize:16.0f]];
    
    cellPhoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(cellPhoneLabel.frame)+5, superView.frame.size.width-15*2, 40)];
    [cellPhoneTextField setPlaceholder:@"請填寫正確電話（ ex.0912345678 ）"];
    [cellPhoneTextField.layer setBorderColor:DEFAULT_GARY_COLOR.CGColor];
    [cellPhoneTextField.layer setBorderWidth:0.5f];
    cellPhoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    [cellPhoneTextField becomeFirstResponder];
    
    UIButton *confrimBtn = [[UIButton alloc] initWithFrame:CGRectMake(cellPhoneTextField.frame.origin.x, CGRectGetMaxY(cellPhoneTextField.frame)+30, cellPhoneTextField.frame.size.width, cellPhoneTextField.frame.size.height)];
    [confrimBtn setTitle:@"送出" forState:UIControlStateNormal];
    [confrimBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confrimBtn setBackgroundColor:DEFAULT_COLOR];
    UIFont *font = [UIFont boldSystemFontOfSize:18.0f];
    [confrimBtn.titleLabel setFont:font];
    [confrimBtn addTarget:self action:@selector(reconfirmBrnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [confrimBtn.layer setCornerRadius:20.0f];
    
    [cancelView addSubview:cancelBtn];
    [superView addSubview:cancelView];
    [superView addSubview:cellPhoneLabel];
    [superView addSubview:cellPhoneTextField];
    [superView addSubview:confrimBtn];
    [self.view addSubview:blackView];
    [self.view addSubview:superView];

}

-(void)cancelBtnClicked:(id)sender{
    [blackView removeFromSuperview];
    [superView removeFromSuperview];
}

-(void)reconfirmBrnClicked:(id)sender{
    if(![self NSStringIsValidMobile:cellPhoneTextField.text]){
        [self showVaildMessageWithTitle:@"手機號碼格式錯誤" content:@"請填寫正確的電話號碼"action:0];
    }
    else{
        NSMutableDictionary *changeParam = [[NSMutableDictionary alloc] init];
        
        [changeParam setValue:cellPhoneTextField.text forKey:@"mobile"];
        
        NSParameterAssert(changeParam);
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        [[MyManager shareManager] requestWithMethod:PATCH WithPath:[ApiBuilder getUpdateUserData] WithParams:changeParam WithSuccessBlock:^(NSDictionary *dic) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [[MyManager shareManager] setAttestationTime:cellPhoneTextField.text];
            [self cancelBtnClicked:nil];
            [self showVaildMessageWithTitle:@"成功" content:@"請填入新的簡訊認證碼" action:0];
        } WithFailurBlock:^(NSError *error, int statusCode) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
            NSString *message = [serializedData objectForKey:@"message"];
            [self showVaildMessageWithTitle:@"失敗" content:message action:0];

        }];

    }
}

- (IBAction)resendBtnClicked:(id)sender {
    
    if (![[MyManager shareManager] getAttestationTime]) {
        [self showVaildMessageWithTitle:@"提醒" content:@"您的點擊過於頻繁，請過五分鐘後再次點選" action:0];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[MyManager shareManager] addJWT];
    
    [[MyManager shareManager] requestWithMethod:POST WithPath:[ApiBuilder getResendSMSCodeToMobile] WithParams:nil WithSuccessBlock:^(NSDictionary *dic) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (dic) {
            [[MyManager shareManager] setAttestationTime:@""];
            [self showVaildMessageWithTitle:@"成功" content:@"請填入新的簡訊認證碼" action:0];
        }
    } WithFailurBlock:^(NSError *error, int statusCode) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
        NSString *message = [serializedData objectForKey:@"message"];
        [self showVaildMessageWithTitle:@"失敗" content:message action:0];

    }];
}

- (IBAction)goTaskBtnClicked:(id)sender {
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

-(void)showVaildMessageWithTitle:(NSString *)title content:(NSString *)message action:(int)aAction{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    alertController.view.tintColor = DEFAULT_COLOR;
    
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

-(void)textFieldGropHiddenStatus:(BOOL)status{
    
    [self.warningImageView setHidden:status];
    [self.warningLabel setHidden:status];
    
    if (status){
        [self.AttestationTextField.layer setBorderColor:[UIColor whiteColor].CGColor];
        [self.AttestationTextField.layer setBorderWidth:1.0f];
    }
    else{
        [self.AttestationTextField.layer setBorderColor:[UIColor redColor].CGColor];
        [self.AttestationTextField.layer setBorderWidth:1.0f];
    }
}

- (UIView *)roundCornersOnView:(UIView *)view onTopLeft:(BOOL)tl topRight:(BOOL)tr bottomLeft:(BOOL)bl bottomRight:(BOOL)br radius:(float)radius
{
    if (tl || tr || bl || br) {
        UIRectCorner corner = 0;
        if (tl) corner = corner | UIRectCornerTopLeft;
        if (tr) corner = corner | UIRectCornerTopRight;
        if (bl) corner = corner | UIRectCornerBottomLeft;
        if (br) corner = corner | UIRectCornerBottomRight;
        
        UIView *roundedView = view;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:roundedView.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = roundedView.bounds;
        maskLayer.path = maskPath.CGPath;
        roundedView.layer.mask = maskLayer;
        return roundedView;
    }
    return view;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self textFieldGropHiddenStatus:YES];
}

@end
