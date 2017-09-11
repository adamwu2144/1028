//
//  ProductCollectionViewCell.h
//  1028
//
//  Created by fg on 2017/5/3.
//  Copyright © 2017年 fg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *productImageView;
@property (strong, nonatomic) IBOutlet UILabel *productInfoLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *hight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *uiimageviewRightDistance;

@end
