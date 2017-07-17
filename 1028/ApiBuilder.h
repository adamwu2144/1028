//
//  ApiBuilder.h
//  1028
//
//  Created by fg on 2017/5/25.
//  Copyright © 2017年 fg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApiBuilder : NSObject

// prefix
#define SECURE_HTTP @"https://"
#define INSECURE_HTTP @"http://"

#define VERSION_CODE @"api"

#define API_URL [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"URL_PATHS"] valueForKey:@"API_URL"]


+(NSString *)getLogin;
+(NSString *)getCreateNewUser;
+(NSString *)getSMSVerify;
+(NSString *)getUserData;
+(NSString *)getUpdateUserData;

+(NSString *)getGuestEventsFromTask;
+(NSString *)getEventsFromTask;

+(NSString *)getGuestEventsFromBeaconPage:(int)page;
+(NSString *)getEventsFromBeaconPage:(int)page;

+(NSString *)getGuestEventsFromQRCodePage:(int)page;
+(NSString *)getEventsFromQRCodePage:(int)page;

+(NSString *)getEventsContentFromID:(int)task_id;

+(NSString *)getEventsResultFromBeacon;

+(NSString *)getCurrentMode;

+(NSString *)getResendSMSCodeToMobile;

+(NSString *)getUpdateUserAvatar;

+(NSString *)getGiftRceiptInComingPage:(int)page;
+(NSString *)getGiftRceiptOutGoingPage:(int)page;

+(NSString *)getProductList;
+(NSString *)getProductDetail:(int)productID;
+(NSString *)getProductExchange:(int)productID;

+(NSString *)getNotificationsPage:(int)page;
+(NSString *)getNotificationByID:(int)notificationID;
+(NSString *)getUpdateNotificationByID:(int)notificationID;

+(NSString *)getOneTimeKey;

+(NSString *)getContract;
+(NSString *)getContractMember;
+(NSString *)getContractPerson;
+(NSString *)getPointsExchangeRules;
+(NSString *)getBounsExchange;
+(NSString *)getMsgList;
+(NSString *)getConnect;
+(NSString *)getGoodsList;
+(NSString *)getOfficalSite;
+(NSString *)get1028FB;
+(NSString *)get1028IG;
+(NSString *)get1028YouTube;
+(NSString *)get1028MeiPai;
+(NSString *)get1028WeiBo;
+(NSString *)get1028YouKu;

@end
