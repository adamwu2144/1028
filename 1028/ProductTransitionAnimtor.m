//
//  ProductTransitionAnimtor.m
//  1028
//
//  Created by fg on 2017/8/25.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "ProductTransitionAnimtor.h"
#import "ProductViewController.h"
#import "ProductDetailCollectionView.h"
#import "ProductCollectionViewCell.h"

@implementation ProductTransitionAnimtor

-(instancetype)init{
    self = [super init];
    if (self) {
        _isPresentAnimationing = YES;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    return 0.3f;
    
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIView *productDetailView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    UIView *containerView = [transitionContext containerView];
    
    [containerView addSubview:productDetailView];
    
    ProductDetailCollectionView *productDetailCollectionView = (ProductDetailCollectionView *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    NSIndexPath *selectIndexPath = productDetailCollectionView.productIndexPath;
    
    ProductViewController *productViewController = (ProductViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UICollectionView *collectView = productViewController.mainCollectionView;
    
    ProductCollectionViewCell *selectCell = (ProductCollectionViewCell *)[collectView cellForItemAtIndexPath:selectIndexPath];
    
    UIImageView *animateView = [[UIImageView alloc] init];
    animateView.image = selectCell.productImageView.image;
//    animateView.contentMode = UIViewContentModeScaleAspectFill;
    animateView.clipsToBounds = YES;
    
    CGRect originFrame = [selectCell.productImageView convertRect:selectCell.productImageView.bounds toView:[UIApplication sharedApplication].keyWindow];
    animateView.frame  = originFrame;
    
    [containerView addSubview:animateView];
    
    [productDetailView setHidden:YES];
    [productDetailView setAlpha:0.0f];
    
    CGRect endFrame = CGRectZero;
    if (selectIndexPath.row == 0 || selectIndexPath.row == 1) {
        endFrame = CGRectMake(0, 21, SCREEN_WIDTH, 532.5);

    }
    else{
        endFrame = CGRectMake(0, 21, SCREEN_WIDTH, 553);
    }
    

    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        animateView.frame = endFrame;
        [productDetailView setAlpha:1.0f];
    } completion:^(BOOL finished) {
        [productDetailView setHidden:NO];
        [transitionContext completeTransition:YES];
        [animateView removeFromSuperview];
    }];
    
    
    
    
    
}

@end
