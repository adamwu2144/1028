//
//  RegisterViewController.m
//  1028
//
//  Created by fg on 2017/5/24.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "RegisterViewController.h"
#import "NSMutableAttributedString+SetAsLinkSupport.h"
#import "MemberRegisterData.h"
#import "MBProgressHUD.h"
#import "AddressClass.h"
#import "RegionClass.h"
#import "../Framework/AFNetworking/AFHTTPSessionManager.h"
#import "AttestationCheckViewController.h"
#import "MyWebViewController.h"

@interface RegisterViewController (){
    MemberRegisterData *memberData;
    NSMutableArray *pickerArray;
    NSMutableArray *cityArray;
    NSMutableArray *regionArray;
    UITextField *targetField;
    NSInteger genderSelectNum;
    NSInteger citySelectNum;
    NSInteger regionSelectNum;
    NSInteger gender;
    UITapGestureRecognizer *tap;
    NSString *fbID;
}

@end

@implementation RegisterViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil fbid:(NSString *)fbid{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        fbID = fbid;

    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButtonItem];
    
    UIImageView *logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_s"]];
    [logoImage setFrame:CGRectMake(0, 0, 120, 33)];
    logoImage.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.navigationItem setTitleView:logoImage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    [self initView];
    [self getCity];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardOnScreen:) name:UIKeyboardWillShowNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}

