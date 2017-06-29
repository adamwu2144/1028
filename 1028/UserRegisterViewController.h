//
//  UserRegisterViewController.h
//  1028
//
//  Created by fg on 2017/5/22.
//  Copyright © 2017年 fg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldNoMenu.h"

@interface UserRegisterViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *personalTableView;

@property (nonatomic, strong) TextFieldNoMenu *firstNameField;
@property (nonatomic, strong) TextFieldNoMenu *lastNameField;
@property (nonatomic, strong) TextFieldNoMenu *birthdayField;
@property (nonatomic, strong) TextFieldNoMenu *emailField;
@property (nonatomic, strong) TextFieldNoMenu *phoneField;
@property (nonatomic, strong) TextFieldNoMenu *genderField;
@property (nonatomic, strong) TextFieldNoMenu *cityField;
@property (nonatomic, strong) TextFieldNoMenu *addressField;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIToolbar *toolbar;

@end
