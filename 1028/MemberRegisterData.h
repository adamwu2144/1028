//
//  MemberRegisterData.h
//  1028
//
//  Created by fg on 2017/5/22.
//  Copyright © 2017年 fg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberRegisterData : NSObject

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *mobilephone;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *sex;


+(MemberRegisterData *)initWithDictionary:(NSDictionary *)dict;
-(NSMutableDictionary *)generateDataArray;

@end

@interface MemberData : NSObject

@property (nonatomic, strong)NSString *first_name;
@property (nonatomic, strong)NSString *last_name;
@property (nonatomic, strong)NSString *user_name;
@property (nonatomic, strong)NSString *email;
@property (nonatomic, strong)NSString *facebook_id;
@property (nonatomic, strong)NSString *birthday;
@property (nonatomic, strong)NSNumber *gender;
@property (nonatomic, strong)NSString *mobile;
@property (nonatomic, strong)NSNumber *city_id;
@property (nonatomic, strong)NSNumber *district_id;
@property (nonatomic, strong)NSString *address;
@property (nonatomic, strong)NSNumber *level_points;
@property (nonatomic, strong)NSNumber *points;
@property (nonatomic, strong)NSString *avatar;
@property (nonatomic, strong)NSNumber *notification;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSNumber *titleKey;

-(MemberData *)initWithDictionary:(NSDictionary *)dict;

@end
