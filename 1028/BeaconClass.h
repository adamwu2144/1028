//
//  BeaconClass.h
//  1028
//
//  Created by fg on 2017/6/9.
//  Copyright © 2017年 fg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeaconClass : NSObject

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *type;

+ (BeaconClass *)initWithDic:(NSDictionary *)dic;

@end
