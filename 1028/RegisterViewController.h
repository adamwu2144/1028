//
//  RegisterViewController.h
//  1028
//
//  Created by fg on 2017/5/24.
//  Copyright © 2017年 fg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIScrollView *regusterScrollView;
@property (strong, nonatomic) IBOutlet TextFieldNoMenu *firstName;
@property (strong, nonatomic) IBOutlet TextFieldNoMenu *lastName;
@property (strong, nonatomic) IBOutlet TextFieldNoMenu *birthdayField;
@property (strong, nonatomic) IBOutlet UIButton *girlButton;
@property (strong, nonatomic) IBOutlet UIButton *boyButton;
@property (strong, nonatomic) IBOutlet TextFieldNoMenu *addressField;
@property (strong, nonatomic) IBOutlet TextFieldNoMenu *regionField;
@property (strong, nonatomic) IBOutlet TextFieldNoMenu *emailField;
@property (strong, nonatomic) IBOutlet TextFieldNoMenu *phoneField;
@property (strong, nonatomic) IBOutlet UIButton *checkButton;
@property (strong, nonatomic) IBOutlet UITextView *checkTextView;
@property (strong, nonatomic) IBOutlet UIButton *registerMobileButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *textFieldContentHeight;

@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIToolbar *toolBar;

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil fbid:(NSString *)fbid;
- (IBAction)regusterButtonClicked:(id)sender;
- (IBAction)genderBtnClicked:(id)sender;
- (IBAction)checkBtnClicked:(id)sender;

@end
