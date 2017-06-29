//
//  ExchangeCell.h
//  1028
//
//  Created by fg on 2017/6/19.
//  Copyright © 2017年 fg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExchangeCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *productImageView;
@property (strong, nonatomic) IBOutlet UILabel *productTitle;
@property (strong, nonatomic) IBOutlet UILabel *productExchangePoints;
@property (strong, nonatomic) IBOutlet UIButton *exchangeButton;

@end
