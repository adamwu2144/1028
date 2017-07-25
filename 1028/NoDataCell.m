//
//  NoDataCell.m
//  1028
//
//  Created by fg on 2017/7/17.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "NoDataCell.h"

@implementation NoDataCell

-(void)prepareForReuse{
    self.messageLabel.text = @"";
    [super prepareForReuse];

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
