//
//  GradientView.m
//  1028
//
//  Created by fg on 2017/6/1.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "GradientView.h"

@implementation GradientView{
    CAGradientLayer *gradient;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect {
//    // 建立要繪製圖片的座標
//    CGRect frame = rect;
//    // 將座標中的尺寸取出以便之後使用
//    CGSize imageSize = frame.size;
//
//    // 建立一個畫布，大小為剛剛取出的尺寸
//    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
//    
//    // 建立一個 RGB 的顏色空間
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    // 建立繪製圖片用的 context
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    // 建立漸層用的顏色，這邊只用兩個顏色，要更多顏色可以自行加入
//    UIColor *beginColor = [UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:204.0f/255.0f alpha:1];
//    UIColor *endColor = [UIColor colorWithRed:0 green:0 blue:102.0f/255.0f alpha:1];
//    
//    // 將顏色加入陣列中
//    NSArray *gradientColors = [NSArray arrayWithObjects:(id)beginColor.CGColor, (id)endColor.CGColor, nil];
//    
//    // 建立漸層顏色的啟始點，因為有兩個顏色，所以有兩個數值，如果有多個顏色就需要多個數值
//    // 數值的範圍為 0~1。
//    CGFloat gradientLocation[] = {0, 1};
//    
//    // 建立繪製漸層的基本資訊
//    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)gradientColors, gradientLocation);
//    
//    // 繪製一個矩型路徑，讓漸層的顏色能畫上去
//    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
//    CGContextSaveGState(context);
//    [bezierPath addClip];
//    
//    // 建立繪製漸層的起點
//    CGPoint beginPoint = CGPointMake(imageSize.width / 2, 0);
//    // 建立繪製漸層的終點
//    CGPoint endPoint = CGPointMake(imageSize.width / 2, imageSize.height);
//    
//    // 將繪製的座標加入要繪製的漸層中
//    CGContextDrawLinearGradient(context, gradient, beginPoint, endPoint, 0);
//    // 建立圖片邊線的資訊
//    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
//    
//    // 將邊線繪製到路徑中
////    [bezierPath setLineWidth:linWidth];
//    // 將漸層色填滿路徑
//    [bezierPath stroke];
//    
//    CGContextRestoreGState(context);
//    
//    // 將繪製完成的 context 輸出成 UIImage 格式
//    UIImage *drawnImage = UIGraphicsGetImageFromCurrentImageContext();
//    // 結束 context，並且釋放記憶體
//    UIGraphicsEndImageContext();
//    CGColorSpaceRelease(colorSpace);
//    CGGradientRelease(gradient);
//    
//    // 將繪製完成的圖片加到 UIImageView 讓它顯示
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:drawnImage];
//    [imageView setFrame:frame];
////
//    [self addSubview:imageView];

}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSLog(@"1");
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    NSLog(@"awakeFromNib");
    

    NSLog(@"2");
}

-(void)layoutSubviews{
    
    NSLog(@"layoutSubviews_view");
    [super layoutSubviews];
    gradient.frame = self.frame;
    NSLog(@"3");
}

-(void)setViewFirstColor:(UIColor *)firstColor secondColor:(UIColor *)aSecondColor{
    
    gradient = [CAGradientLayer layer];
    gradient.colors = [NSArray arrayWithObjects:(id)firstColor.CGColor, (id)aSecondColor.CGColor, nil]; // 由上到下的漸層顏色
    gradient.startPoint = CGPointMake(1.0, 0.0);
    gradient.endPoint = CGPointMake(0.0, 0.0);
    [self.layer insertSublayer:gradient atIndex:0];
    NSLog(@"setViewColor");
}
@end
