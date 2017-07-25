//
//  ActivityDetailViewController.h
//  FG
//
//  Created by fg on 2016/1/26.
//  Copyright © 2016年 FG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitImageView.h"
#import "TaskClass.h"


@class ShareButtonView,MCTaskClass,ActivityDetailClass;

@protocol ActivityDetailViewControllerDelegate <NSObject>

@optional

-(void)doRefreshTaskContent:(TaskClass *)taskClass;
-(void)doRefreshBeaconContent:(TaskClass *)taskClass;

@end

@interface ActivityDetailViewController : UIViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property(weak, nonatomic)IBOutlet FitImageView *activityImageView;
@property(weak, nonatomic)IBOutlet UILabel *activityContentLabel;
@property (weak, nonatomic) IBOutlet UIButton *activityButton;
@property (weak, nonatomic) IBOutlet UIButton *scrollToTopBtn;
@property (weak, nonatomic) IBOutlet ShareButtonView *shareBtnView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *buttonHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *buttonDistance;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *activityImageViewheight;
@property (strong, nonatomic) IBOutlet UILabel *activityURLLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *containerHight;

@property (nonatomic,weak) id <ActivityDetailViewControllerDelegate> delegate;
@property (nonatomic, strong)ActivityDetailClass *activityDetailClass;
;

- (IBAction)handleBtnClick:(id)sender;

-(id)initWithActivityTaskClass:(TaskClass *)taskClass;
-(void)doRefreshContent;

@end
