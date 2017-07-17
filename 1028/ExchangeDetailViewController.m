//
//  ExchangeDetailViewController.m
//  1028
//
//  Created by fg on 2017/6/23.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "ExchangeDetailViewController.h"
#import "MyManager.h"
#import "MBProgressHUD.h"
#import "ExchangeClass.h"
#import "../Framework/SDWebImage/UIImageView+WebCache.h"
#import "ExchangeResultViewController.h"

@interface ExchangeDetailViewController (){
    int product_id;
    ExchangeClass *exchangeClass;
}

@end

@implementation ExchangeDetailViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withProductID:(int)productID{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        product_id = productID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initNavi];
    [self initCusView];
    [self initData];
}

-(void)initNavi{
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButtonItem];
    UIImageView *logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_s"]];
    [logoImage setFrame:CGRectMake(0, 0, 120, 33)];
    logoImage.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.navigationItem setTitleView:logoImage];
}

-(void)initCusView{
    [self.cancelBtn.layer setCornerRadius:20.0f];
    [self.cancelBtn.layer setBorderColor:self.cancelBtn.titleLabel.textColor.CGColor];
    [self.cancelBtn.layer setBorderWidth:1.0f];
    [self.confirmBtn.layer setCornerRadius:20.0f];
}

-(void)initData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[MyManager shareManager] requestWithMethod:GET WithPath:[ApiBuilder getProductDetail:product_id] WithParams:nil WithSuccessBlock:^(NSDictionary *dic) {
        exchangeClass = [[ExchangeClass alloc] init];
        exchangeClass.productid = [[dic objectForKey:@"items"] objectForKey:@"id"];
        exchangeClass.productTitle = [[dic objectForKey:@"items"] objectForKey:@"title"];
        exchangeClass.productDescription = [[dic objectForKey:@"items"] objectForKey:@"description"];
        exchangeClass.productImage = [[dic objectForKey:@"items"] objectForKey:@"image"];
        exchangeClass.productPoints = [[dic objectForKey:@"items"] objectForKey:@"points"];
        [self setData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    } WithFailurBlock:^(NSError *error, int statusCode) {
        
    }];
}

-(void)setData{
    self.productTitle.text = exchangeClass.productTitle;
    self.productDescription.text = exchangeClass.productDescription;
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:exchangeClass.productImage]];
    
    NSMutableAttributedString *pointString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"兌換點數 %@",exchangeClass.productPoints]];
    
    UIFont *font = [UIFont systemFontOfSize:24.0f weight:5.0f];
    
    [pointString addAttribute:NSFontAttributeName value:font range:NSMakeRange(5, [exchangeClass.productPoints stringValue].length)];
    [pointString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:240.0/255.0 green:145.0/255.0 blue:146.0/255.0 alpha:1.0]range:NSMakeRange(5,[exchangeClass.productPoints stringValue].length)];
    self.exchangePointsLabel.attributedText = pointString;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(btn.tag == 1){
        
        ExchangeResultViewController *exchangeResultViewController = [[ExchangeResultViewController alloc] initWithNibName:@"ExchangeResultViewController" bundle:nil withExchangeClass:exchangeClass];
        [self.navigationController pushViewController:exchangeResultViewController animated:YES];
    }
}
@end
