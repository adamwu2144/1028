//
//  GiftRceiptClass.h
//  1028
//
//  Created by fg on 2017/6/16.
//  Copyright © 2017年 fg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GiftRceiptClass : NSObject

@property (nonatomic, strong) NSNumber *rceipt_point;
@property (nonatomic, strong) NSString *rceiptDescription;
@property (nonatomic, strong) NSString *created_at;

+(NSMutableArray *)initWithArray:(NSArray *)array;

@end
