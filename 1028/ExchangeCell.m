//
//  ExchangeCell.m
//  1028
//
//  Created by fg on 2017/6/19.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "ExchangeCell.h"

@implementation ExchangeCell

-(void)prepareForReuse{
    [super prepareForReuse];
    self.productTitle.text = @"";
    self.productExchangePoints.text = @"";
    [self.productImageView setImage:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.exchangeButton.layer setCornerRadius:20.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
