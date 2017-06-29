//
//  MyWebView.m
//  1028
//
//  Created by fg on 2017/6/7.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "MyWebView.h"
#import "MyManager.h"
#import "MBProgressHUD.h"

@implementation MyWebView{
    NSString *jsCallBack;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.delegate = self;

}

-(void)setRequestWithURL:(NSString *)url{
    
    NSString *jwtStr = [[MyManager shareManager] getJWT];
    NSString *addJWTString = [NSString stringWithFormat:@"%@?jwt=%@",url,jwtStr];
    
    NSCharacterSet *set = [NSCharacterSet URLFragmentAllowedCharacterSet];
    NSString *result = [addJWTString stringByAddingPercentEncodingWithAllowedCharacters:set];
    NSURL *urlLink = [NSURL URLWithString:result];
    [self loadRequest:[NSURLRequest requestWithURL:urlLink]];
}

-(void)resendRequestWithURL:(NSURL *)url{
    [self loadRequest:[NSURLRequest requestWithURL:url]];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [MBProgressHUD showHUDAddedTo:self.superview animated:YES];
    NSLog(@"webViewDidStartLoad");
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"webViewDidFinishLoad");
//    self.scalesPageToFit = YES;
//    self.contentMode = UIViewContentModeScaleAspectFit;

    [MBProgressHUD hideAllHUDsForView:self.superview animated:YES];
//    float zoom = self.bounds.size.width / self.scrollView.contentSize.width;
//    self.scrollView.minimumZoomScale = zoom;
//    [self.scrollView setZoomScale:zoom animated:YES];

}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"error = %@",error.userInfo);
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"requestLink = %@", [request.URL absoluteString]);
    NSString *requestUrl = [request.URL absoluteString];
    
    if([requestUrl rangeOfString:@"iOSexpired=iOSexpired"].location != NSNotFound){
        NSString *processUrl = [requestUrl stringByReplacingOccurrencesOfString:@"&iOSexpired=iOSexpired" withString:@""];
        NSArray *filterExpiredArray = [processUrl componentsSeparatedByString:@"expiredpage?"];
        NSArray *filterAndArray = nil;
        for (int x = 0 ; x < [filterExpiredArray count]; x++) {
            NSString *tmp = [filterExpiredArray objectAtIndex:x];
            if ([tmp rangeOfString:@"jwt"].location != NSNotFound) {
                filterAndArray = [tmp componentsSeparatedByString:@"&"];
            }
        }
        [[MyManager shareManager] getUserDataWithJWT:nil WithComplete:^(BOOL status, int statusCode) {
            if (status) {
                NSString *newRequestUrl = [NSString stringWithFormat:@"%@redirect?jwt=%@&%@",[filterExpiredArray objectAtIndex:0],[[MyManager shareManager] getJWT],[filterAndArray objectAtIndex:1]];
                NSCharacterSet *set = [NSCharacterSet URLFragmentAllowedCharacterSet];
                NSString *result = [newRequestUrl stringByAddingPercentEncodingWithAllowedCharacters:set];
                NSURL *urlLink = [NSURL URLWithString:result];

                [self resendRequestWithURL:urlLink];
            }
        }];
    }
        
    return YES;
}
@end
