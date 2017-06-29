//
//  ExchangeViewController.h
//  1028
//
//  Created by fg on 2017/6/19.
//  Copyright © 2017年 fg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExchangeViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *cellHeights;

@end
