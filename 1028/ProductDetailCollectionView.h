//
//  ProductDetailCollectionView.h
//  1028
//
//  Created by fg on 2017/8/25.
//  Copyright © 2017年 fg. All rights reserved.
//

@class ProductTransitionAnimtor;

#import <UIKit/UIKit.h>

@interface ProductDetailCollectionView : UIViewController
@property (strong, nonatomic) IBOutlet UICollectionView *mainCollectionView;
@property(strong, nonatomic) NSMutableArray *productItems;
@property (strong, nonatomic) NSIndexPath *productIndexPath;
@property(strong,nonatomic)ProductTransitionAnimtor *productTransitionAnimtor;
@end
