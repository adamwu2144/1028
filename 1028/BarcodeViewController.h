//
//  BarcodeViewController.h
//  1028
//
//  Created by fg on 2017/4/17.
//  Copyright © 2017年 fg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarcodeViewController : SuperMainViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *cellHeights;
@property (nonatomic, strong) NSMutableArray *activityArray;
@property (strong,nonatomic) UIRefreshControl *refreshControl;

-(void)refreshActivityData;
-(void)getQRActivity;

@end
