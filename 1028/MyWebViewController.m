//
//  MyWebViewController.m
//  1028
//
//  Created by fg on 2017/6/8.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "MyWebViewController.h"
#import "MenuViewController.h"

@interface MyWebViewController (){
    NSString *urlString;
}

@end

@implementation MyWebViewController

-(void)willMoveToParentViewController:(UIViewController *)parent{
    if (parent == NULL) {
        if ([self.delegate respondsToSelector:@selector(doRefreshParentContent)]) {
            [self.delegate doRefreshParentContent];
        }
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButtonItem];
    
    UIImageView *logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_s"]];
    [logoImage setFrame:CGRectMake(0, 0, 120, 33)];
    logoImage.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.navigationItem setTitleView:logoImage];
}

-(void)viewDidDisappear:(BOOL)animated{
    MenuViewController *menuViewController = (MenuViewController *)PublicAppDelegate.drawer.leftViewController;
    menuViewController.previousRow = -1;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withURL:(NSString *)url{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        urlString = url;
        [self.myWebView setBackgroundColor:[UIColor clearColor]];
        [self.myWebView setOpaque:NO];
    }
    return self;
}

-(void)setMyWebViewRequestURL:(NSString *)newURL{
    [self.myWebView setRequestWithURL:newURL];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.myWebView setRequestWithURL:urlString];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
