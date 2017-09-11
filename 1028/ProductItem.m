//
//  ProductItem.m
//  1028
//
//  Created by fg on 2017/8/24.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "ProductItem.h"

@implementation ProductItem

+ (ProductItem *)initWithDic:(NSDictionary *)dic{
    
    ProductItem *instance = [[ProductItem alloc] init];
    instance.productID = [dic objectForKey:@"id"];
    instance.productCategoryID = [dic objectForKey:@"category_id"];
    instance.productCategory = [dic objectForKey:@"category"];
    instance.productTitle = [dic objectForKey:@"title"];
    instance.productImage = [dic objectForKey:@"image"];
    instance.productDescription = [dic objectForKey:@"description"];
    instance.productStatus = [dic objectForKey:@"status"];
    instance.productInventory = [dic objectForKey:@"inventory"];

    
    [self validateData:instance];
    
    return instance;
}

+(NSMutableArray *)initWithArray:(NSArray *)array
{
    NSMutableArray *nsma = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < [array count]; i++) {
        NSDictionary *tmpDict = [array objectAtIndex:i];
        
        ProductItem *class = [ProductItem initWithDic:tmpDict];
        [nsma addObject:class];
    }
    return nsma;
}

+(void)validateData:(ProductItem *)instance{
    
    if([instance.productID isKindOfClass:[NSNull class]]){
        instance.productID = @0;
    }
    if([instance.productCategoryID isKindOfClass:[NSNull class]]){
        instance.productCategoryID = @0;
    }
    if([instance.productCategory isKindOfClass:[NSNull class]]){
        instance.productCategory = @"";
    }
    if([instance.productTitle isKindOfClass:[NSNull class]]){
        instance.productTitle = @"";
    }
    if([instance.productImage isKindOfClass:[NSNull class]]){
        instance.productImage = @"";
    }
    if([instance.productDescription isKindOfClass:[NSNull class]]){
        instance.productDescription = @"";
    }
    if([instance.productStatus isKindOfClass:[NSNull class]]){
        instance.productStatus = @0;
    }
    if([instance.productInventory isKindOfClass:[NSNull class]]){
        instance.productInventory = @0;
    }
}

@end
