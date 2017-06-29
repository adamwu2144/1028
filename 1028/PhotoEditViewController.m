//
//  PhotoEditViewController.m
//  FG
//
//  Created by Kenny on 2015/4/28.
//  Copyright (c) 2015年 FG. All rights reserved.
//

#import "PhotoEditViewController.h"

#define MRScreenWidth      [UIScreen mainScreen].bounds.size.width
#define MRScreenHeight     [UIScreen mainScreen].bounds.size.height
@interface PhotoEditViewController ()<UIScrollViewDelegate>
{
    CGFloat scale;
    UIImageView *markView;
    CGRect latestFrame;
    CGRect oldFrame;
    CGRect largeFrame;
    UIView *cropperView;
    UIImage *originalImage;
    ChangePhotoType changePhotoType;
}
@end

@implementation PhotoEditViewController

-(instancetype)initWithImg:(UIImage *)img changType:(ChangePhotoType)changeType
{
    self = [super init];
    if(self){
        changePhotoType = changeType;
        self.view.backgroundColor = [UIColor blackColor];
        originalImage = img;
        CGSize mainViewSize = self.view.bounds.size;
        
        CGFloat imageView_X = (img.size.width > mainViewSize.width ? mainViewSize.width : img.size.width);
        CGFloat imageView_Y = (img.size.height > mainViewSize.height ? mainViewSize.height : img.size.height);
        if (img.size.width > mainViewSize.width) {
            imageView_Y = img.size.height * (mainViewSize.width / img.size.width);
        }
        if(imageView_Y < mainViewSize.width){
            imageView_X = imageView_X + (mainViewSize.width - imageView_Y);
            imageView_Y = mainViewSize.width;
        }
        if(imageView_X < mainViewSize.width){
            imageView_Y = imageView_Y + (mainViewSize.width - imageView_X);
            imageView_X = mainViewSize.width;
        }

        _editImageView = [[UIImageView alloc] initWithImage:img];
        _editImageView.alpha = 1;
        [_editImageView setFrame:CGRectMake((mainViewSize.width - imageView_X) / 2, (mainViewSize.height - imageView_Y) / 2, imageView_X, imageView_Y)];
        oldFrame = _editImageView.frame;
        latestFrame = _editImageView.frame;
        [self.view addSubview:_editImageView];
        
        markView = [[UIImageView alloc] initWithImage:[self drawImage]];
        markView.image = [self imageByDrawingCircleOnImage1:markView.image];
        [self.view addSubview:markView];
        
        largeFrame = CGRectMake(0, 0, 3 * oldFrame.size.width, 3 * oldFrame.size.height);
        [self addGestureRecognizers];
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        topView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        [self.view addSubview:topView];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 100, self.view.frame.size.width, 100)];
        bottomView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        [self.view addSubview:bottomView];
        
        UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        [okBtn setFrame:CGRectMake(bottomView.frame.size.width - 90, bottomView.frame.size.height / 2 - 20, 80, 20)];
        okBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [okBtn setTitle:@"使用照片" forState:UIControlStateNormal];
        [okBtn addTarget:self action:@selector(useImg) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:okBtn];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        [cancelBtn setFrame:CGRectMake(10, bottomView.frame.size.height / 2 - 20, 80, 20)];
        cancelBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:cancelBtn];
    }
    return self;
}

-(void)useImg
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [_photoEditDelegate completedEditImg:[self getSubImage]];
    NSLog(@"%@", NSStringFromCGSize([self getSubImage].size));
}

-(void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// register all gestures
- (void) addGestureRecognizers
{
    // add pinch gesture
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [self.view addGestureRecognizer:pinchGestureRecognizer];
    
    // add pan gesture
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
}

// pinch gesture handler
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = self.editImageView;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
    else if (pinchGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGRect newFrame = self.editImageView.frame;
        newFrame = [self handleScaleOverflow:newFrame];
        newFrame = [self handleBorderOverflow:newFrame];
        [UIView animateWithDuration:0.3 animations:^{
            self.editImageView.frame = newFrame;
            latestFrame = newFrame;
        }];
    }
}

// pan gesture handler
- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = self.editImageView;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        // calculate accelerator
        CGFloat absCenterX = markView.frame.origin.x + markView.frame.size.width / 2;
        CGFloat absCenterY = markView.frame.origin.y + markView.frame.size.height / 2;
        CGFloat scaleRatio = _editImageView.frame.size.width / markView.frame.size.width;
        CGFloat acceleratorX = 1 - ABS(absCenterX - view.center.x) / (scaleRatio * absCenterX);
        CGFloat acceleratorY = 1 - ABS(absCenterY - view.center.y) / (scaleRatio * absCenterY);
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x * acceleratorX, view.center.y + translation.y * acceleratorY}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // bounce to original frame
        CGRect newFrame = self.editImageView.frame;
        newFrame = [self handleBorderOverflow:newFrame];
        [UIView animateWithDuration:0.3 animations:^{
            self.editImageView.frame = newFrame;
            latestFrame = newFrame;
        }];
    }
}

