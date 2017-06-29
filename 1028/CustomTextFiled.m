//
//  testTextFiled.m
//  FG
//
//  Created by fg on 2015/6/17.
//  Copyright (c) 2015年 FG. All rights reserved.
//

#import "CustomTextFiled.h"

@implementation CustomTextFiled

- (instancetype)initWithRightViewData:(NSString *)rightViewName leftView:(NSString *)leftViewName placeHolder:(NSString *)placeHolderString type:(textFiledType)aType{
    self = [super init];
    if (self) {
        self.leftImageName = leftViewName;
        self.rightImageName = rightViewName;
        self.placeHolderStr = placeHolderString;
        type = aType;
        [self setBackgroundColor:[UIColor whiteColor]];

    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code

    [self initMyView];
}

//-(UIEdgeInsets)layoutMargins{
//    return UIEdgeInsetsMake(0, 38, 0, 18);
//}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return [self rectForBounds:bounds];
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return [self rectForBounds:bounds];
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self rectForBounds:bounds];
}

- (CGRect)rectForBounds:(CGRect)bounds {
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 38, 0, 18);
    return UIEdgeInsetsInsetRect(bounds, insets);
//    return CGRectInset(bounds, insets);
}


-(void)initMyView{
    [self setPlaceholder:_placeHolderStr];
    [self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self setAdjustsFontSizeToFitWidth:YES];
    [self setMinimumFontSize:20.0f];
    [self setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self setAutocapitalizationType:UITextAutocapitalizationTypeNone];

    CGRect leftIconFrame = CGRectZero;
        
    switch (type) {
        case textFiledTypeEmail:
            leftIconFrame = CGRectMake(12, 15, 15, 11);
            [self setKeyboardType:UIKeyboardTypeEmailAddress];
            break;
        case textFiledTypePwd:
            leftIconFrame = CGRectMake(15, 16, 10, 12);
            [self setSecureTextEntry:YES];
            break;
        case textFiledTypeNickName:
            leftIconFrame = CGRectMake(15, 14, 13, 13);
            break;
        default:
            break;
    }
    
    UIImageView *leftIconImgView = [[UIImageView alloc] initWithFrame:leftIconFrame];
    [leftIconImgView setImage:[UIImage imageNamed:_leftImageName]];
    UIView *leftPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 38, 44)];
    [leftPaddingView addSubview:leftIconImgView];
    [self setLeftView:leftPaddingView];
    [self setLeftViewMode:UITextFieldViewModeAlways];
    
    UIImageView *rightIconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 18, 8, 8)];
    [rightIconImgView setImage:[UIImage imageNamed:_rightImageName]];
    UIView *rightPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 19, 44)];
    [rightPaddingView addSubview:rightIconImgView];
    [self setRightView:rightPaddingView];
    [self setRightViewMode:UITextFieldViewModeAlways];
    [self.rightView setHidden:YES];

    


    
}

@end
