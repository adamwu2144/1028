//
//  MemberSettingViewController.m
//  1028
//
//  Created by fg on 2017/6/2.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "MemberSettingViewController.h"
#import "MBProgressHUD.h"
#import "AddressClass.h"
#import "RegionClass.h"
#import "MemberRegisterData.h"
#import "../Framework/AFNetworking/AFHTTPSessionManager.h"
#import "AttestationCheckViewController.h"
#import "../Framework/SDWebImage/UIImageView+WebCache.h"
#import "PhotoEditViewController.h"
#import "ICSColorsViewController.h"

@interface MemberSettingViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    int gender;
    BOOL updateUserData;
}

@end

@implementation MemberSettingViewController{
    NSMutableArray *pickerArray;
    NSMutableArray *cityArray;
    NSMutableArray *regionArray;
    
    NSInteger citySelectNum;
    NSInteger regionSelectNum;
    
    UITextField *targetField;
    BOOL isChange;
    
    UIImagePickerController *imagePicker;
    BOOL savePhotoFlag;
    ChangePhotoType changePhotoType;
    float keybordgap;

}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UserDataDidChangeNotification" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(!self.navigationItem.titleView){
        UIImageView *logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_s"]];
        [logoImage setFrame:CGRectMake(0, 0, 120, 33)];
        logoImage.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.navigationItem setTitleView:logoImage];
    }
    
    if(updateUserData){
        updateUserData = NO;
        [self updateUserDataBlock];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardOnScreen:) name:UIKeyboardWillShowNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}

