//
//  MCScannerViewController.m
//  FG
//
//  Created by fg on 2016/7/18.
//  Copyright © 2016年 FG. All rights reserved.
//

#import "MCScannerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "MBProgressHUD.h"
#import "MyWebViewController.h"

@interface MCScannerViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIWebViewDelegate,MyWebViewControllerDelegate>{
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_prevLayer;
    UIView *_highlightView;
    UILabel *_resultLabel;
}

@property (nonatomic, weak) NSTimer *timer;

@end

@implementation MCScannerViewController

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self stopReading];
    
    [_prevLayer removeFromSuperlayer];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [PublicAppDelegate.mainTabBarController.tabBar setHidden:NO];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initMyNavi];
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if(granted){
            NSLog(@"Granted access to %@", AVMediaTypeVideo);
        } else {
            NSLog(@"Not granted access to %@", AVMediaTypeVideo);
        }
    }];
    
    
    if (![self isCameraDeviceAuthorized]) {
        [self checkSetting:@"尚未相機授權" message:@"提供權限以獲得最佳服務"];
        return;
    }
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButtonItem];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText:@"行動條碼掃描器"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    self.navigationItem.titleView = titleLabel;
    
    [PublicAppDelegate.mainTabBarController.tabBar setHidden:YES];
    
    [self.webView setHidden:YES];
    
    _highlightView = [[UIView alloc] init];
    _highlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    _highlightView.layer.borderColor = [UIColor greenColor].CGColor;
    _highlightView.layer.borderWidth = 3;
    [self.view addSubview:_highlightView];
    
    _resultLabel = [[UILabel alloc] init];
    _resultLabel.frame = CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 40);
    _resultLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    _resultLabel.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.65];
    _resultLabel.textColor = [UIColor whiteColor];
    _resultLabel.textAlignment = NSTextAlignmentCenter;
    _resultLabel.text = @"";
    [self.view addSubview:_resultLabel];
    
    _session = [[AVCaptureSession alloc] init];
    _session.sessionPreset = AVCaptureSessionPresetPhoto;

    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (_input) {
        [_session addInput:_input];
    } else {
        NSLog(@"Error: %@", error);
    }
    
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_session addOutput:_output];
    
    _output.metadataObjectTypes = [_output availableMetadataObjectTypes];
    
    _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    
    CALayer *newLayer = [[CALayer alloc] init];
    newLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _prevLayer.frame = newLayer.frame;

//設定預覽畫面大小
//    UIView *preview = [[UIView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 400)];
//    CALayer *previewLayer = preview.layer;
//    _prevLayer.frame = previewLayer.frame;
    _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:_prevLayer];
    
    //scanner 框
//    UILabel *test = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
//    [test setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.5f]];
//    
//    
//    
    CGRect visibleMetadataOutputRect = [_prevLayer metadataOutputRectOfInterestForRect:CGRectMake(15, 20, SCREEN_WIDTH-30, SCREEN_WIDTH-30)];
    _output.rectOfInterest = visibleMetadataOutputRect;
    
    [_session startRunning];

    [self.view bringSubviewToFront:_highlightView];
    [self.view bringSubviewToFront:_resultLabel];
//    [self.view addSubview:test];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT) cornerRadius:0];
    
    UIBezierPath *holePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(15, 20, SCREEN_WIDTH-30, SCREEN_WIDTH-30) cornerRadius:0];
    [path appendPath:holePath];
    [path setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor blackColor].CGColor;
    fillLayer.opacity = 0.5;
    [self.view.layer addSublayer:fillLayer];
    

    
    
