//
//  MemberViewController.h
//  1028
//
//  Created by fg on 2017/6/1.
//  Copyright © 2017年 fg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperMainViewController.h"
#import "GradientView.h"

@interface MemberViewController : SuperMainViewController
@property (strong, nonatomic) IBOutlet GradientView *DetailView;
@property (strong, nonatomic) IBOutlet GradientView *numberView;
@property (strong, nonatomic) IBOutlet GradientView *settingView;

-(void)showLoginView;

@end
