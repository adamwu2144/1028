//
//  TaskMsgCell.h
//  1028
//
//  Created by fg on 2017/6/8.
//  Copyright © 2017年 fg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskMsgCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *content;
@property (strong, nonatomic) IBOutlet UIView *taskMsgBGView;

@end
