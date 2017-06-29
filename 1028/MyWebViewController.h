//
//  MyWebViewController.h
//  1028
//
//  Created by fg on 2017/6/8.
//  Copyright © 2017年 fg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyWebView.h"

@protocol MyWebViewControllerDelegate <NSObject>

-(void)doRefreshParentContent;

@end

@interface MyWebViewController : UIViewController
@property (strong, nonatomic) IBOutlet MyWebView *myWebView;
@property (nonatomic,weak) id <MyWebViewControllerDelegate> delegate;

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withURL:(NSString *)url;
-(void)setMyWebViewRequestURL:(NSString *)newURL;
@end
