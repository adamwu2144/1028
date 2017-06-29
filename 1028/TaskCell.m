//
//  TaskCell.m
//  1028
//
//  Created by fg on 2017/6/1.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "TaskCell.h"
#import "../Framework/SDWebImage/UIImageView+WebCache.h"

@implementation TaskCell

-(void)prepareForReuse{
    self.taskTitle.text = @"";
    self.taskStatus.text = @"";
    [self.taskImageView setImage:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleBGView.layer.shadowColor =DEFAULT_GARY_COLOR.CGColor;
    self.titleBGView.layer.shadowOffset = CGSizeMake(0, 4.0f);
    
    self.titleBGView.layer.shadowOpacity = 0.4f;
    self.titleBGView.layer.masksToBounds = NO;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
