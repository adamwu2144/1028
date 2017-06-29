//
//  FitImageView.m
//  FG
//
//  Created by Kenny on 2015/5/26.
//  Copyright (c) 2015年 FG. All rights reserved.
//

#import "FitImageView.h"
@implementation FitImageView

-(CGSize)intrinsicContentSize
{
    CGSize s =[super intrinsicContentSize];
    
    s.height = self.frame.size.width / self.image.size.width  * self.image.size.height;
    
    UIImage *img = self.image;
    float h = img.size.height;
    float w = img.size.width;
    if((h <= SCREEN_WIDTH - 20 && w <= SCREEN_HEIGHT - 64) && (h <= SCREEN_HEIGHT -64 && w <= SCREEN_WIDTH - 20))
    {
        return img.size;
    }
    else
    {
        double imgWidth = SCREEN_WIDTH - 20;
        double b = imgWidth / w;
        CGSize itemSize = CGSizeMake(b*w, b*h);
        UIGraphicsBeginImageContext(itemSize);
        CGRect imageRect = CGRectMake(0, 0, b*w, b*h);
        [img drawInRect:imageRect];
//        self.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return imageRect.size;
    }
}

-(CGSize)intrinsicContentPostSize
{
    CGSize s =[super intrinsicContentSize];
    
    s.height = self.frame.size.width / self.image.size.width  * self.image.size.height;
    double postImgWidth = SCREEN_WIDTH - 30;
    UIImage *img = self.image;
    float h = img.size.height;
    float w = img.size.width;
    if((h <= postImgWidth && w <= postImgWidth) && (h <= postImgWidth && w <= postImgWidth))
    {
        return img.size;
    }
    else
    {
        double imgWidth = postImgWidth;
        double b = imgWidth / w;
        CGSize itemSize = CGSizeMake(b*w, b*w);
        UIGraphicsBeginImageContext(itemSize);
        CGRect imageRect = CGRectMake(0, 0, b*w, b*w);
        return imageRect.size;
    }
}

@end
