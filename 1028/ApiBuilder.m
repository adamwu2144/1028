//
//  ApiBuilder.m
//  1028
//
//  Created by fg on 2017/5/25.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "ApiBuilder.h"

@implementation ApiBuilder

+ (NSString *)apiBuilder:(NSString *)domain isSecure:(Boolean)isSecure, ...NS_REQUIRES_NIL_TERMINATION
{
    if (DEBUG) {
        NSArray *syms = [NSThread  callStackSymbols];
        if ([syms count] > 1) {
            NSLog(@"<%@ %p> %@ - caller: %@ ", [self class], self, NSStringFromSelector(_cmd),[syms objectAtIndex:1]);
        } else {
            NSLog(@"<%@ %p> %@", [self class], self, NSStringFromSelector(_cmd));
        }
    }
    
    va_list args;
    va_start(args, isSecure);
    
    NSString *variables = @"";
    NSString *var;
    while ((var = va_arg(args, id))) {
        
        variables = [variables stringByAppendingString:var];
        
    }
    
    va_end(args);
    NSString *result = [NSString stringWithFormat:@"%@%@%@", isSecure ? SECURE_HTTP : INSECURE_HTTP , domain, variables];
    
    if (DEBUG) {
        NSLog(@"api builder : %@", result);
    }
    
    return result;
}

+(NSString *)getLogin{
    NSString *api = [self apiBuilder:API_URL isSecure:true  ,@"/", VERSION_CODE , @"/login",nil];
    return api;
}

+(NSString *)getCreateNewUser{
    NSString *api = [self apiBuilder:API_URL isSecure:true  ,@"/", VERSION_CODE , @"/register",nil];
    return api;
}

+(NSString *)getSMSVerify{
    NSString *api = [self apiBuilder:API_URL isSecure:true  ,@"/", VERSION_CODE , @"/sms/verify",nil];
    return api;
}

+(NSString *)getUserData{
    NSString *api = [self apiBuilder:API_URL isSecure:true  ,@"/", VERSION_CODE , @"/user",nil];
    return api;
}

+(NSString *)getUpdateUserData{
    NSString *api = [self apiBuilder:API_URL isSecure:true  ,@"/", VERSION_CODE , @"/user",nil];
    return api;
}

+(NSString *)getGuestEventsFromTask{
    NSString *api = [self apiBuilder:API_URL isSecure:true  ,@"/", VERSION_CODE , @"/guest/events/",nil];
    return api;
}

+(NSString *)getEventsFromTask{
    NSString *api = [self apiBuilder:API_URL isSecure:true  ,@"/", VERSION_CODE , @"/events/",nil];
    return api;
}

+(NSString *)getGuestEventsFromBeaconPage:(int)page{
    NSString *api = [self apiBuilder:API_URL isSecure:true  ,@"/", VERSION_CODE , @"/guest/events/beacon/",[NSString stringWithFormat:@"%d",page],nil];
    return api;
}

+(NSString *)getEventsFromBeaconPage:(int)page{
    NSString *api = [self apiBuilder:API_URL isSecure:true  ,@"/", VERSION_CODE , @"/events/beacon/",[NSString stringWithFormat:@"%d",page],nil];
    return api;
}

+(NSString *)getGuestEventsFromQRCodePage:(int)page{
    NSString *api = [self apiBuilder:API_URL isSecure:true  ,@"/", VERSION_CODE , @"/guest/events/QRCode/",[NSString stringWithFormat:@"%d",page],nil];
    return api;
}

+(NSString *)getEventsFromQRCodePage:(int)page{
    NSString *api = [self apiBuilder:API_URL isSecure:true  ,@"/", VERSION_CODE , @"/events/QRCode/",[NSString stringWithFormat:@"%d",page],nil];
    return api;
}

+(NSString *)getEventsContentFromID:(int)task_id{
    NSString *api = [self apiBuilder:API_URL isSecure:true  ,@"/", VERSION_CODE , @"/events/",[NSString stringWithFormat:@"%d",task_id],nil];
    return api;
}

+(NSString *)getEventsResultFromBeacon{
    NSString *api = [self apiBuilder:API_URL isSecure:true  ,@"/", VERSION_CODE , @"/events/beacon",nil];
    return api;
}

+(NSString *)getCurrentMode{
    NSString *api = [self apiBuilder:API_URL isSecure:true  ,@"/", VERSION_CODE , @"/currentMode",nil];
    return api;
}

