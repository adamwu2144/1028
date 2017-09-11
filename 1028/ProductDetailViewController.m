//
//  ProductDetailViewController.m
//  1028
//
//  Created by fg on 2017/8/25.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "ProducAnimation.h"
#import "../Framework/SDWebImage/UIImageView+WebCache.h"


@interface ProductDetailViewController ()<UIViewControllerTransitioningDelegate>

@property(strong, nonatomic)ProducAnimation *producAnimation;

@end

@implementation ProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.transitioningDelegate = self;
    self.modalPresentationStyle = UIModalPresentationCustom;
    [self.view setBackgroundColor:[UIColor redColor]];
    self.producAnimation = [[ProducAnimation alloc] init];
    
    
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:self.productItem.productImage]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    self.producAnimation.type = JLPresentOneTransitionTypePresent;
    return self.producAnimation;
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    self.producAnimation.type = JLPresentOneTransitionTypeDismiss;

    return self.producAnimation;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)dismissBtnClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
