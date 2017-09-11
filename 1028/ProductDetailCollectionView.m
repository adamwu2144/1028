//
//  ProductDetailCollectionView.m
//  1028
//
//  Created by fg on 2017/8/25.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "ProductDetailCollectionView.h"
#import "ProductCollectionViewCell.h"
#import "MyManager.h"
#import "ApiBuilder.h"
#import "ProductItem.h"
#import "../Framework/SDWebImage/UIImageView+WebCache.h"
#import "ProductTransitionAnimtor.h"

@interface ProductDetailCollectionView ()<UIViewControllerTransitioningDelegate>

@end

@implementation ProductDetailCollectionView

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.transitioningDelegate= self;
//    self.modalPresentationStyle = UIModalPresentationCustom;
    self.mainCollectionView.backgroundColor = [UIColor clearColor];
    
    self.productTransitionAnimtor = [[ProductTransitionAnimtor alloc] init];

    
    //    [self.mainCollectionView registerClass:[ProductCollectionViewCell class] forCellWithReuseIdentifier:@"ProductCellIdentifier"];
    UINib *nib = [UINib nibWithNibName:@"ProductCollectionViewCell" bundle: nil];
    [self.mainCollectionView registerNib:nib forCellWithReuseIdentifier:@"ProductCellIdentifier"];
    
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.dataSource = self;
    [self.mainCollectionView setPagingEnabled:YES];
    [self.mainCollectionView setBackgroundColor:[UIColor blackColor]];
    
    NSLog(@"indexpath.row = %ld",(long)self.productIndexPath.row);
    [self.mainCollectionView layoutIfNeeded];
    [self.mainCollectionView scrollToItemAtIndexPath:self.productIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    ProductCollectionViewCell *targetCell = (ProductCollectionViewCell *)[self.mainCollectionView cellForItemAtIndexPath:self.productIndexPath];
    NSLog(@"viewDidLoad = %@",NSStringFromCGRect(targetCell.productImageView.frame));
    
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    ProductCollectionViewCell *targetCell = (ProductCollectionViewCell *)[self.mainCollectionView cellForItemAtIndexPath:self.productIndexPath];
    NSLog(@"viewDidLayoutSubviews = %@",NSStringFromCGRect(targetCell.productImageView.frame));

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
    NSLog(@"indexPath .row 2 = %ld",(long)indexPath.row);
    ProductCollectionViewCell *cell = (ProductCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ProductCellIdentifier" forIndexPath:indexPath];
    [cell.contentView setBackgroundColor:[UIColor yellowColor]];
    cell.productInfoLabel.text = [NSString stringWithFormat:@"{%ld,%ld}",(long)indexPath.section,(long)indexPath.row];
//    CGFloat red = arc4random() % 255;
//    CGFloat green = arc4random() % 255;
//    CGFloat blue = arc4random() % 255;
//    UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0f];
    
    ProductItem *procuctItem = [_productItems objectAtIndex:indexPath.row];
    [cell.productImageView sd_setImageWithURL:[NSURL URLWithString:procuctItem.productImage]];
    
    NSLog(@"%@",NSStringFromCGRect(cell.productImageView.frame));
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"width = %f",self.mainCollectionView.frame.size.width-30/2);
    //    return CGSizeMake((self.mainCollectionView.frame.size.width-25)/2, 200);
    return CGSizeMake([UIScreen mainScreen].bounds.size.width+20, [UIScreen mainScreen].bounds.size.height-100);
    //    return CGSizeMake((self.mainCollectionView.frame.size.width-25), 200);
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 0, 10, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductCollectionViewCell *cell = (ProductCollectionViewCell *)[self.mainCollectionView cellForItemAtIndexPath:indexPath];
    NSLog(@"cell frame = %@",NSStringFromCGRect(cell.productImageView.frame));
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    NSLog(@"animationControllerForPresentedController");

    return self.productTransitionAnimtor;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return nil;
}

@end