-(void)keyboardOnScreen:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    double animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:animationDuration animations:^{
        
    } completion:^(BOOL finished) {
        
        if(CGRectGetMaxY(self.confirmButton.frame) > SCREEN_HEIGHT-kbSize.height){
            keybordgap = fabs(CGRectGetMaxY(self.confirmButton.frame) - (SCREEN_HEIGHT-kbSize.height));
            [self.memberSettingScrollView setContentInset:UIEdgeInsetsMake(0, 0, keybordgap, 0)];
        }
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDataDidChange:) name:@"UserDataDidChangeNotification" object:nil];
    [self initCusView];
    [self getCity];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initCusView{
    
    updateUserData = NO;
    citySelectNum = -1;
    regionSelectNum = -1;
    regionArray = [[NSMutableArray alloc] init];
    isChange = NO;
    
    self.mobileTextField.text = [[MyManager shareManager] memberData].mobile;
    self.addressTextField.text = [[MyManager shareManager] memberData].address;
    self.memberName.text = [[MyManager shareManager] memberData].user_name;
    
    NSTextAttachment *imageAttachment = [[NSTextAttachment alloc] init];
    
    switch ([[[MyManager shareManager] memberData].titleKey intValue]) {
        case 1:
            imageAttachment.image = [UIImage imageNamed:@"iconBabe"];
            self.memberLevel.textColor = TITLE_KEY_ONE_COLOR;
            self.memberLevel.layer.borderColor = TITLE_KEY_ONE_COLOR.CGColor;
            
            break;
        case 2:
            imageAttachment.image = [UIImage imageNamed:@"iconGirl"];
            self.memberLevel.textColor = TITLE_KEY_TWO_COLOR;
            self.memberLevel.layer.borderColor = TITLE_KEY_TWO_COLOR.CGColor;
            break;
        case 3:
            imageAttachment.image = [UIImage imageNamed:@"iconLady"];
            self.memberLevel.textColor = TITLE_KEY_THREE_COLOR;
            self.memberLevel.layer.borderColor = TITLE_KEY_THREE_COLOR.CGColor;
            break;
        default:
            break;
    }
    
    CGFloat imageOffsetY = 0.0;
    imageAttachment.bounds = CGRectMake(-5, imageOffsetY, imageAttachment.image.size.width, imageAttachment.image.size.height);
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:imageAttachment];
    NSMutableAttributedString *completeText= [[NSMutableAttributedString alloc] initWithString:@" "];
    [completeText appendAttributedString:attachmentString];
    NSMutableAttributedString *textAfterIcon= [[NSMutableAttributedString alloc] initWithString:[[MyManager shareManager] memberData].title];
    [textAfterIcon addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0f] range:NSMakeRange(0, [[MyManager shareManager] memberData].title.length)];
    [completeText appendAttributedString:textAfterIcon];
    self.memberLevel.textAlignment=NSTextAlignmentLeft;
    self.memberLevel.attributedText=completeText;
    
    self.emailTextField.text = [[MyManager shareManager] memberData].email;
    
    UIImage *tempPic = nil;
    if ([[[MyManager shareManager] memberData].gender intValue]== 1) {
        tempPic = [UIImage imageNamed:@"man"];
    }
    else{
        tempPic = [UIImage imageNamed:@"girl"];
    }
    
    [self.memberPicture sd_setImageWithURL:[NSURL URLWithString:[[MyManager shareManager] memberData].avatar] placeholderImage:tempPic];
    
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
    self.toolBar.backgroundColor = DEFAULT_LIGHT_GARY_COLOR;
    
    UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    [doneBtn setTitleColor:DEFAULT_COLOR forState:UIControlStateNormal];
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [doneBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
    [doneBtn addTarget:self action:@selector(doneBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                               target:nil
                                               action:nil];
    [self.toolBar setItems:[NSArray arrayWithObjects:flexibleSpaceBarButton, btn, nil]];
    
    self.birthdayField.inputView = self.datePicker;
    self.birthdayField.inputAccessoryView = self.toolBar;
    self.birthdayField.delegate = self;
    self.birthdayField.textAlignment = NSTextAlignmentLeft;
    
    MemberData *memberData = [[MyManager shareManager] memberData];
    if ([memberData.birthday isEqualToString:@""]) {
        self.birthdayField.placeholder = @"請選擇";
    }
    else{
        self.birthdayField.placeholder = memberData.birthday;
        NSDateFormatter *format = [[NSDateFormatter alloc]init];
        [format setDateFormat:@"yyyy-MM-dd"];
        [format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        NSString *str= memberData.birthday;
        NSDate *date = [format dateFromString:str];
        [self.datePicker setDate:date];
    }
    
    if([memberData.gender intValue] == 1){
        [self.girlButton setSelected:NO];
        [self.boyButton setSelected:YES];
        gender = 1;
    }
    else if([memberData.gender intValue] == 2){
        [self.girlButton setSelected:YES];
        [self.boyButton setSelected:NO];
        gender = 2;
    }
    else{
        gender = -1;
    }

    self.cityTextField.tag = 1;
    self.cityTextField.delegate = self;
    self.cityTextField.inputView = self.pickerView;
    self.cityTextField.inputAccessoryView = self.toolBar;
    self.cityTextField.layer.borderColor = [UIColor redColor].CGColor;
    self.cityTextField.layer.borderWidth = 0;
    

    self.mobileTextField.delegate = self;
    self.mobileTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.mobileTextField.inputAccessoryView = self.toolBar;
    self.mobileTextField.textAlignment = NSTextAlignmentLeft;
    [self.mobileTextField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [self.changeMemberPictureButton.layer setCornerRadius:20];
    [self.changeMemberPictureButton.layer setBorderColor:DEFAULT_COLOR.CGColor];
    [self.changeMemberPictureButton.layer setBorderWidth:1.0f];
    [self.changeMemberPictureButton setTitleColor:DEFAULT_COLOR forState:UIControlStateNormal];
    
    [self.confirmButton.layer setCornerRadius:20];
    [self.confirmButton setBackgroundColor:DEFAULT_COLOR];
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
        [self getRegion:[[[MyManager shareManager] memberData].city_id stringValue] setIndex:0];
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
            
            NSLog(@"  regionClass.cityID = %d memberData.cityID = %d",[regionClass.cityID intValue],[[[MyManager shareManager] memberData].district_id intValue]);
            
            if ([regionClass.cityID intValue] == [[[MyManager shareManager] memberData].district_id intValue]) {
                regionSelectNum = i;
            }
            [regionArray addObject:regionClass];
        }
        AddressClass *addressClass = [cityArray objectAtIndex:[cityID intValue]-1];
        if([regionArray count] == 0){
            if (addressClass != nil) {
                targetField.text = addressClass.name;
            }
        }else{
            RegionClass *regionClass = [regionArray objectAtIndex:regionSelectNum];
            if (addressClass != nil) {
                self.cityTextField.text = [NSString stringWithFormat:@"%@ %@ %@", addressClass.name, regionClass.name, regionClass.zip];
                
            }
        }
        [_pickerView reloadAllComponents];
        if (index >=0 ) {
            [_pickerView selectRow:regionSelectNum inComponent:1 animated:NO];
        }
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } WithFailurBlock:^(NSError *error, int statusCode) {
        
    }];
}

