//
//  ExchangeClass.h
//  1028
//
//  Created by fg on 2017/6/19.
//  Copyright © 2017年 fg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExchangeClass : NSObject

@property (nonatomic, strong) NSString *productid;
@property (nonatomic, strong) NSString *brandid;
@property (nonatomic, strong) NSString *productTitle;
@property (nonatomic, strong) NSString *productDescription;
@property (nonatomic, strong) NSString *productImage;
@property (nonatomic, strong) NSNumber *productPoints;
@property (nonatomic, strong) NSString *productInventory;
@property (nonatomic, strong) NSString *productStatus;

+(NSMutableArray *)initWithArray:(NSArray *)array;

@end
