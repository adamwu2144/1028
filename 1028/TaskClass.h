//
//  TaskClass.h
//  1028
//
//  Created by fg on 2017/6/7.
//  Copyright © 2017年 fg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskClass : NSObject

@property (nonatomic, strong) NSString *taskid;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSNumber *taskCompleted;
@property (nonatomic, strong) NSNumber *taskType;
@property (nonatomic, strong) NSString *backgroundColor;
@property (nonatomic, strong) NSString *content;


+(NSMutableArray *)initWithArray:(NSArray *)array;

@end
