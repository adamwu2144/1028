//
//  TaskCell.h
//  1028
//
//  Created by fg on 2017/6/1.
//  Copyright © 2017年 fg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *taskImageView;
@property (strong, nonatomic) IBOutlet UILabel *taskTitle;
@property (strong, nonatomic) IBOutlet UILabel *taskStatus;
@property (strong, nonatomic) IBOutlet UIView *titleBGView;

@end
