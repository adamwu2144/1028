//
//  TaskClass.m
//  1028
//
//  Created by fg on 2017/6/7.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "TaskClass.h"

@implementation TaskClass

+(TaskClass *)initWithDictionary:(NSDictionary *)dict
{
    TaskClass *instance = [[TaskClass alloc] init];
    instance.taskid = [dict objectForKey:@"id"];
    instance.title = [dict objectForKey:@"title"];
    instance.image = [dict objectForKey:@"image"];
    instance.taskCompleted = [dict objectForKey:@"completed"];
    instance.taskType = [dict objectForKey:@"type"];
    instance.backgroundColor = [[dict objectForKey:@"background_color"] stringByReplacingOccurrencesOfString:@"#" withString:@""];
    instance.content = [dict objectForKey:@"content"];

    [self validateData:instance];
    
    return instance;
}

+(NSMutableArray *)initWithArray:(NSArray *)array
{
    NSMutableArray *nsma = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < [array count]; i++) {
        NSDictionary *tmpDict = [array objectAtIndex:i];
        
        TaskClass *class = [TaskClass initWithDictionary:tmpDict];
//        class.image = @"https://upload.wikimedia.org/wikipedia/commons/thumb/e/e5/View_from_Hotel_Ohla%2C_Barcelona%2C_Spain_%2831183960414%29.jpg/320px-View_from_Hotel_Ohla%2C_Barcelona%2C_Spain_%2831183960414%29.jpg";
        [nsma addObject:class];
    }
    return nsma;
}


+(void) validateData:(TaskClass *)instance
{
    if([instance.taskid isKindOfClass:[NSNull class]]) instance.taskid = @"";
    if([instance.title isKindOfClass:[NSNull class]]) instance.title = @"";
    if([instance.image isKindOfClass:[NSNull class]]) instance.image = @"";
    if([instance.taskCompleted isKindOfClass:[NSNull class]]) instance.taskCompleted = @0;
    if([instance.taskType isKindOfClass:[NSNull class]]) instance.taskType = @0;
    if([instance.backgroundColor isKindOfClass:[NSNull class]]) instance.backgroundColor = @"";
    if([instance.content isKindOfClass:[NSNull class]]) instance.content = @"";


}

@end
