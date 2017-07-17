//
//  MemberRulesViewController.m
//  1028
//
//  Created by fg on 2017/6/20.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "MemberRulesViewController.h"
#import "ApiBuilder.h"
#import "RegisterViewController.h"

@interface MemberRulesViewController (){
    NSString *fbID;
}

@end

@implementation MemberRulesViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil fbid:(NSString *)fbid{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        fbID = fbid;
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [self initNavi];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.webView setRequestWithURL:[ApiBuilder getContract]];
    [self.cancelBtn.layer setCornerRadius:20.0f];
    [self.cancelBtn.layer setBorderColor:DEFAULT_COLOR.CGColor];
    [self.cancelBtn.layer setBorderWidth:1.0f];
    
    [self.confirmBtn.layer setCornerRadius:20.0f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNavi{
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButtonItem];
    
    UIImage *logoImage = [UIImage imageNamed:@"logo_s"];
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:logoImage];
    [logoImageView setFrame:CGRectMake(0, 0, 120, 33)];
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.navigationItem setTitleView:logoImageView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)BtnClicked:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    if (button.tag == 0) {
        NSLog(@"cancel");
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        NSLog(@"confrim");
        RegisterViewController *registerViewController = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil fbid:fbID];
        [self.navigationController pushViewController:registerViewController animated:YES];
        
    }
}
@end
