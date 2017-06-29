//
//  MemberSettingViewController.h
//  1028
//
//  Created by fg on 2017/6/2.
//  Copyright © 2017年 fg. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MemberSettingViewController : UIViewController

typedef NS_ENUM(NSInteger, ChangePhotoType) {
    PhotoSticker = 0,
    PhotoBackground
};

@property (strong, nonatomic) IBOutlet UIImageView *memberPicture;
@property (strong, nonatomic) IBOutlet UILabel *memberName;
@property (strong, nonatomic) IBOutlet UILabel *memberLevel;
@property (strong, nonatomic) IBOutlet UIButton *changeMemberPictureButton;
@property (strong, nonatomic) IBOutlet TextFieldNoMenu *cityTextField;
@property (strong, nonatomic) IBOutlet TextFieldNoMenu *addressTextField;
@property (strong, nonatomic) IBOutlet TextFieldNoMenu *mobileTextField;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;
@property (strong, nonatomic) IBOutlet UIScrollView *memberSettingScrollView;
@property (strong, nonatomic) IBOutlet TextFieldNoMenu *emailTextField;
@property (strong, nonatomic) IBOutlet TextFieldNoMenu *birthdayField;
@property (strong, nonatomic) IBOutlet UIButton *girlButton;
@property (strong, nonatomic) IBOutlet UIButton *boyButton;

@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIToolbar *toolBar;


- (IBAction)changeBtnClicked:(id)sender;
- (IBAction)confirmBtnClicked:(id)sender;
- (IBAction)genderBtnClicked:(id)sender;


@end
