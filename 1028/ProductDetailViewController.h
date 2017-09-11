//
//  ProductDetailViewController.h
//  1028
//
//  Created by fg on 2017/8/25.
//  Copyright © 2017年 fg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductItem.h"

@interface ProductDetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *productImageView;
@property (strong, nonatomic) ProductItem *productItem;
- (IBAction)dismissBtnClicked:(id)sender;

@end