-(void)initView{
        
    self.regusterScrollView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255/0 alpha:1.0f];
    self.checkTextView.backgroundColor = self.regusterScrollView.backgroundColor;
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    citySelectNum = 0;
    regionSelectNum = 0;
    gender = 0;
    
    regionArray = [[NSMutableArray alloc] init];
    
    self.pickerView = [[UIPickerView alloc] init];
    _pickerView.delegate = self;
    _pickerView.showsSelectionIndicator = YES;
    [_pickerView selectRow:1 inComponent:0 animated:YES];
    
    self.datePicker = [[UIDatePicker alloc] init];
    NSLocale *datelocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];
    _datePicker.locale = datelocale;
    _datePicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.maximumDate = [NSDate new];
    [_datePicker addTarget:self action:@selector(datePickerChange:) forControlEvents:UIControlEventValueChanged];

    self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    self.toolBar.backgroundColor = [UIColor grayColor];
    
    UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    [doneBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [doneBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
    [doneBtn addTarget:self action:@selector(doneBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                               target:nil
                                               action:nil];
    [self.toolBar setItems:[NSArray arrayWithObjects:flexibleSpaceBarButton, btn, nil]];
    
    self.firstName.delegate = self;
    self.firstName.textAlignment = NSTextAlignmentLeft;
    self.firstName.placeholder = @"尚未輸入";
    [self.firstName addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    
    self.lastName.delegate = self;
    self.lastName.textAlignment = NSTextAlignmentLeft;
    self.lastName.placeholder = @"尚未輸入";
    [self.lastName addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    
    self.birthdayField.inputView = self.datePicker;
    self.birthdayField.inputAccessoryView = self.toolBar;
    self.birthdayField.delegate = self;
    self.birthdayField.textAlignment = NSTextAlignmentLeft;
    self.birthdayField.placeholder = @"請選擇";
    
    self.regionField.tag = 1;
    self.regionField.delegate = self;
    self.regionField.inputView = self.pickerView;
    self.regionField.inputAccessoryView = self.toolBar;
    
    self.addressField.tag = 2;
    self.addressField.delegate = self;
    self.addressField.placeholder = @"請輸入地址";
    [self.addressField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    
    self.emailField.delegate = self;
    self.emailField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailField.textAlignment = NSTextAlignmentLeft;
    self.emailField.placeholder = @"尚未輸入";
    [_emailField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    
    self.phoneField.delegate = self;
    self.phoneField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneField.inputAccessoryView = self.toolBar;
    self.phoneField.textAlignment = NSTextAlignmentLeft;
    [self.phoneField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [self.checkButton setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    [self.checkButton setImage:[UIImage imageNamed:@"checkSelect"] forState:UIControlStateSelected];
    [self.checkButton addTarget:self action:@selector(checkBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.checkButton setSelected:NO];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"您已詳讀並接受會員條款與個人資料保護政策"];
    [attributedString setAsLink:@"會員條款" linkURL:[ApiBuilder getContractMember]];
    [attributedString setAsLink:@"個人資料保護政策" linkURL:[ApiBuilder getContractPerson]];
    
    self.checkTextView.attributedText = attributedString;
    self.checkTextView.selectable = YES;
    self.checkTextView.editable = NO;
    self.checkTextView.delegate = self;
    
    [self.registerMobileButton.layer setCornerRadius:20];
}

-(void)getCity{
    cityArray = [[NSMutableArray alloc] init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[MyManager shareManager] requestWithMethod:GET WithPath:@"http://1028-1901386379.ap-northeast-1.elb.amazonaws.com/api/cities" WithParams:nil WithSuccessBlock:^(NSDictionary *dic) {
        NSArray *itemArray = [dic objectForKey:@"items"];
        for(int i = 0; i < [itemArray count]; i++){
            NSDictionary *itemDict = [itemArray objectAtIndex:i];
            AddressClass *addressClass = [[AddressClass alloc] init];
            addressClass.cityID = [itemDict objectForKey:@"id"];
            addressClass.name = [itemDict objectForKey:@"name"];
            [cityArray addObject:addressClass];
        }
        [self getRegion:@"1" setIndex:-1];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } WithFailurBlock:^(NSError *error, int statusCode) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

-(void)getRegion:(NSString *)cityID setIndex:(int)index
{
    [regionArray removeAllObjects];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[MyManager shareManager] requestWithMethod:GET WithPath:[NSString stringWithFormat:@"http://1028-1901386379.ap-northeast-1.elb.amazonaws.com/api/districts/%@",cityID] WithParams:nil WithSuccessBlock:^(NSDictionary *dic) {
        NSArray *itemArray = [dic objectForKey:@"items"];
        for(int i = 0; i < [itemArray count]; i++){
            NSDictionary *itemDict = [itemArray objectAtIndex:i];
            RegionClass *regionClass = [[RegionClass alloc] init];
            regionClass.cityID = [itemDict objectForKey:@"id"];
            regionClass.name = [itemDict objectForKey:@"name"];
            regionClass.zip = [itemDict objectForKey:@"zip"];
            [regionArray addObject:regionClass];
        }
        AddressClass *addressClass = [pickerArray objectAtIndex:citySelectNum];
        if([regionArray count] == 0){
            if (addressClass != nil) {
                targetField.text = addressClass.name;
            }
        }else{
            RegionClass *regionClass = [regionArray objectAtIndex:0];
            if (addressClass != nil) {
                targetField.text = [NSString stringWithFormat:@"%@ %@ %@", addressClass.name, regionClass.name, regionClass.zip];
            }
        }
        [_pickerView reloadAllComponents];
        if (index >=0 ) {
            [_pickerView selectRow:index inComponent:1 animated:NO];
        }
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } WithFailurBlock:^(NSError *error, int statusCode) {
        
    }];
}

#pragma mark UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"gestureRecoginizers count = %lu",[self.view.gestureRecognizers count]);
    
    if([self.view.gestureRecognizers count] < 1){
        [self.view addGestureRecognizer:tap];
    }
    
    targetField = textField;
    if(textField.tag == 1){
        pickerArray = cityArray;
        [_pickerView reloadAllComponents];
        [_pickerView selectRow:citySelectNum inComponent:0 animated:NO];
        [_pickerView selectRow:regionSelectNum inComponent:1 animated:NO];
        AddressClass *addressClass = [pickerArray objectAtIndex:citySelectNum];
        if([regionArray count] == 0){
            textField.text = addressClass.name;
        }
    }
    else if([textField isEqual:_birthdayField]){
        [_pickerView selectRow:0 inComponent:0 animated:NO];
    }
    return YES;
}


-(void)textFieldDidChanged:(UITextField *)textField
{
    [self syncData];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self syncData];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if(targetField.tag == 1){
        return 2;
    }
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0){
        return [pickerArray count];
    }
    return [regionArray count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == 0){
        if(targetField.tag == 1){
            AddressClass *addressClass = [pickerArray objectAtIndex:row];
            return addressClass.name;
        }
        return [pickerArray objectAtIndex:row];
    }
    if(row <[regionArray count]) {
        RegionClass *regionClass = [regionArray objectAtIndex:row];
        return regionClass.name;
    }
    return @"";
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(component == 0){
        if(targetField.tag == 1){
            citySelectNum = row;
            AddressClass *addressClass = [pickerArray objectAtIndex:row];
            [self getRegion:[NSString stringWithFormat:@"%@",addressClass.cityID] setIndex:0];
        }
        else{
            targetField.text = [pickerArray objectAtIndex:row];
        }
    }
    else{
        regionSelectNum = row;
        RegionClass *regionClass ;
        AddressClass *addressClass = [pickerArray objectAtIndex:citySelectNum];
        if(row < [regionArray count]) {
            regionClass = [regionArray objectAtIndex:row];
        }
        targetField.text = [NSString stringWithFormat:@"%@ %@ %@", addressClass.name, regionClass.name == nil? @"" : regionClass.name, regionClass.zip == nil ? @"" : regionClass.zip];
        memberData.code = [NSString stringWithFormat:@"%@", regionClass.zip];
    }
}

-(void)datePickerChange:(UIDatePicker *)datePicker
{
    NSDate *selectDate = [datePicker date];
    NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
    selectDateFormatter.dateFormat = @"yyyy/MM/dd";
    NSString *dateStr = [selectDateFormatter stringFromDate:selectDate];
    
    _birthdayField.text = dateStr;
}

-(void)syncData
{
    memberData.address = self.addressField.text;
    NSLog(@"birthdatyField = %@",self.birthdayField.text);
    memberData.birthday = self.birthdayField.text;
    memberData.city = self.regionField.text;
    memberData.mobilephone = self.phoneField.text;
    memberData.firstName = self.firstName.text;
    memberData.lastName = self.lastName.text;
}

-(void)doneBtn:(UIBarButtonItem *)sender
{
    [targetField resignFirstResponder];
    [self.regusterScrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    if (URL)
    {
        
        MyWebViewController *myWebViewController = [[MyWebViewController alloc] initWithNibName:@"MyWebViewController" bundle:nil withURL:[URL absoluteString]];
        [self.navigationController pushViewController:myWebViewController animated:YES];
        
        return NO;
    }
    
    return YES;
}

#pragma mark - 鍵盤操作

-(void)dismissKeyboard
{
    //先移除叫出鍵盤時另外堆疊的view
    [self.regusterScrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.view removeGestureRecognizer:tap];
    
//    if([targetField isEqual:self.emailField]){
//        if (![self NSStringIsValidEmail:self.emailField.text]) {
//            NSLog(@"email error");
//        }
//    }
    
    [self.firstName resignFirstResponder];
    [self.lastName resignFirstResponder];
    [self.birthdayField resignFirstResponder];
    [self.addressField resignFirstResponder];
    [self.regionField resignFirstResponder];
    [self.emailField resignFirstResponder];
    [self.phoneField resignFirstResponder];
}

-(void)keyboardOnScreen:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    double animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:animationDuration animations:^{
        
    } completion:^(BOOL finished) {
        [self.regusterScrollView setContentInset:UIEdgeInsetsMake(0, 0, kbSize.height, 0)];
    }];
    
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(BOOL) NSStringIsValidMobile:(NSString *)checkString
{
    NSString *stricterFilterString = @"^[0]+[9]+[0-9]{2,8}$";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    return [mobileTest evaluateWithObject:checkString];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)regusterButtonClicked:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if(0){
        NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];

        [tmp setValue:@"adam" forKey:@"first_name"];
        [tmp setValue:@"wu" forKey:@"last_name"];
        [tmp setValue:@"adamwu@fashionguide.com.tw" forKey:@"email"];
        [tmp setValue:fbID forKey:@"facebook_id"];
        [tmp setValue:@"2017-01-01" forKey:@"birthday"];
        [tmp setValue:@1 forKey:@"gender"];
        [tmp setValue:@"0910188034" forKey:@"mobile"];
        [tmp setValue:@0 forKey:@"city_id"];
        [tmp setValue:@1 forKey:@"district_id"];
        [tmp setValue:@"aaaaa" forKey:@"address"];
        [tmp setValue:@"http://tw.yahoo.com" forKey:@"avatar"];
        
        NSLog(@"registerParam = %@",tmp);
        
        NSParameterAssert(tmp);
        
        [[MyManager shareManager] requestWithMethod:POST WithPath:[ApiBuilder getCreateNewUser] WithParams:tmp WithSuccessBlock:^(NSDictionary *dic) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [[MyManager shareManager] saveUserInfoToKeyChain:dic];
                        
            AttestationCheckViewController *attestationCheckViewController = [[AttestationCheckViewController alloc] initWithNibName:@"AttestationCheckViewController" bundle:nil];
            [self.navigationController pushViewController:attestationCheckViewController animated:YES];
            
        } WithFailurBlock:^(NSError *error, int statusCode) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
            NSString *message = [serializedData objectForKey:@"message"];
            
            [self showVaildMessageWithTitle:@"錯誤訊息" content:message];
            
        }];
        
        return;
    }
    
    
    if ([self.firstName.text isEqualToString:@""]) {
        [self showVaildMessageWithTitle:@"欄位錯誤" content:@"請填寫 「名」"];
    }
    else if([self.lastName.text isEqualToString:@""]){
        [self showVaildMessageWithTitle:@"欄位錯誤" content:@"請填寫 「姓」"];
    }
//    else if([self.birthdayField.text isEqualToString:@""]){
//        [self showVaildMessageWithTitle:@"欄位錯誤" content:@"請填寫 「生日」"];
//    }
//    else if(gender == 0){
//        [self showVaildMessageWithTitle:@"欄位錯誤" content:@"請填寫 「性別」"];
//    }
    else if([self.regionField.text isEqualToString:@""]){
        [self showVaildMessageWithTitle:@"欄位錯誤" content:@" 請填寫 「縣市」"];
    }
    else if([self.addressField.text isEqualToString:@""]){
        [self showVaildMessageWithTitle:@"欄位錯誤" content:@"請填寫 「地址」"];
    }
    else if([self.emailField.text isEqualToString:@""]){
        [self showVaildMessageWithTitle:@"欄位錯誤" content:@"請填寫 「電子郵件」"];
    }
    else if([self.phoneField.text isEqualToString:@""]){
        [self showVaildMessageWithTitle:@"欄位錯誤" content:@"請填寫 「手機電話」"];
    }
    else{
        
        if (![self NSStringIsValidEmail:self.emailField.text]) {
            [self showVaildMessageWithTitle:@"欄位錯誤" content:@"電子郵件格式錯誤"];
        }
        else if (![self NSStringIsValidMobile:self.phoneField.text] || self.phoneField.text.length != 10) {
            [self showVaildMessageWithTitle:@"欄位錯誤" content:@"手機電話格式錯誤"];
        }
        else if(![self.checkButton isSelected]){
            [self showVaildMessageWithTitle:@"注意" content:@"您尚未勾選同意會員條款與個人資料保護政策"];
        }
        else{
            
            NSString *replaceBirthdayText = [self.birthdayField.text stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
            NSString *avater = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",fbID];
            
            NSMutableDictionary *registerParam = [[NSMutableDictionary alloc] init];
            [registerParam setValue:self.firstName.text forKey:@"first_name"];
            [registerParam setValue:self.lastName.text forKey:@"last_name"];
            [registerParam setValue:self.emailField.text forKey:@"email"];
            [registerParam setValue:fbID forKey:@"facebook_id"];
//            [registerParam setValue:replaceBirthdayText forKey:@"birthday"];
//            [registerParam setValue:[NSNumber numberWithInteger:gender] forKey:@"gender"];
            [registerParam setValue:self.phoneField.text forKey:@"mobile"];
            [registerParam setValue:[[cityArray objectAtIndex:citySelectNum] cityID] forKey:@"city_id"];
            [registerParam setValue:[[regionArray objectAtIndex:regionSelectNum] cityID] forKey:@"district_id"];
            [registerParam setValue:self.addressField.text forKey:@"address"];
            [registerParam setValue:avater forKey:@"avatar"];
            
            NSParameterAssert(registerParam);
    
            [[MyManager shareManager] requestWithMethod:POST WithPath:[ApiBuilder getCreateNewUser] WithParams:registerParam WithSuccessBlock:^(NSDictionary *dic) {
                
                [[MyManager shareManager] saveUserInfoToKeyChain:dic];
                [[MyManager shareManager] setAttestationTime:self.phoneField.text];
                
                AttestationCheckViewController *attestationCheckViewController = [[AttestationCheckViewController alloc] initWithNibName:@"AttestationCheckViewController" bundle:nil];
                [self.navigationController pushViewController:attestationCheckViewController animated:YES];
                
            } WithFailurBlock:^(NSError *error, int statusCode) {
                
                NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
                NSString *message = [serializedData objectForKey:@"message"];
                
                [self showVaildMessageWithTitle:@"錯誤訊息" content:message];
                
            }];

        }
    }

}

- (IBAction)genderBtnClicked:(id)sender {
    
    UIButton *tmp = (UIButton *)sender;
    
    if ([tmp isEqual:_girlButton]) {
        NSLog(@"girl");
        self.girlButton.selected = YES;
        self.boyButton.selected = NO;
        gender = 2;
    }
    else{
        NSLog(@"boy");
        self.boyButton.selected = YES;
        self.girlButton.selected = NO;
        gender = 1;
    }
    
}

- (IBAction)checkBtnClicked:(id)sender {
    UIButton *tmp = (UIButton *)sender;
    
    if ([self.checkButton isSelected]) {
        self.checkButton.selected = NO;
    }
    else{
        self.checkButton.selected = YES;
    }
    
}

-(void)showVaildMessageWithTitle:(NSString *)title content:(NSString *)message{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    alertController.view.tintColor = [UIColor redColor];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    
    [alertController addAction:confirmAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
