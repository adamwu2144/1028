//
//  MemberRegisterData.m
//  1028
//
//  Created by fg on 2017/5/22.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "MemberRegisterData.h"

@implementation MemberRegisterData

+(MemberRegisterData *)initWithDictionary:(NSDictionary *)dict
{
    MemberRegisterData *instance = [[MemberRegisterData alloc] init];
    instance.address = [dict objectForKey:@"address"];
    instance.birthday = [dict objectForKey:@"birthday"];
    instance.city = [dict objectForKey:@"city"];
    instance.code = [dict objectForKey:@"code"];
    instance.mobilephone = [dict objectForKey:@"mobilephone"] ;
    instance.firstName = [dict objectForKey:@"firstName"] ;
    instance.lastName = [dict objectForKey:@"lastName"] ;
    instance.sex = [dict objectForKey:@"sex"];
    
    [self validateData:instance];
    
    return instance;
}

+(void) validateData:(MemberRegisterData *)instance
{
    if([instance.address isKindOfClass:[NSNull class]]) instance.address = @"";
    if([instance.birthday isKindOfClass:[NSNull class]]) instance.birthday = @"";
    if([instance.city isKindOfClass:[NSNull class]]) instance.city = @"";
    if([instance.code isKindOfClass:[NSNull class]]) instance.code = @"";
    if([instance.mobilephone isKindOfClass:[NSNull class]]) instance.mobilephone = @"";
    if([instance.firstName isKindOfClass:[NSNull class]]) instance.firstName = @"";
    if([instance.lastName isKindOfClass:[NSNull class]]) instance.lastName = @"";
    if([instance.sex isKindOfClass:[NSNull class]]) instance.sex = @"";

}

-(NSMutableDictionary *)generateDataArray
{
    NSMutableDictionary *nsmd = [[NSMutableDictionary alloc] init];
    [nsmd setValue:self.address forKey:@"address"];
    [nsmd setValue:self.birthday forKey:@"birthday"];
    [nsmd setValue:self.city forKey:@"city"];
    [nsmd setValue:self.code forKey:@"code"];
    [nsmd setValue:self.mobilephone forKey:@"mobilephone"];
    [nsmd setValue:self.firstName forKey:@"firstName"];
    [nsmd setValue:self.lastName forKey:@"lastName"];
    if([self.sex isEqualToString:@"男"]) {
        [nsmd setValue:@"m" forKey:@"sex"];
    } else {
        [nsmd setValue:@"f" forKey:@"sex"];
    }
    return nsmd;
}

@end

@implementation MemberData

-(MemberData *)initWithDictionary:(NSDictionary *)dict
{
    MemberData *instance = [[MemberData alloc] init];
    instance.first_name = [dict objectForKey:@"first_name"];
    instance.last_name = [dict objectForKey:@"last_name"];
    instance.user_name = [dict objectForKey:@"user_name"];
    instance.email = [dict objectForKey:@"email"];
    instance.facebook_id = [dict objectForKey:@"facebook_id"];
    instance.birthday = [dict objectForKey:@"birthday"];
    instance.gender = [dict objectForKey:@"gender"];
    instance.mobile = [dict objectForKey:@"mobile"];
    instance.city_id = [dict objectForKey:@"city_id"];
    instance.district_id = [dict objectForKey:@"district_id"];
    instance.address = [dict objectForKey:@"address"];
    instance.level_points = [dict objectForKey:@"level_points"];
    instance.points = [dict objectForKey:@"points"];
    instance.avatar = [dict objectForKey:@"avatar"];
    instance.notification = [dict objectForKey:@"notification"];
    instance.title = [dict objectForKey:@"title"];
    instance.titleKey = [dict objectForKey:@"title_key"];
    
    [self validateData:instance];
    
    return instance;
}

-(void) validateData:(MemberData *)instance
{
    if([instance.first_name isKindOfClass:[NSNull class]]) instance.first_name = @"";
    if([instance.last_name isKindOfClass:[NSNull class]]) instance.last_name = @"";
    if([instance.user_name isKindOfClass:[NSNull class]]) instance.user_name = @"";
    if([instance.email isKindOfClass:[NSNull class]]) instance.email = @"";
    if([instance.facebook_id isKindOfClass:[NSNull class]]) instance.facebook_id = @"";
    if([instance.birthday isKindOfClass:[NSNull class]]) instance.birthday = @"";
    if([instance.gender isKindOfClass:[NSNull class]]) instance.gender = @-1;
    if([instance.mobile isKindOfClass:[NSNull class]]) instance.mobile = @"";
    if([instance.city_id isKindOfClass:[NSNull class]]) instance.city_id = @-1;
    if([instance.district_id isKindOfClass:[NSNull class]]) instance.district_id = @-1;
    if([instance.address isKindOfClass:[NSNull class]]) instance.address = @"";
    if([instance.level_points isKindOfClass:[NSNull class]]) instance.level_points = @-1;
    if([instance.points isKindOfClass:[NSNull class]]) instance.points = @-1;
    if([instance.avatar isKindOfClass:[NSNull class]]) instance.avatar = @"";
    if([instance.notification isKindOfClass:[NSNull class]]) instance.notification = @-1;
    if([instance.title isKindOfClass:[NSNull class]]) instance.title = @"";
    if([instance.titleKey isKindOfClass:[NSNull class]]) instance.titleKey = @0;

}

@end
