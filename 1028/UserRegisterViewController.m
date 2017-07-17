//
//  UserRegisterViewController.m
//  1028
//
//  Created by fg on 2017/5/22.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "UserRegisterViewController.h"
#import "MyManager.h"
#import "MemberRegisterData.h"
#import "MBProgressHUD.h"
#import "AddressClass.h"
#import "RegionClass.h"
#import "AddressCell.h"

@interface UserRegisterViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{
    MemberRegisterData *memberData;
    NSMutableArray *pickerArray;
    NSMutableArray *genderArray;
    NSMutableArray *cityArray;
    NSMutableArray *regionArray;
    UITextField *targetField;
    NSInteger genderSelectNum;
    NSInteger citySelectNum;
    NSInteger regionSelectNum;
    UIView *footerView;
    UIButton *registerButton;
    UIButton *checkButton;
    UILabel *merberMessageLabel;
    UILabel *personalMessageLabel;
}

@end

@implementation UserRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"基本資料填寫";
    regionArray = [[NSMutableArray alloc] init];
    [self getCity];
    [self initTableView];
    
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

-(void)initTableView
{
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
    
    genderArray = [[NSMutableArray alloc] initWithObjects:@"男", @"女", nil];
    
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    _toolbar.backgroundColor = DEFAULT_LIGHT_GARY_COLOR;
    
    UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    [doneBtn setTitleColor:DEFAULT_COLOR forState:UIControlStateNormal];
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [doneBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
    [doneBtn addTarget:self action:@selector(doneBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
    
    //    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBtn:)];
    
    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                               target:nil
                                               action:nil];
    [_toolbar setItems:[NSArray arrayWithObjects:flexibleSpaceBarButton, btn, nil]];
    
    genderSelectNum = 0;
    citySelectNum = 0;
    regionSelectNum = 0;
    
    _firstNameField = [[TextFieldNoMenu alloc] initWithFrame:CGRectMake(15, 0, 250, 44)];
    _firstNameField.textColor = [UIColor colorWithRed:1 green:138.0/255.0 blue:130.0/255.0 alpha:1];
    _firstNameField.delegate = self;
    _firstNameField.textAlignment = NSTextAlignmentLeft;
    _firstNameField.placeholder = @"  (尚未輸入)";
    [_firstNameField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    
    _lastNameField = [[TextFieldNoMenu alloc] initWithFrame:CGRectMake(15, 0, 250, 44)];
    _lastNameField.textColor = [UIColor colorWithRed:1 green:138.0/255.0 blue:130.0/255.0 alpha:1];
    _lastNameField.delegate = self;
    _lastNameField.textAlignment = NSTextAlignmentLeft;
    _lastNameField.placeholder = @"  (尚未輸入)";
    [_lastNameField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    
    _birthdayField = [[TextFieldNoMenu alloc] initWithFrame:CGRectMake(15, 0, 250, 44)];
    _birthdayField.inputView = _datePicker;
    _birthdayField.inputAccessoryView = _toolbar;
    _birthdayField.textColor = [UIColor colorWithRed:1 green:138.0/255.0 blue:130.0/255.0 alpha:1];
    _birthdayField.delegate = self;
    _birthdayField.textAlignment = NSTextAlignmentLeft;
    _birthdayField.placeholder = @"  (尚未輸入)";
    
    _phoneField = [[TextFieldNoMenu alloc] initWithFrame:CGRectMake(15, 0, 250, 44)];
    _phoneField.textColor = [UIColor colorWithRed:1 green:138.0/255.0 blue:130.0/255.0 alpha:1];
    _phoneField.delegate = self;
    _phoneField.textAlignment = NSTextAlignmentLeft;
    _phoneField.placeholder = @"  (尚未輸入)";
    [_phoneField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    
    _genderField = [[TextFieldNoMenu alloc] initWithFrame:CGRectMake(15, 0, 250, 44)];
    _genderField.textColor = [UIColor colorWithRed:1 green:138.0/255.0 blue:130.0/255.0 alpha:1];
    _genderField.inputView = _pickerView;
    _genderField.inputAccessoryView = _toolbar;
    _genderField.placeholder = @"請選擇";
    _genderField.delegate = self;
    _genderField.textAlignment = NSTextAlignmentLeft;
    
    _emailField = [[TextFieldNoMenu alloc] initWithFrame:CGRectMake(15, 0, 250, 44)];
    _emailField.textColor = [UIColor colorWithRed:1 green:138.0/255.0 blue:130.0/255.0 alpha:1];
    _emailField.delegate = self;
    _emailField.textAlignment = NSTextAlignmentLeft;
    _emailField.placeholder = @"  (尚未輸入)";
    [_emailField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    
    footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    
    checkButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 175/3, 25, 25)];
    [checkButton setImage:[UIImage imageNamed:@"ic_chkbox_unchecked"] forState:UIControlStateNormal];
    [checkButton setImage:[UIImage imageNamed:@"ic_chkbox_checked"] forState:UIControlStateSelected];
    [checkButton addTarget:self action:@selector(checkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [checkButton setSelected:NO];
    
    merberMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(checkButton.frame)+5, checkButton.frame.origin.y, 136, 25)];
    NSMutableAttributedString *acceptMemberRules =  [[NSMutableAttributedString alloc] initWithString:@"您已詳讀並接受"] ;
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:@"會員條款"
                                                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f],
                                                                                      NSForegroundColorAttributeName: [UIColor blueColor],
                                                                                      NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSBaselineOffsetAttributeName: @(0)}];
    [acceptMemberRules appendAttributedString:attributedText];
    [merberMessageLabel setAttributedText:acceptMemberRules];
    
    merberMessageLabel.numberOfLines = 1;
    [merberMessageLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [merberMessageLabel setTextColor:[UIColor grayColor]];
    
    personalMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(merberMessageLabel.frame), checkButton.frame.origin.y, 120, 25)];
    NSMutableAttributedString *acceptPersonalInfoPolicy = [[NSMutableAttributedString alloc] initWithString:@"與"];
    attributedText = [[NSAttributedString alloc] initWithString:@"個人資料保護政策"
                                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f],
                                                                  NSForegroundColorAttributeName: [UIColor blueColor],
                                                                  NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSBaselineOffsetAttributeName: @(0)}];
    [acceptPersonalInfoPolicy appendAttributedString:attributedText];

    
    [personalMessageLabel setAttributedText:acceptPersonalInfoPolicy];
    personalMessageLabel.numberOfLines = 1;
    [personalMessageLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [personalMessageLabel setTextColor:[UIColor grayColor]];
    
    NSLog(@"frame = %@",NSStringFromCGRect(footerView.frame));
    
    registerButton = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(checkButton.frame)+20, SCREEN_WIDTH-20, 44)];
    [registerButton setTitle:@"手機驗證" forState:UIControlStateNormal];
    registerButton.titleLabel.textColor = [UIColor whiteColor];
    registerButton.backgroundColor = [UIColor blueColor];
    
    [footerView addSubview:checkButton];
    [footerView addSubview:merberMessageLabel];
    [footerView addSubview:personalMessageLabel];
    [footerView addSubview:registerButton];
    
    self.personalTableView.tableFooterView = footerView;
    
    
}