//    let path = UIBezierPath(rect: CGRectMake(110, 100, 150, 100))
//    let layer = CAShapeLayer()
//    layer.path = path.CGPath
//    layer.fillColor = UIColor.blackColor().CGColor
//    view.layer.addSublayer(layer)
    
    //左上
    UIBezierPath* aPath = [UIBezierPath bezierPath];
    [aPath moveToPoint:CGPointMake(15, 50)];
    [aPath addLineToPoint:CGPointMake(15, 20)];
    [aPath addLineToPoint:CGPointMake(45, 20)];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = aPath.CGPath;
    layer.lineWidth = 5.0f;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor colorWithRed:248.0/255.0 green:134.0/255.0 blue:134.0/255.0 alpha:1].CGColor;
    [self.view.layer addSublayer:layer];
    //右上
    [aPath moveToPoint:CGPointMake(15+SCREEN_WIDTH-30, 50)];
    [aPath addLineToPoint:CGPointMake(15+SCREEN_WIDTH-30, 20)];
    [aPath addLineToPoint:CGPointMake(SCREEN_WIDTH-30-15, 20)];
    layer.path = aPath.CGPath;
    [self.view.layer addSublayer:layer];
    //左下
    [aPath moveToPoint:CGPointMake(15, SCREEN_WIDTH-30+20-30)];
    [aPath addLineToPoint:CGPointMake(15, SCREEN_WIDTH-30+20)];
    [aPath addLineToPoint:CGPointMake(45, SCREEN_WIDTH-30+20)];
    layer.path = aPath.CGPath;
    [self.view.layer addSublayer:layer];
    //右下
    [aPath moveToPoint:CGPointMake(15+SCREEN_WIDTH-30-30, 20+SCREEN_WIDTH-30)];
    [aPath addLineToPoint:CGPointMake(15+SCREEN_WIDTH-30, 20+SCREEN_WIDTH-30)];
    [aPath addLineToPoint:CGPointMake(15+SCREEN_WIDTH-30, 20+SCREEN_WIDTH-30-30)];
    layer.path = aPath.CGPath;
    [self.view.layer addSublayer:layer];
    
    UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, SCREEN_WIDTH-30+20+50, SCREEN_WIDTH-30, 30)];
    [noteLabel setBackgroundColor:[UIColor clearColor]];
    [noteLabel setText:@"將行動條碼對準畫面即可讀取"];
    [noteLabel setTextAlignment:NSTextAlignmentCenter];
    [noteLabel setTextColor:[UIColor whiteColor]];
    [noteLabel setAlpha:0.5f];
    [self.view addSubview:noteLabel];
    
//    [self clickScreenTimer];
    
}

-(void)initMyNavi{
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(0, 20, 25, 25)];
    [cancelBtn addTarget:self action:@selector(cancelHandler:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"ic_arrow_white"] forState:UIControlStateNormal];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, cancelItem]];
    
    self.navigationItem.titleView.tintColor = [UIColor whiteColor];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    NSArray *barCodeTypes = @[AVMetadataObjectTypeQRCode];
    
    NSLog(@"metadataObj = %lu",(unsigned long)[metadataObjects count]);
    
    for (AVMetadataObject *metadata in metadataObjects) {
        for (NSString *type in barCodeTypes) {
            if ([metadata.type isEqualToString:type])
            {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[_prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }
        
        if (detectionString != nil)
        {
            _resultLabel.text = detectionString;
            
            if ([detectionString rangeOfString:@"http://"].location != NSNotFound ||[detectionString rangeOfString:@"https://"].location != NSNotFound) {

                [self stopReading];
//                if ([detectionString rangeOfString:@"qr.fgi.tw"].location != NSNotFound) {
//                    
//                    NSLog(@"oioioo = %@",[detectionString stringByAppendingFormat:@"&fg_memberid=%@",PublicAppDelegate.userLoginDataClass.memberID]);
//                    [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[detectionString stringByAppendingFormat:@"&fg_memberid=%@",PublicAppDelegate.userLoginDataClass.memberID]]]];
//                }
//                else{
//                MyWebViewController *myWebViewController = [[MyWebViewController alloc] initWithNibName:@"MyWebViewController" bundle:nil withURL:detectionString];
//                myWebViewController.delegate = self;
//                [self.navigationController pushViewController:myWebViewController animated:YES];
//                    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:detectionString]]];
                
                [[MyManager shareManager] requestWithMethod:GET WithPath:[ApiBuilder getOneTimeKey] WithParams:nil WithSuccessBlock:^(NSDictionary *dic) {
                    NSString *key = [[dic objectForKey:@"items"] objectForKey:@"key"];
                    NSString *urlWithKey = [NSString stringWithFormat:@"%@?key=%@",detectionString,key];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlWithKey]];

                } WithFailurBlock:^(NSError *error, int statusCode) {
                    
                }];
                
//                
//                [self.webView setRequestWithURL:detectionString];
//                self.title = @"";
////                }
//                [self.view bringSubviewToFront:self.webView];
//                [self.webView setHidden:NO];

            }
    
            break;
        }
        else
            _resultLabel.text = @"";
    }
    
    _highlightView.frame = highlightViewRect;
}

