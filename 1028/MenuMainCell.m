//
//  MenuMainCell.m
//  1028
//
//  Created by fg on 2017/5/25.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "MenuMainCell.h"

@implementation MenuMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
