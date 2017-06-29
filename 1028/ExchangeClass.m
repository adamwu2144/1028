//
//  ExchangeClass.m
//  1028
//
//  Created by fg on 2017/6/19.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "ExchangeClass.h"

@implementation ExchangeClass

+(ExchangeClass *)initWithDictionary:(NSDictionary *)dict
{
    ExchangeClass *instance = [[ExchangeClass alloc] init];
    instance.productid = [dict objectForKey:@"id"];
    instance.brandid = [dict objectForKey:@"brand_id"];
    instance.productTitle = [dict objectForKey:@"title"];
    instance.productDescription = [dict objectForKey:@"description"];
    instance.productImage = [dict objectForKey:@"image"];
    instance.productPoints = [dict objectForKey:@"points"];
    instance.productInventory = [dict objectForKey:@"inventory"];
    instance.productStatus = [dict objectForKey:@"status"];
    
    [self validateData:instance];
    
    return instance;
}

+(NSMutableArray *)initWithArray:(NSArray *)array
{
    NSMutableArray *nsma = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < [array count]; i++) {
        NSDictionary *tmpDict = [array objectAtIndex:i];
        
        ExchangeClass *class = [ExchangeClass initWithDictionary:tmpDict];
        [nsma addObject:class];
    }
    return nsma;
}


+(void) validateData:(ExchangeClass *)instance
{
    if([instance.productid isKindOfClass:[NSNull class]]) instance.productid = @"";
    if([instance.brandid isKindOfClass:[NSNull class]]) instance.brandid = @"";
    if([instance.productTitle isKindOfClass:[NSNull class]]) instance.productTitle = @"";
    if([instance.productDescription isKindOfClass:[NSNull class]]) instance.productDescription = @"";
    if([instance.productImage isKindOfClass:[NSNull class]]) instance.productImage = @"";
    if([instance.productPoints isKindOfClass:[NSNull class]]) instance.productPoints = @0;
    if([instance.productInventory isKindOfClass:[NSNull class]]) instance.productInventory = @"";
    if([instance.productStatus isKindOfClass:[NSNull class]]) instance.productStatus = @"";
}

@end
