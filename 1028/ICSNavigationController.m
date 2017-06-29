//
//  ICSNavigationController.m
//  1028
//
//  Created by fg on 2017/6/8.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "ICSNavigationController.h"

@interface ICSNavigationController ()<UIGestureRecognizerDelegate>{

}

@end

@implementation ICSNavigationController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationBar.translucent = NO;
//    self.navigationBar.barTintColor = [UIColor colorWithRed:240.0/255.0 green:145.0/255.0 blue:146.0/255.0 alpha:1.0f];
    self.navigationBar.barTintColor = DEFAULT_COLOR;

    
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
//    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
