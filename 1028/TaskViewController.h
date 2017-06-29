//
//  TaskViewController.h
//  1028
//
//  Created by fg on 2017/5/26.
//  Copyright © 2017年 fg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperMainViewController.h"

@interface TaskViewController : SuperMainViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIImageView *memberImageView;
@property (strong, nonatomic) IBOutlet UILabel *memberName;
@property (strong, nonatomic) IBOutlet UILabel *memberPoint;
@property (strong, nonatomic) IBOutlet UILabel *memberLevel;
@property (strong, nonatomic) IBOutlet UITableView *taskTableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *memberLevelWidth;
@property (nonatomic, strong) NSMutableDictionary *cellHeights;
@property (strong,nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSMutableArray *activityArray;

-(void)reloadMemberPic;
-(void)setData;
-(void)refreshUserData;

@end
