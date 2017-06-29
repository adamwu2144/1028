//
//  FGKeychain.h
//  FG
//
//  Created by fg on 2015/7/29.
//  Copyright (c) 2015年 FG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FGKeychain : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;

@end