+(NSString *)getResendSMSCodeToMobile{
    NSString *api = [self apiBuilder:API_URL isSecure:true  ,@"/", VERSION_CODE , @"/sms/send",nil];
    return api;
}

+(NSString *)getUpdateUserAvatar{
    NSString *api = [self apiBuilder:API_URL isSecure:true  ,@"/", VERSION_CODE , @"/user/avatar",nil];
    return api;
}

+(NSString *)getGiftRceiptInComingPage:(int)page{
    NSString *api = [self apiBuilder:API_URL isSecure:true  ,@"/", VERSION_CODE , @"/pointHistories/incoming/",[NSString stringWithFormat:@"%d",page],nil];
    return api;
}

+(NSString *)getGiftRceiptOutGoingPage:(int)page{
    NSString *api = [self apiBuilder:API_URL isSecure:true  ,@"/", VERSION_CODE , @"/pointHistories/outgoing/",[NSString stringWithFormat:@"%d",page],nil];
    return api;
}

+(NSString *)getProductList{
    NSString *api = [self apiBuilder:API_URL isSecure:true  ,@"/", VERSION_CODE , @"/rewards/",nil];
    return api;
}

+(NSString *)getProductDetail:(int)productID{
    NSString *api = [self apiBuilder:API_URL isSecure:true  ,@"/", VERSION_CODE , @"/rewards/",[NSString stringWithFormat:@"%d",productID],nil];
    return api;
}

+(NSString *)getProductExchange:(int)productID{
    NSString *api = [self apiBuilder:API_URL isSecure:true  ,@"/", VERSION_CODE , @"/rewards/",[NSString stringWithFormat:@"%d",productID],nil];
    return api;
}

+(NSString *)getNotificationsPage:(int)page{
    NSString *api = [self apiBuilder:API_URL isSecure:true  ,@"/", VERSION_CODE , @"/notifications/page/",[NSString stringWithFormat:@"%d",page],nil];
    return api;
}
+(NSString *)getNotificationByID:(int)notificationID{
    NSString *api = [self apiBuilder:API_URL isSecure:true  ,@"/", VERSION_CODE , @"/notifications/",[NSString stringWithFormat:@"%d",notificationID],nil];
    return api;
}

+(NSString *)getUpdateNotificationByID:(int)notificationID{
    NSString *api = [self apiBuilder:API_URL isSecure:true  ,@"/", VERSION_CODE , @"/notifications/",[NSString stringWithFormat:@"%d",notificationID],nil];
    return api;
}

+(NSString *)getContract{
    NSString *api = @"https://app.1028.tw/webview/contract";
    return api;
}

+(NSString *)getContractMember{
    NSString *api = @"https://app.1028.tw/webview/contractmember";
    return api;
}

+(NSString *)getContractPerson{
    NSString *api = @"https://app.1028.tw/webview/contractperson";
    return api;
}

+(NSString *)getPointsExchangeRules{
    NSString *api = @"https://app.1028.tw/webview/bonusrule";
    return api;
}

+(NSString *)getBounsExchange{
    NSString *api = @"https://app.1028.tw/webview/bonusexchange";
    return api;
}

+(NSString *)getMsgList{
    NSString *api = @"https://app.1028.tw/webview/msglist";
    return api;
}

+(NSString *)getConnect{
    NSString *api = @"https://app.1028.tw/webview/connect";
    return api;
}

+(NSString *)getGoodsList{
    NSString *api = @"https://app.1028.tw/webview/goodslist";
    return api;
}

+(NSString *)getOfficalSite{
    NSString *api = @"http://www.1028loveu.com.tw/v2/official";
    return api;
}

+(NSString *)get1028FB{
    NSString *api = @"https://www.facebook.com/1028LoveU";
    return api;
}

+(NSString *)get1028IG{
    NSString *api = @"https://www.instagram.com/1028_taiwan/";
    return api;
}

+(NSString *)get1028YouTube{
    NSString *api = @"https://www.youtube.com/user/1028VisualTherapy";
    return api;
}

+(NSString *)get1028MeiPai{
    NSString *api = @"http://www.meipai.com/user/1030735691";
    return api;
}

+(NSString *)get1028WeiBo{
    NSString *api = @"http://www.weibo.com/p/1006065074388648/home";
    return api;
}

+(NSString *)get1028YouKu{
    NSString *api = @"http://i.youku.com/u/UMTQ4Njk0NzY4MA";
    return api;
}


@end
