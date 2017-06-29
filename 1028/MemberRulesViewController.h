//
//  MemberRulesViewController.h
//  1028
//
//  Created by fg on 2017/6/20.
//  Copyright © 2017年 fg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyWebView.h"

@interface MemberRulesViewController : UIViewController
@property (strong, nonatomic) IBOutlet MyWebView *webView;

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil fbid:(NSString *)fbid;
- (IBAction)BtnClicked:(id)sender;

@end
