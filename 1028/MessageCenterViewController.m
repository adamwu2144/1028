//
//  MessageCenterViewController.m
//  1028
//
//  Created by fg on 2017/6/7.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "MessageCenterViewController.h"
#import "ApiBuilder.h"

@interface MessageCenterViewController ()

@end

@implementation MessageCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
//    NSString *siteUrl = @"https://app.1028.tw/webview/msglist?jwt=Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOjUxLCJpc3MiOiJodHRwczpcL1wvYXBwLjEwMjgudHdcL2FwaVwvbG9naW4iLCJpYXQiOjE0OTY4ODU0ODksImV4cCI6MTQ5Njg4OTA4OSwibmJmIjoxNDk2ODg1NDg5LCJqdGkiOiJ1Z05NZUJ4eEZ5UDZLdllrIn0.m9q6hWkRmuDZUZb_riJ0v95F-7Lnngd_jSVuYA35d7Q";
//    NSCharacterSet *set = [NSCharacterSet URLFragmentAllowedCharacterSet];
//    NSString *result = [siteUrl stringByAddingPercentEncodingWithAllowedCharacters:set];
    
    [self.webView setRequestWithURL:[ApiBuilder getMsgList]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
