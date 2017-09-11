//
//  ResendRequestClass.h
//  1028
//
//  Created by fg on 2017/8/8.
//  Copyright © 2017年 fg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResendRequestClass : NSObject

@property(nonatomic,assign)HTTPMethod method;
@property(nonatomic,strong)NSString *path;
@property(nonatomic,strong)NSDictionary *param;

@end
