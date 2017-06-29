//
//  MyWebView.h
//  1028
//
//  Created by fg on 2017/6/7.
//  Copyright © 2017年 fg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWebView : UIWebView<UIWebViewDelegate>
-(void)setRequestWithURL:(NSString *)url;
@end
