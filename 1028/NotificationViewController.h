//
//  NotificationViewController.h
//  1028
//
//  Created by fg on 2017/6/26.
//  Copyright © 2017年 fg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NotificationViewControllerDelegate <NSObject>

@optional

-(void)refreshUserData;

@end

@interface NotificationViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *cellHeights;

@property (nonatomic,weak) id <NotificationViewControllerDelegate> delegate;
@end
