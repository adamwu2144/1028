//
//  ShakeViewController.h
//  1028
//
//  Created by fg on 2017/6/9.
//  Copyright © 2017年 fg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyWebView.h"
#import "ActivityDetailClass.h"

@protocol ShakeViewControllerDelegate <NSObject>

-(void)doRefreshContent;

@end

@interface ShakeViewController : UIViewController
@property (strong, nonatomic) IBOutlet MyWebView *myWebView;
@property (strong, nonatomic) IBOutlet UIImageView *shakeImageView;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;

@property (nonatomic,weak) id <ShakeViewControllerDelegate> delegate;

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withTask:(ActivityDetailClass *)aTask withBeacon:(BOOL)aBeacon;
-(void)checkLocationPremission;
@end
