//
//  ActivityDetailClass.m
//  FG
//
//  Created by fg on 2016/3/2.
//  Copyright © 2016年 FG. All rights reserved.
//

#import "ActivityDetailClass.h"

@implementation ActivityDetailClass

+(ActivityDetailClass *)initWithDictionary:(NSDictionary *)dict{
    
    ActivityDetailClass *activityDetailClass = [[ActivityDetailClass alloc] init];
    
    activityDetailClass.task_id = [dict objectForKey:@"id"];
    activityDetailClass.task_title = [dict objectForKey:@"title"];
    activityDetailClass.task_description = [dict objectForKey:@"description"];
    activityDetailClass.task_image = [dict objectForKey:@"image"];
    activityDetailClass.task_type = [dict objectForKey:@"type"];
    activityDetailClass.task_started = [dict objectForKey:@"started_at"];
    activityDetailClass.task_ended = [dict objectForKey:@"ended_at"];
    activityDetailClass.task_completed = [dict objectForKey:@"completed"];
    activityDetailClass.task_status = [dict objectForKey:@"status"]; //1:活動中; 2:活動關閉; 3:活動尚未開始
    activityDetailClass.task_status_text = [dict objectForKey:@"status_text"];

    
    return activityDetailClass;
}

@end
