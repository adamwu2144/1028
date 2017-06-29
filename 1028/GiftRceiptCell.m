//
//  GiftRceiptCell.m
//  1028
//
//  Created by fg on 2017/6/16.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "GiftRceiptCell.h"

@implementation GiftRceiptCell

-(void)prepareForReuse{
    [super prepareForReuse];
    self.contentLabel.text = @"";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
