//
//  ProducAnimation.m
//  1028
//
//  Created by fg on 2017/8/25.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "ProducAnimation.h"
#import "ProductViewController.h"
#import "ProductDetailViewController.h"
#import "ProductCollectionViewCell.h"

@implementation ProducAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return self.type == JLPresentOneTransitionTypePresent ? 0.5 : 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    switch (self.type) {
        case JLPresentOneTransitionTypePresent:
            [self presentAnimation:transitionContext];
            break;
            
        case JLPresentOneTransitionTypeDismiss:
            [self dismissAnimation:transitionContext];
            break;
    }
}

- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIView *containerView = [transitionContext containerView];
    
    ProductDetailViewController *toVC = (ProductDetailViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    ProductViewController *fromVC = (ProductViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    ProductCollectionViewCell *fromVCCell = (ProductCollectionViewCell *)[fromVC.mainCollectionView cellForItemAtIndexPath:fromVC.currentIndexPath];
    
    UIImageView *aniView = [[UIImageView alloc] init];
    aniView.image = fromVCCell.productImageView.image;
    aniView.frame = [fromVCCell.productImageView convertRect:fromVCCell.productImageView.bounds toView:toVC.view];
    
    CGRect endFrame = toVC.productImageView.frame;
    
    NSLog(@"aniView.des = %@,%@",[fromVCCell.productImageView.image description],[aniView.image  description]);
    
    [fromVCCell.productImageView setHidden:YES];
    toVC.view.alpha = 0.0f;
    [toVC.productImageView setHidden:YES];
    
    
    [containerView addSubview:toVC.view];
    [containerView addSubview:aniView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        aniView.frame = endFrame;
        toVC.view.alpha = 1.0f;
    } completion:^(BOOL finished) {
        aniView.hidden = YES;
        [toVC.productImageView setHidden:NO];
        
        [transitionContext completeTransition:YES];
    }];
}

- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIView *containerView = [transitionContext containerView];

    ProductDetailViewController *fromVC = (ProductDetailViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    ProductViewController *toVC = (ProductViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    ProductCollectionViewCell *toVCCell = (ProductCollectionViewCell *)[toVC.mainCollectionView cellForItemAtIndexPath:toVC.currentIndexPath];
    
    UIView *aniView = containerView.subviews.lastObject;
    
    [toVCCell.productImageView setHidden:YES];
    [fromVC.productImageView setHidden:YES];
    [aniView setHidden:NO];

    [containerView insertSubview:toVC.view atIndex:0];
    
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        aniView.frame = [toVCCell.productImageView convertRect:toVCCell.productImageView.bounds toView:toVC.view];
        [fromVC.view setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [aniView removeFromSuperview];
        [toVCCell.productImageView setHidden:NO];
        [transitionContext completeTransition:YES];
    }];
    
    
    
}

@end
