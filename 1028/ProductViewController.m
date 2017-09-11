//
//  ProductViewController.m
//  1028
//
//  Created by fg on 2017/5/3.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "ProductViewController.h"
#import "ProductCollectionViewCell.h"
#import "MyManager.h"
#import "ApiBuilder.h"
#import "ProductItem.h"
#import "../Framework/SDWebImage/UIImageView+WebCache.h"
#import "ProductDetailCollectionView.h"
#import "ProductDetailViewController.h"

@interface ProductViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation ProductViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mainCollectionView.backgroundColor = [UIColor clearColor];
    
//    [self.mainCollectionView registerClass:[ProductCollectionViewCell class] forCellWithReuseIdentifier:@"ProductCellIdentifier"];
    UINib *nib = [UINib nibWithNibName:@"ProductCollectionViewCell" bundle: nil];
    [self.mainCollectionView registerNib:nib forCellWithReuseIdentifier:@"ProductCellIdentifier"];
    
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.dataSource = self;
    [self.mainCollectionView setBackgroundColor:[UIColor blackColor]];
    
    self.productItems = [[NSMutableArray alloc] init];
    
    [[MyManager shareManager] requestWithMethod:GET WithPath:[ApiBuilder getProductsByCategory:1] WithParams:nil WithSuccessBlock:^(NSDictionary *dic) {
        self.productItems = [ProductItem initWithArray:[dic objectForKey:@"items"]];
    
        [self.mainCollectionView reloadData];
        NSLog(@"self.productItems = %lu",(unsigned long)[self.productItems count]);
    } WithFailurBlock:^(NSError *error, int statusCode) {
        
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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _productItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ProductCollectionViewCell *cell = (ProductCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ProductCellIdentifier" forIndexPath:indexPath];
    [cell.contentView setBackgroundColor:[UIColor redColor]];
    cell.productInfoLabel.text = [NSString stringWithFormat:@"{%ld,%ld}",(long)indexPath.section,(long)indexPath.row];
    CGFloat red = arc4random() % 255;
    CGFloat green = arc4random() % 255;
    CGFloat blue = arc4random() % 255;
    UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0f];
    
//    cell.productImageView.backgroundColor = color;
    ProductItem *procuctItem = [_productItems objectAtIndex:indexPath.row];
    [cell.productImageView sd_setImageWithURL:[NSURL URLWithString:procuctItem.productImage]];
    cell.uiimageviewRightDistance.constant = 0;
    NSString *msg = cell.productInfoLabel.text;
    NSLog(@"%@",msg);
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"width = %f",self.mainCollectionView.frame.size.width-30/2);
    return CGSizeMake((self.mainCollectionView.frame.size.width-25)/2, 200);
//    return CGSizeMake((self.mainCollectionView.frame.size.width-25), 200);

}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.currentIndexPath = indexPath;
    
    
    ProductCollectionViewCell *cell = (ProductCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    
    ProductDetailViewController *productDetailViewController = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:nil];
    
    productDetailViewController.productItem = [self.productItems objectAtIndex:indexPath.row];
    
    [self presentViewController:productDetailViewController animated:YES completion:^{

    }];
    
    
//    ProductCollectionViewCell *cell = (ProductCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    NSString *msg = cell.productInfoLabel.text;
//    NSLog(@"%@",msg);
//    
//    ProductDetailCollectionView *productDetailCollectionView = [[ProductDetailCollectionView alloc] initWithNibName:@"ProductDetailCollectionView" bundle:nil];
//    productDetailCollectionView.productItems = self.productItems;
//    productDetailCollectionView.productIndexPath = indexPath;
//
//    [self presentViewController:productDetailCollectionView animated:YES completion:^{
////        [productDetailCollectionView.mainCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
//
//    }];
    
}


//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
//    //这里我们初始化dismissType
//    return ;
//}


@end
