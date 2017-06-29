//
//  MenuViewController.h
//  1028
//
//  Created by fg on 2017/5/25.
//  Copyright © 2017年 fg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Framework/ICSDrawerController/ICSDrawerController.h"

@interface MenuViewController : UIViewController<ICSDrawerControllerChild, ICSDrawerControllerPresenting>


@property (strong, nonatomic) IBOutlet UITableView *menuTableView;
@property(nonatomic, weak) ICSDrawerController *drawer;
@property(nonatomic, assign) NSInteger previousRow;

@end
