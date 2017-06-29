//
//  MCScannerViewController.h
//  FG
//
//  Created by fg on 2016/7/18.
//  Copyright © 2016年 FG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyWebView.h"

@protocol MCScannerViewControllerDelegate <NSObject>

-(void)doRefreshContentFromQRCode;

@end
@interface MCScannerViewController : UIViewController
@property (strong, nonatomic) IBOutlet MyWebView *webView;

@property (nonatomic,weak) id <MCScannerViewControllerDelegate> delegate;


@end