-(void)doRefreshParentContent{
    [self viewDidLoad];
}

-(void)stopReading{
    // Stop video capture and make the capture session object nil.
    [_session stopRunning];
    _session = nil;
    
    [_timer invalidate];
    // Remove the video preview layer from the viewPreview view's layer.
//    [_prevLayer removeFromSuperlayer];
}

-(void)clickScreenTimer{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                              target:self
                                            selector:@selector(timerFire:)
                                            userInfo:nil
                                             repeats:YES];
}

-(void)timerFire:(id)userinfo {
    NSLog(@"Fire");
//    [self focus:CGPointMake(15+SCREEN_WIDTH/2, 20+SCREEN_WIDTH/2)];
    NSArray *devices = [AVCaptureDevice devices];
    NSError *error;
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionBack) {
            [device lockForConfiguration:&error];
            if ([device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
                device.focusMode = AVCaptureFocusModeAutoFocus;
            }
            
            [device unlockForConfiguration];
        }
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:touch.view];
    [self focus:touchPoint];
}

- (void) focus:(CGPoint) aPoint;
{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [captureDeviceClass defaultDeviceWithMediaType:AVMediaTypeVideo];
        if([device isFocusPointOfInterestSupported] &&
           [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            double screenWidth = screenRect.size.width;
            double screenHeight = screenRect.size.height;
            double focus_x = aPoint.x/screenWidth;
            double focus_y = aPoint.y/screenHeight;
            if([device lockForConfiguration:nil]) {
                [device setFocusPointOfInterest:CGPointMake(focus_x,focus_y)];
                [device setFocusMode:AVCaptureFocusModeAutoFocus];
                if ([device isExposureModeSupported:AVCaptureExposureModeAutoExpose]){
                    [device setExposureMode:AVCaptureExposureModeAutoExpose];
                }
                [device unlockForConfiguration];
            }
        }
    }
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

#pragma mark - camera permission

- (BOOL)isCameraDeviceAuthorized
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if(status == AVAuthorizationStatusAuthorized) {
        return YES;
    }
    else if(status == AVAuthorizationStatusDenied){
        return NO;
    }
    else if(status == AVAuthorizationStatusRestricted){
        return NO;
    }
    else if(status == AVAuthorizationStatusNotDetermined){
        // not determined?!
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){
                NSLog(@"Granted access to %@", AVMediaTypeVideo);
            }
            else {
                NSLog(@"Not granted access to %@", AVMediaTypeVideo);
            }
        }];
        return YES;
    }
    else {
        return NO;
    }
}

-(void)checkSetting:(NSString *)title message:(NSString *)aMessage{
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:aMessage
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    UIAlertAction *settingAction = [UIAlertAction actionWithTitle:@"前往設定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self openSettingsScreenForApp];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:settingAction];
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}

- (void)openSettingsScreenForApp {
    NSURL *settingsURL = [[NSURL alloc] initWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:settingsURL];
}

-(void)cancelHandler:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(doRefreshContentFromQRCode)]) {
        [self.delegate doRefreshContentFromQRCode];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
