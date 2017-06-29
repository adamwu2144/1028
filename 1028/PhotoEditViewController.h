//
//  PhotoEditViewController.h
//  FG
//
//  Created by Kenny on 2015/4/28.
//  Copyright (c) 2015年 FG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberSettingViewController.h"

@protocol PhotoEditDelegate <NSObject>
-(void)completedEditImg:(UIImage *)img;
@end

@interface PhotoEditViewController : UIViewController
@property (nonatomic, strong) UIImageView *editImageView;
@property (weak) id<PhotoEditDelegate> photoEditDelegate;
-(instancetype)initWithImg:(UIImage *)img changType:(ChangePhotoType)changeType;
@end