- (CGRect)handleScaleOverflow:(CGRect)newFrame {
    // bounce to original frame
    CGPoint oriCenter = CGPointMake(newFrame.origin.x + newFrame.size.width/2, newFrame.origin.y + newFrame.size.height/2);
    if (newFrame.size.width < oldFrame.size.width) {
        newFrame = oldFrame;
    }
    if (newFrame.size.width > largeFrame.size.width) {
        newFrame = largeFrame;
    }
    newFrame.origin.x = oriCenter.x - newFrame.size.width / 2;
    newFrame.origin.y = oriCenter.y - newFrame.size.height / 2;
    return newFrame;
}

- (CGRect)handleBorderOverflow:(CGRect)newFrame {
    // horizontally
    if (newFrame.origin.x > cropperView.frame.origin.x){
        newFrame.origin.x = cropperView.frame.origin.x;
    }
    if (CGRectGetMaxX(newFrame) < cropperView.frame.size.width){
        newFrame.origin.x = cropperView.frame.size.width - newFrame.size.width;
    }
    if (newFrame.origin.x + newFrame.size.width < cropperView.frame.origin.x + cropperView.frame.size.width){
        newFrame.origin.x = cropperView.frame.origin.x + cropperView.frame.size.width - newFrame.size.width;
    }
    // vertically
    if (newFrame.origin.y > cropperView.frame.origin.y) {
        newFrame.origin.y = cropperView.frame.origin.y;
    }
    if (CGRectGetMaxY(newFrame) < cropperView.frame.origin.y + cropperView.frame.size.height) {
        newFrame.origin.y = cropperView.frame.origin.y + cropperView.frame.size.height - newFrame.size.height;
    }
    // adapt horizontally rectangle
    if (self.editImageView.frame.size.width > self.editImageView.frame.size.height && newFrame.size.height <= cropperView.frame.size.height) {
        newFrame.origin.y = cropperView.frame.origin.y + (cropperView.frame.size.height - newFrame.size.height) / 2;
    }
    return newFrame;
}



- (UIImage *)drawImage
{
    CGRect imageRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, 0.0);
    [[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.5] set];
    UIRectFill(imageRect);
    UIImage *aImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return aImage;
}


- (UIImage *)imageByDrawingCircleOnImage1:(UIImage *)image
{
    // begin a graphics context of sufficient size
    UIGraphicsBeginImageContext(image.size);
    // draw original image into the context
    [image drawAtPoint:CGPointZero];
    // get the context for CoreGraphics
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // set stroking color and draw circle
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:255 green:255 blue:255 alpha:0.0].CGColor);
    
    // make circle rect 5 px from border
    CGRect circleRect;
    if(changePhotoType == PhotoSticker){
        circleRect = markView.frame;
        CGContextAddRect(ctx, CGRectMake(self.view.center.x - self.view.frame.size.width/2, self.view.center.y - self.view.frame.size.width/2, self.view.frame.size.width, self.view.frame.size.width));
    }else{
        circleRect = CGRectMake(0, self.view.center.y - 190 / 2, self.view.frame.size.width, 190);
        CGContextAddRect(ctx, CGRectMake(0, self.view.center.y - 190 / 2, self.view.frame.size.width, 190));
    }
    CGContextClip(ctx);
    CGContextClearRect(ctx,circleRect);
    
    // make image out of bitmap context
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // free the context
    UIGraphicsEndImageContext();
    
    if(changePhotoType == PhotoSticker){
        cropperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
        cropperView.center = self.view.center;
        cropperView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:cropperView];
    }else{
        cropperView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.center.y - 95, self.view.frame.size.width, 190)];
        cropperView.center = self.view.center;
        cropperView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:cropperView];
    }
    return retImage;
}

-(UIImage *)getSubImage{
    CGRect squareFrame = cropperView.frame;
    CGFloat scaleRatioX = latestFrame.size.width / originalImage.size.width;
    CGFloat scaleRatioY = latestFrame.size.height / originalImage.size.height;
    CGFloat x = (squareFrame.origin.x - latestFrame.origin.x) / scaleRatioX;
    CGFloat y = (squareFrame.origin.y - latestFrame.origin.y) / scaleRatioY;
    CGFloat w = cropperView.frame.size.width / scaleRatioX;
    CGFloat h = cropperView.frame.size.height / scaleRatioY;
    if (latestFrame.size.width < cropperView.frame.size.width) {
        CGFloat newW = originalImage.size.width;
        CGFloat newH = newW * (cropperView.frame.size.height / cropperView.frame.size.width);
        x = 0; y = y + (h - newH) / 2;
        w = newH; h = newH;
    }
    if (latestFrame.size.height < cropperView.frame.size.height) {
        CGFloat newH = originalImage.size.height;
        CGFloat newW = newH * (cropperView.frame.size.width / cropperView.frame.size.height);
        x = x + (w - newW) / 2; y = 0;
        w = newH; h = newH;
    }
    CGRect myImageRect = CGRectMake(x, y, w, h);
    CGImageRef imageRef = originalImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    CGSize size;
    size.width = myImageRect.size.width;
    size.height = myImageRect.size.height;
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    return smallImage;
}
@end
