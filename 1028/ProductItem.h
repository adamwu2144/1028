//
//  ProductItem.h
//  1028
//
//  Created by fg on 2017/8/24.
//  Copyright © 2017年 fg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductItem : NSObject

@property (nonatomic, strong) NSNumber *productID;
@property (nonatomic, strong) NSNumber *productCategoryID;
@property (nonatomic, strong) NSString *productCategory;
@property (nonatomic, strong) NSString *productTitle;
@property (nonatomic, strong) NSString *productImage;
@property (nonatomic, strong) NSString *productDescription;
@property (nonatomic, strong) NSNumber *productStatus;
@property (nonatomic, strong) NSNumber *productInventory;

+(NSMutableArray *)initWithArray:(NSArray *)array;

@end
