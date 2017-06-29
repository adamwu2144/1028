//
//  testTextFiled.h
//  FG
//
//  Created by fg on 2015/6/17.
//  Copyright (c) 2015年 FG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum textFiledType{
    textFiledTypeEmail = 0,
    textFiledTypePwd,
    textFiledTypeNickName,
} textFiledType;

@interface CustomTextFiled : UITextField{
    textFiledType type;
}

@property(weak,nonatomic)NSString *leftImageName;
@property(weak,nonatomic)NSString *rightImageName;
@property(weak,nonatomic)NSString *placeHolderStr;

- (instancetype)initWithRightViewData:(NSString *)rightViewName leftView:(NSString *)leftViewName placeHolder:(NSString *)placeHolderString type:(textFiledType)aType;
@end