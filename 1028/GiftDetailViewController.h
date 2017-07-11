//
//  GiftDetailViewController.h
//  1028
//
//  Created by fg on 2017/6/2.
//  Copyright © 2017年 fg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyWebView.h"

@interface GiftDetailViewController : UIViewController<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *memberImageView;
@property (strong, nonatomic) IBOutlet UILabel *memberLevel;
@property (strong, nonatomic) IBOutlet UILabel *memberPoint;
@property (strong, nonatomic) IBOutlet UILabel *memberTotalScroe;
@property (strong, nonatomic) IBOutlet UIButton *memberUsePointBtn;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *cellHeights;
@property (strong, nonatomic) IBOutlet UIButton *pointsDetail;
@property (strong, nonatomic) IBOutlet UIButton *pointsExchange;
@property (strong, nonatomic) IBOutlet UIButton *pointsRules;
@property (strong, nonatomic) IBOutlet MyWebView *webView;
- (IBAction)btnClicked:(id)sender;

- (IBAction)membeUsePointBtnClicked:(id)sender;
@end
