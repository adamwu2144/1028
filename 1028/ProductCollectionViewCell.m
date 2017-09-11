//
//  ProductCollectionViewCell.m
//  1028
//
//  Created by fg on 2017/5/3.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "ProductCollectionViewCell.h"

@implementation ProductCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

-(void)prepareForReuse{
    [super prepareForReuse];
    NSLog(@"reuse");
}

-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
}

@end