#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 0) {
        int row = (int)(indexPath.row / 2);
        Boolean header = (indexPath.row % 2 == 0);
        
        NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)indexPath.row,(long)indexPath.section];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil ){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.separatorInset = UIEdgeInsetsZero;
        }
        if(header) {
            cell.backgroundColor = [UIColor clearColor];
            switch (row) {
                case 0:
                    cell.textLabel.text = @"姓";
                    break;
                case 1:
                    cell.textLabel.text = @"名";
                    break;
                case 2:
                    cell.textLabel.text = @"生 日";
                    break;
                case 3:
                    cell.textLabel.text = @"性 別";
                    break;
                case 4:
                    cell.textLabel.text = @"地 址";
                    break;
                case 5:
                    cell.textLabel.text = @"電子信箱";
                    break;
                case 6:
                    cell.textLabel.text = @"手機電話";
                    break;
            }
        } else {
            switch (row) {
                case 0:
                    [cell.contentView addSubview:_lastNameField];
                    break;
                case 1:
                    [cell.contentView addSubview:_firstNameField];
                    break;
                case 2:
                    [cell.contentView addSubview:_birthdayField];
                    break;
                case 3:
                    [cell.contentView addSubview:_genderField];
                    break;
                case 4:
                {
                    NSString *cellIdentifier = @"AddressIdentifier";
                    AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                    if(cell == nil){
                        [tableView registerNib:[UINib nibWithNibName:@"AddressCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
                        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.cityField.tag = 1;
                    cell.addressField.tag = 2;
                    cell.cityField.delegate = self;
                    cell.addressField.delegate = self;
                    cell.cityField.inputView = _pickerView;
                    cell.cityField.inputAccessoryView = _toolbar;
                    cell.cityField.placeholder = @"請選擇縣市";
                    cell.addressField.placeholder = @"請輸入地址";
                    [cell.addressField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
                    
                    self.cityField = cell.cityField;
                    self.addressField = cell.addressField;
                    //TODO:
                    if (memberData != nil) {
                        cell.cityField.text = memberData.city;
                        cell.addressField.text = memberData.address;
                    }
                    return cell;
                }
                    break;
                case 5:
                    [cell.contentView addSubview:_emailField];
                    break;
                case 6:
                    [cell.contentView addSubview:_phoneField];
                    break;
                default:
                    break;
            }
        }
        
        
        return cell;
    }
    
    if(indexPath.section == 1) {
        NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)indexPath.row,(long)indexPath.section];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"手機電話";
                cell.accessoryView = _phoneField;
                break;
                
            default:
                break;
        }
        
        return cell;
    }
    
    [NSException raise:@"Unexpected cell index" format:@"Unexpected cell index for row :%ld ,section:%ld",(long)indexPath.row,indexPath.section] ;
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 9) {
        return 88.0f;
    }
    
    return 44.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.000001f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 2) return 20;
    return 10.0f; //removing section footers
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 14;
            
        case 1:
            return 0;
            
        default:
            break;
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

#pragma mark UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    targetField = textField;
    if([textField isEqual:_genderField]){
        pickerArray = genderArray;
        [_pickerView reloadAllComponents];
        [_pickerView selectRow:genderSelectNum inComponent:0 animated:NO];
        textField.text = [pickerArray objectAtIndex:genderSelectNum];
    }
    else if(textField.tag == 1){
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
        }else{
            targetField.text = [pickerArray objectAtIndex:row];
        }
        
        if([targetField isEqual:_genderField]){
            genderSelectNum = row;
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
    memberData.address = _addressField.text;
    NSLog(@"birthdatyField = %@",_birthdayField.text);
    memberData.birthday = _birthdayField.text;
    memberData.city = _cityField.text;
    memberData.mobilephone = _phoneField.text;
    memberData.firstName = _firstNameField.text;
    memberData.lastName = _lastNameField.text;
    memberData.sex = _genderField.text;
}

-(void)doneBtn:(UIBarButtonItem *)sender
{
    
    [targetField resignFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
