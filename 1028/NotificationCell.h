//
//  NotificationCell.h
//  1028
//
//  Created by fg on 2017/6/26.
//  Copyright © 2017年 fg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationCell : UITableViewCell

@property (assign, nonatomic) BOOL status;
@property (strong, nonatomic) IBOutlet UILabel *readStatusLabel;
@property (strong, nonatomic) IBOutlet UILabel *messageTitleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *comBinddShape;

@end
