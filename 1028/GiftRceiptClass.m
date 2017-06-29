//
//  GiftRceiptClass.m
//  1028
//
//  Created by fg on 2017/6/16.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "GiftRceiptClass.h"

@implementation GiftRceiptClass

+(GiftRceiptClass *)initWithDictionary:(NSDictionary *)dict
{
    GiftRceiptClass *instance = [[GiftRceiptClass alloc] init];
    instance.rceiptID = [dict objectForKey:@"id"];
    instance.rceiptDescription = [dict objectForKey:@"description"];
    instance.created_at = [dict objectForKey:@"created_at"];
    
    [self validateData:instance];
    
    return instance;
}

+(NSMutableArray *)initWithArray:(NSArray *)array
{
    NSMutableArray *nsma = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < [array count]; i++) {
        NSDictionary *tmpDict = [array objectAtIndex:i];
        
        GiftRceiptClass *class = [GiftRceiptClass initWithDictionary:tmpDict];
        [nsma addObject:class];
    }
    return nsma;
}


+(void) validateData:(GiftRceiptClass *)instance
{
    if([instance.rceiptID isKindOfClass:[NSNull class]]) instance.rceiptID = @"";
    if([instance.rceiptDescription isKindOfClass:[NSNull class]]) instance.rceiptDescription = @"";
    if([instance.created_at isKindOfClass:[NSNull class]]) instance.created_at = @"";
}

@end
