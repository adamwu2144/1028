//
//  MyManager.h
//  1028
//
//  Created by fg on 2017/5/18.
//  Copyright © 2017年 fg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MemberData;

//请求成功回调block
typedef void (^requestSuccessBlock)(NSDictionary *dic);

//请求失败回调block
typedef void (^requestFailureBlock)(NSError *error, int statusCode);

//请求方法define
typedef enum {
    GET,
    POST,
    PUT,
    DELETE,
    HEAD,
    PATCH
} HTTPMethod;

typedef void (^complete)(BOOL status, int statusCode);

@protocol MyManagerDelegate <NSObject>

@optional

-(void)clickedLogOut;

@end

@interface MyManager : NSObject{

}

@property(nonatomic, strong)MemberData *memberData;
@property(nonatomic, assign)BOOL loginStatus;
@property(nonatomic, weak) id <MyManagerDelegate> myManagerDelegate;

+ (id)shareManager;
- (void)addJWT;
-(NSString *)getJWT;
- (void)requestWithoutAutoRetryWithMethod:(HTTPMethod)method WithPath:(NSString *)path WithParams:(NSDictionary*)params WithSuccessBlock:(requestSuccessBlock)success
                          WithFailurBlock:(requestFailureBlock)failure;
- (void)requestWithMethod:(HTTPMethod)method WithPath:(NSString *)path WithParams:(NSDictionary*)params WithSuccessBlock:(requestSuccessBlock)success
WithFailurBlock:(requestFailureBlock)failure;

-(void)saveUserFBTokenToKeyChain:(NSString *)token;
-(void)delUserFBData;
-(NSString *)loadUserFBTokenFromKeyChaninWithKey;

-(void)saveUserInfoToKeyChain:(NSDictionary *)aData;
-(NSString *)loadUserInfoFromKeyChaninWithKey:(NSString *)key;

-(void)getUserDataWithJWT:(NSDictionary *)jwtDic WithComplete:(complete)complete;
-(void)getUserDataWithComplete:(complete)complete;
-(void)changeMemberData:(MemberData *)data;
-(BOOL)netWork;
+(UIColor*)colorWithHexString:(NSString*)hex;
-(void)logOut;
-(void)refreshALLViewData;
-(BOOL)getAttestationTime;
-(void)setAttestationTime:(NSString *)phoneNumber;

@end
