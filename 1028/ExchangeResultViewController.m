//
//  ExchangeResultViewController.m
//  1028
//
//  Created by fg on 2017/6/23.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "ExchangeResultViewController.h"
#import "MyManager.h"
#import "MBProgressHUD.h"
#import "../Framework/SDWebImage/UIImageView+WebCache.h"
#import "ApiBuilder.h"
#import "../Framework/AFNetworking/AFHTTPSessionManager.h"

@interface ExchangeResultViewController (){
    BOOL status;
    ExchangeClass *myExchangeClass;
}

@end

@implementation ExchangeResultViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withExchangeClass:(ExchangeClass *)exchangeClass{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        myExchangeClass = exchangeClass;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    status = NO;
    [self.exchangeStatusView.layer setCornerRadius:self.exchangeStatusView.frame.size.height/2];
    [self.productImage sd_setImageWithURL:[NSURL URLWithString:myExchangeClass.productImage]];
    self.productTitle.text = myExchangeClass.productTitle;
    
    NSMutableAttributedString *pointString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"兌換點數 %@",myExchangeClass.productPoints]];
    
    UIFont *font = [UIFont systemFontOfSize:24.0f weight:5.0f];
    
    [pointString addAttribute:NSFontAttributeName value:font range:NSMakeRange(5, [myExchangeClass.productPoints stringValue].length)];
    [pointString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:240.0/255.0 green:145.0/255.0 blue:146.0/255.0 alpha:1.0]range:NSMakeRange(5,[myExchangeClass.productPoints stringValue].length)];
    self.exchangePointsLabel.attributedText = pointString;
    
    [self initData];
    // Do any additional setup after loading the view from its nib.
}

-(void)initCusView:(NSString *)message{
    if(status){
        self.exchangeStatusImage.image = [UIImage imageNamed:@"iconCelebrate"];
        [self.exchangeStatusView setBackgroundColor:[UIColor clearColor]];
        [self.exchangeStatusView.layer setBorderColor:DEFAULT_COLOR.CGColor];
        [self.exchangeStatusView.layer setBorderWidth:1.0f];
        self.exchangeStatusLabel.textColor = DEFAULT_COLOR;
        self.exchangeStatusLabel.text = message;
    }
    else{
        self.exchangeStatusImage.image = [UIImage imageNamed:@"warning"];
        [self.exchangeStatusView setBackgroundColor:DEFAULT_GARY_COLOR];
        [self.exchangeStatusView.layer setBorderColor:DEFAULT_GARY_COLOR.CGColor];
        [self.exchangeStatusView.layer setBorderWidth:0.0f];
        self.exchangeStatusLabel.textColor = [UIColor whiteColor];
        self.exchangeStatusLabel.text = message;
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)initData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[MyManager shareManager] requestWithMethod:POST WithPath:[ApiBuilder getProductExchange:[myExchangeClass.productid intValue]] WithParams:nil WithSuccessBlock:^(NSDictionary *dic) {
        NSLog(@"dic = %@",dic);
        if (dic) {
            status = YES;
            [self initCusView:@"兌換成功"];
        }
    } WithFailurBlock:^(NSError *error, int statusCode) {
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
        NSString *message = [serializedData objectForKey:@"message"];
        NSString *code = [serializedData objectForKey:@"code"];
        if ([code intValue] == 301 || [code intValue] == 302) {
            status = NO;
            [self initCusView:message];
        }
    }];
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

@end
