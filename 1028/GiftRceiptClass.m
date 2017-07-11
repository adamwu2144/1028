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
    instance.rceipt_point = [dict objectForKey:@"transaction_point"];
    instance.rceiptDescription = [dict objectForKey:@"description"];
    
    NSArray *filterDashArray = [[dict objectForKey:@"created_at"] componentsSeparatedByString:@"-"];
    NSArray *filterSpaceArray = [[filterDashArray objectAtIndex:2] componentsSeparatedByString:@" "];

    NSString *date = [NSString stringWithFormat:@"%@/%@",[filterDashArray objectAtIndex:1],[filterSpaceArray objectAtIndex:0]];
    instance.created_at = date;
    
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
    if([instance.rceipt_point isKindOfClass:[NSNull class]]) instance.rceipt_point = @0;
    if([instance.rceiptDescription isKindOfClass:[NSNull class]]) instance.rceiptDescription = @"";
    if([instance.created_at isKindOfClass:[NSNull class]]) instance.created_at = @"";
}

@end
