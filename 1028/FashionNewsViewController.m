//
//  FashionNewsViewController.m
//  1028
//
//  Created by fg on 2017/6/8.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "FashionNewsViewController.h"
#import "MenuViewController.h"

@interface FashionNewsViewController ()

@end

@implementation FashionNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initMyNavigation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated{
    MenuViewController *menuViewController = (MenuViewController *)PublicAppDelegate.drawer.leftViewController;
    menuViewController.previousRow = -1;
}

-(void)initMyNavigation{
    
    UIImage *logoImage = [UIImage imageNamed:@"logo_s"];
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:logoImage];
    
    [self.navigationItem setTitleView:logoImageView];
    
//    [self setNaviCancelBtn];
    
}

-(void) setNaviCancelBtn{
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(0, 20, 25, 25)];
    [cancelBtn addTarget:self action:@selector(cancelHandler:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"btn_del"] forState:UIControlStateNormal];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, cancelItem]];
    
}

-(void)cancelHandler:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
