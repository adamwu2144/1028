//
//  TaskMsgCell.m
//  1028
//
//  Created by fg on 2017/6/8.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "TaskMsgCell.h"
#import "MyManager.h"

@implementation TaskMsgCell

-(void)prepareForReuse{
    [super prepareForReuse];
    
    self.title.text = @"";
    self.content.text = @"";

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.taskMsgBGView.layer.shadowColor =DEFAULT_GARY_COLOR.CGColor;
    self.taskMsgBGView.layer.shadowOffset = CGSizeMake(0, 4.0f);
    
    self.taskMsgBGView.layer.shadowOpacity = 0.4f;
    self.taskMsgBGView.layer.masksToBounds = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
