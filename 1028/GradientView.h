//
//  GradientView.h
//  1028
//
//  Created by fg on 2017/6/1.
//  Copyright © 2017年 fg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GradientView : UIView

@property(nonatomic, strong)UIColor *firstColor;
@property(nonatomic, strong)UIColor *secondColor;

-(void)setViewFirstColor:(UIColor *)firstColor secondColor:(UIColor *)aSecondColor;
@end
