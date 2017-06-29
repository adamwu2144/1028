//
//  AttestationCheckViewController.h
//  1028
//
//  Created by fg on 2017/5/31.
//  Copyright © 2017年 fg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttestationCheckViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *confirmBtn;
@property (strong, nonatomic) IBOutlet UIButton *resetBtn;
@property (strong, nonatomic) IBOutlet TextFieldNoMenu *AttestationTextField;
@property (strong, nonatomic) IBOutlet UIButton *resendBtn;
- (IBAction)ConfirmBtnClicked:(id)sender;
- (IBAction)resetBtnClicked:(id)sender;
- (IBAction)resendBtnClicked:(id)sender;


@end