-(void)doneBtn:(UIBarButtonItem *)sender
{
    NSLog(@"citySelectNum = %ld,regionSelectNum %ld",(long)citySelectNum,(long)regionSelectNum);
    isChange = YES;
    int tmp = -keybordgap;
    [self.memberSettingScrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [targetField resignFirstResponder];
}

-(BOOL) NSStringIsValidMobile:(NSString *)checkString
{
    NSString *stricterFilterString = @"^[0]+[9]+[0-9]{2,8}$";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    return [mobileTest evaluateWithObject:checkString];
}

- (IBAction)changeBtnClicked:(id)sender {
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"選擇圖片來源"
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    UIAlertAction *albumBtn = [UIAlertAction actionWithTitle:@"從相簿選擇" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:NO completion:nil];
        //檢查是否支援此Source Type(相簿)
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            //設定影像來源為相簿
            imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.delegate = self;
            imagePicker.allowsEditing = NO;
            savePhotoFlag = NO;
            //顯示UIImagePickerController
            [self.navigationController presentViewController:imagePicker animated:YES completion:^{}];
        }
    }];
    
    UIAlertAction *cameraBtn = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:NO completion:nil];
        //檢查是否支援此Source Type(相機)
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            //設定影像來源為相機
            imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
            imagePicker.delegate = self;
            imagePicker.allowsEditing = NO;
            savePhotoFlag = YES;
            //顯示UIImagePickerController
            [self.navigationController presentViewController:imagePicker animated:YES completion:^{}];
        }
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:albumBtn];
    [alertController addAction:cameraBtn];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (IBAction)confirmBtnClicked:(id)sender {
    if([self.cityTextField.text isEqualToString:@""]){
        [self showVaildMessageWithTitle:@"欄位錯誤" content:@" 請填寫 「縣市」" action:0];
    }
    else if([self.addressTextField.text isEqualToString:@""]){
        [self showVaildMessageWithTitle:@"欄位錯誤" content:@"請填寫 「地址」" action:0];
    }
    else if([self.mobileTextField.text isEqualToString:@""]){
        [self showVaildMessageWithTitle:@"欄位錯誤" content:@"請填寫 「手機電話」" action:0];
    }
    else if([self.emailTextField.text isEqualToString:@""]){
        [self showVaildMessageWithTitle:@"欄位錯誤" content:@"請填寫 「電子信箱」" action:0];
    }
    else{
        if (![self NSStringIsValidMobile:self.mobileTextField.text] || self.mobileTextField.text.length != 10) {
            [self showVaildMessageWithTitle:@"欄位錯誤" content:@"手機電話格式錯誤" action:0];
        }
        else{
            NSMutableDictionary *changeParam = [[NSMutableDictionary alloc] init];

        
            NSLog(@"citySelectNum %ld, regionSelectNum = %ld reallyValue = %ld",(long)citySelectNum,(long)regionSelectNum,(long)[[[MyManager shareManager] memberData].city_id integerValue]);
            
            NSLog(@"cityArray = %@",cityArray);
            NSLog(@"regionArray = %@",regionArray);
            
            if (citySelectNum == -1) {
                citySelectNum = [[[MyManager shareManager] memberData].city_id integerValue]-1;
            }
            
            
            NSString *oldStr = [[MyManager shareManager] memberData].mobile;
            NSString *newStr = [changeParam objectForKey:@"mobile"];
            
            if (![[[MyManager shareManager] memberData].mobile isEqualToString:self.mobileTextField.text]) {
                [changeParam setValue:self.mobileTextField.text forKey:@"mobile"];
            }
            if (![[[MyManager shareManager] memberData].email isEqualToString:self.emailTextField.text]) {
                [changeParam setValue:self.emailTextField.text forKey:@"email"];
            }
            [changeParam setValue:[[cityArray objectAtIndex:citySelectNum] cityID] forKey:@"city_id"];
            [changeParam setValue:[[regionArray objectAtIndex:regionSelectNum] cityID] forKey:@"district_id"];
            [changeParam setValue:self.addressTextField.text forKey:@"address"];
            if (![self.birthdayField.text isEqualToString:@""]) {
                [changeParam setValue:self.birthdayField.text forKey:@"birthday"];
            }
            if (gender != -1) {
                [changeParam setObject:[NSNumber numberWithInt:gender] forKey:@"gender"];
            }

            NSParameterAssert(changeParam);
            
            
            NSLog(@"mobile = %@,  update = %@",[[MyManager shareManager] memberData].mobile ,[changeParam objectForKey:@"mobile"]);
            
            [[MyManager shareManager] requestWithMethod:PATCH WithPath:[ApiBuilder getUpdateUserData] WithParams:changeParam WithSuccessBlock:^(NSDictionary *dic) {
                
                NSLog(@"address = %@, mobile = %@, city_id = %@,dis_id = %@",[[MyManager shareManager] memberData].address,[[MyManager shareManager] memberData].mobile,[[MyManager shareManager] memberData].city_id,[[MyManager shareManager] memberData].district_id);
                
                if ([[[MyManager shareManager] memberData].mobile isEqualToString:self.mobileTextField.text]) {
                    //不用手機驗證
                    [[MyManager shareManager] changeMemberData:[[MemberData alloc] initWithDictionary:[dic objectForKey:@"items"]]];
                    [self showVaildMessageWithTitle:@"成功" content:@"更新完成" action:1];
                }
                else{
                    [[MyManager shareManager] setAttestationTime:self.mobileTextField.text];
                    [self showVaildMessageWithTitle:@"成功" content:@"請重新驗證手機號碼" action:2];
                }
                
                
            } WithFailurBlock:^(NSError *error, int statusCode) {
                NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
                NSString *message = [serializedData objectForKey:@"message"];
                NSLog(@"message = %@",message);
                [self showVaildMessageWithTitle:@"錯誤訊息" content:message action:0];
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
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
            case 2:{
                AttestationCheckViewController *attestationCheckViewController = [[AttestationCheckViewController alloc] initWithNibName:@"AttestationCheckViewController" bundle:nil];
                ICSNavigationController *navi = [[ICSNavigationController alloc] initWithRootViewController:attestationCheckViewController];
                [self presentViewController:navi animated:YES completion:nil];
//                [self.navigationController pushViewController:attestationCheckViewController animated:YES];
            }
                break;
            default:
                break;
        }
    }];
    
    [alertController addAction:confirmAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)updateUserDataBlock{
    
    NSTextAttachment *imageAttachment = [[NSTextAttachment alloc] init];
    
    switch ([[[MyManager shareManager] memberData].titleKey intValue]) {
        case 1:
            imageAttachment.image = [UIImage imageNamed:@"iconBabe"];
            self.memberLevel.textColor = TITLE_KEY_ONE_COLOR;
            self.memberLevel.layer.borderColor = TITLE_KEY_ONE_COLOR.CGColor;
            
            break;
        case 2:
            imageAttachment.image = [UIImage imageNamed:@"iconGirl"];
            self.memberLevel.textColor = TITLE_KEY_TWO_COLOR;
            self.memberLevel.layer.borderColor = TITLE_KEY_TWO_COLOR.CGColor;
            break;
        case 3:
            imageAttachment.image = [UIImage imageNamed:@"iconLady"];
            self.memberLevel.textColor = TITLE_KEY_THREE_COLOR;
            self.memberLevel.layer.borderColor = TITLE_KEY_THREE_COLOR.CGColor;
            break;
        default:
            break;
    }
    
    CGFloat imageOffsetY = 0.0;
    imageAttachment.bounds = CGRectMake(-5, imageOffsetY, imageAttachment.image.size.width, imageAttachment.image.size.height);
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:imageAttachment];
    NSMutableAttributedString *completeText= [[NSMutableAttributedString alloc] initWithString:@" "];
    [completeText appendAttributedString:attachmentString];
    NSMutableAttributedString *textAfterIcon= [[NSMutableAttributedString alloc] initWithString:[[MyManager shareManager] memberData].title];
    [textAfterIcon addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0f] range:NSMakeRange(0, [[MyManager shareManager] memberData].title.length)];
    [completeText appendAttributedString:textAfterIcon];
    self.memberLevel.textAlignment=NSTextAlignmentLeft;
    self.memberLevel.attributedText=completeText;
}

