//
//  NotificationCell.m
//  1028
//
//  Created by fg on 2017/6/26.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "NotificationCell.h"

@implementation NotificationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.readStatusLabel.layer setBorderColor:self.readStatusLabel.textColor.CGColor];
    [self.readStatusLabel.layer setBorderWidth:1.0f];
    [self.readStatusLabel.layer setCornerRadius:13.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
