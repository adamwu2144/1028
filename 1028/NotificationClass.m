//
//  NotificationClass.m
//  1028
//
//  Created by fg on 2017/6/26.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "NotificationClass.h"

@implementation NotificationClass

+(NotificationClass *)initWithDictionary:(NSDictionary *)dict
{
    NotificationClass *instance = [[NotificationClass alloc] init];
    instance.notificationID = [dict objectForKey:@"id"];
    instance.title = [dict objectForKey:@"title"];
    instance.content = [dict objectForKey:@"content"];
    instance.type = [dict objectForKey:@"type"];
    instance.backgroundColor = [dict objectForKey:@"background_color"];
    instance.isRead = [dict objectForKey:@"is_read"];
    instance.status = NO;
    [self validateData:instance];
    
    return instance;
}

+(NSMutableArray *)initWithArray:(NSArray *)array
{
    NSMutableArray *nsma = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < [array count]; i++) {
        NSDictionary *tmpDict = [array objectAtIndex:i];
        
        NotificationClass *class = [NotificationClass initWithDictionary:tmpDict];
        [nsma addObject:class];
    }
    return nsma;
}


+(void) validateData:(NotificationClass *)instance
{
    if([instance.notificationID isKindOfClass:[NSNull class]]) instance.notificationID = @0;
    if([instance.title isKindOfClass:[NSNull class]]) instance.title = @"";
    if([instance.content isKindOfClass:[NSNull class]]) instance.content = @"";
    if([instance.type isKindOfClass:[NSNull class]]) instance.type = @0;
    if([instance.backgroundColor isKindOfClass:[NSNull class]]) instance.backgroundColor = @"";
    if([instance.isRead isKindOfClass:[NSNull class]]) instance.isRead = @0;

}

@end
