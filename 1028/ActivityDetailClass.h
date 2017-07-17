//
//  ActivityDetailClass.h
//  FG
//
//  Created by fg on 2016/3/2.
//  Copyright © 2016年 FG. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum ActivityType {
    ActivityTypeForBeacon = 1,
    ActivityTypeForQRCode = 2,
    ActivityTypeForUnBeacon = 3,
    ActivityTypeForOpenURL = 4
}ActivityType;


@interface ActivityDetailClass : NSObject

@property(nonatomic, strong)NSNumber *task_id;
@property(nonatomic, strong)NSString *task_title;
@property(nonatomic, strong)NSString *task_description;
@property(nonatomic, strong)NSString *task_image;
@property(nonatomic, strong)NSNumber *task_type;
@property(nonatomic, strong)NSString *task_started;
@property(nonatomic, strong)NSString *task_ended;
@property(nonatomic, strong)NSNumber *task_status;
@property(nonatomic, strong)NSString *task_status_text;
@property(nonatomic, strong)NSString *result_url;


+(ActivityDetailClass *)initWithDictionary:(NSDictionary *)dict;

@end
