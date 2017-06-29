//
//  BeaconClass.m
//  1028
//
//  Created by fg on 2017/6/9.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "BeaconClass.h"

@implementation BeaconClass

+ (BeaconClass *)initWithDic:(NSDictionary *)dic{
    
    BeaconClass *instance = [[BeaconClass alloc] init];
    instance.url = [dic objectForKey:@"result_url"];
    instance.type = [dic objectForKey:@"result_type"];
    
    [self validateData:instance];
    
    return instance;
}

+(void)validateData:(BeaconClass *)instance{

    if([instance.url isKindOfClass:[NSNull class]]){
        instance.url = @"";
    }
    if([instance.type isKindOfClass:[NSNull class]]){
        instance.type = @"";
    }
}





@end
