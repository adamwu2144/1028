//
//  NotificationClass.h
//  1028
//
//  Created by fg on 2017/6/26.
//  Copyright © 2017年 fg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationClass : NSObject


@property (nonatomic, strong) NSNumber *notificationID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, strong) NSString *backgroundColor;
@property (nonatomic, strong) NSNumber *isRead;
@property (nonatomic, assign) BOOL status;

+(NSMutableArray *)initWithArray:(NSArray *)array;


@end
