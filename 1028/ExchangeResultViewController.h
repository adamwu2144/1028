//
//  ExchangeResultViewController.h
//  1028
//
//  Created by fg on 2017/6/23.
//  Copyright © 2017年 fg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExchangeClass.h"

@interface ExchangeResultViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *exchangeStatusView;
@property (strong, nonatomic) IBOutlet UIImageView *exchangeStatusImage;
@property (strong, nonatomic) IBOutlet UILabel *exchangeStatusLabel;
@property (strong, nonatomic) IBOutlet UIImageView *productImage;
@property (strong, nonatomic) IBOutlet UILabel *productTitle;
@property (strong, nonatomic) IBOutlet UILabel *exchangePointsLabel;

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withExchangeClass:(ExchangeClass *)exchangeClass;

@end
