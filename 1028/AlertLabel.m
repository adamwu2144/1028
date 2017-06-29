//
//  AlertLabel.m
//  FG
//
//  Created by Kenny on 2015/8/20.
//  Copyright (c) 2015年 FG. All rights reserved.
//

#import "AlertLabel.h"

@implementation AlertLabel

+(void)ShowAlertInView:(UIView *)view alertMessage:(NSString *)msg;
{
    CGSize size1 = [msg sizeWithFont:[UIFont boldSystemFontOfSize:17.0f]
                            constrainedToSize:CGSizeMake(200, 900)];
    
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, size1.height + 40)];
    backgroundView.layer.borderWidth = 1;
    backgroundView.layer.borderColor = [UIColor colorWithRed:245.0/255.0 green:146.0/255.0 blue:145.0/255.0 alpha:1].CGColor;
    backgroundView.backgroundColor = [UIColor whiteColor];
    backgroundView.layer.cornerRadius = 5;
    backgroundView.clipsToBounds = YES;
    CGPoint centerPoint = view.center;
    backgroundView.center = centerPoint;
    
    UILabel *alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 200, size1.height)];
    alertLabel.textColor = [UIColor colorWithRed:245.0/255.0 green:146.0/255.0 blue:145.0/255.0 alpha:1];
    CGPoint labelCenter = CGPointMake(250 / 2, alertLabel.center.y);
    alertLabel.center = labelCenter;
    alertLabel.textAlignment = NSTextAlignmentCenter;
    alertLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    alertLabel.text = msg;
    alertLabel.backgroundColor = [UIColor clearColor];
    alertLabel.numberOfLines = 0;
    
    [backgroundView addSubview:alertLabel];
    [view addSubview:backgroundView];
    [UIView animateWithDuration:2 animations:^{
        backgroundView.alpha = 1.1;
    }completion:^(BOOL finished){
        [backgroundView removeFromSuperview];
    }];
}

@end