#pragma mark - UIImagePickerDelegate
//使用者按下確定時
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //取得剛拍攝的相片(或是由相簿中所選擇的相片)
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    image = [self fixOrientation:image];
    if(savePhotoFlag){
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    [picker dismissViewControllerAnimated:NO completion:^{
        PhotoEditViewController *photoEditViewController = [[PhotoEditViewController alloc]initWithImg:image changType:changePhotoType];
        photoEditViewController.photoEditDelegate = self;
        imagePicker = nil;
        [self presentViewController:photoEditViewController animated:YES completion:nil];
    }];
}

//使用者按下取消時
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    //一般情況下沒有什麼特別要做的事情
    
    [picker dismissViewControllerAnimated:YES completion:^{
        imagePicker = nil;
    }];
}

- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

-(void)completedEditImg:(UIImage *)img{
    
    [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
    
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    int maxFileSize = 900*1024;
    
    NSData *imageData = UIImageJPEGRepresentation(img, compression);
    
    while ([imageData length] > maxFileSize && compression > maxCompression)
    {
        compression *= 0.9;
        imageData = UIImageJPEGRepresentation(img, compression);
    }
    
    NSLog(@"imageData length = %lu",(unsigned long)imageData.length);
    
    
    NSString *strEncoded = [imageData base64EncodedStringWithOptions:0];
    
    NSLog(@"base64 image = %@",strEncoded);
    
    NSMutableDictionary *changeParam = [[NSMutableDictionary alloc] init];
    [changeParam setValue:strEncoded forKey:@"image"];
    
    [[MyManager shareManager] requestWithMethod:POST WithPath:[ApiBuilder getUpdateUserAvatar] WithParams:changeParam WithSuccessBlock:^(NSDictionary *dic) {
        if (dic) {
            NSString *avatarStr = [[dic objectForKey:@"items"] objectForKey:@"avatar"];
            [[MyManager shareManager] memberData].avatar = avatarStr;
            [self.memberPicture sd_setImageWithURL:[NSURL URLWithString:avatarStr]];
            TaskViewController *tmp = (TaskViewController *)[[PublicAppDelegate.mainTabBarController.taskNavi viewControllers] firstObject];
            [tmp reloadMemberPic];
            [MBProgressHUD hideHUDForView:self.view  animated:YES];
        }
    } WithFailurBlock:^(NSError *error, int statusCode) {
        NSLog(@"error");
    }];
//    [self.memberPicture setImage:img];
}

#pragma mark UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //    NSLog(@"gestureRecoginizers count = %lu",[self.view.gestureRecognizers count]);
    
    if (!isChange) {
        citySelectNum = [[[MyManager shareManager] memberData].city_id integerValue]-1;
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
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
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
            regionSelectNum = 0;//變成預設
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
        //        memberData.code = [NSString stringWithFormat:@"%@", regionClass.zip];
    }
}

-(void)datePickerChange:(UIDatePicker *)datePicker
{
    NSDate *selectDate = [datePicker date];
    NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
    selectDateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [selectDateFormatter stringFromDate:selectDate];
    
    self.birthdayField.text = dateStr;
}

#pragma mark UserDataDidChangeNotification

-(void)userDataDidChange:(NSNotification *)notificaion{
    updateUserData = YES;
    
}
@end
