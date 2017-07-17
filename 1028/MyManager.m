//
//  MyManager.m
//  1028
//
//  Created by fg on 2017/5/18.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "MyManager.h"
#import "../Framework/AFNetworking/AFHTTPSessionManager.h"
#import "FGKeychain.h"
#import "MemberRegisterData.h"
#import "Reachability.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "LoginViewController.h"
#import "AttestationCheckViewController.h"

#define TIMEOUT 10

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface MyManager(){
    NSDate *AttestationTime;
}

@property (strong, nonatomic)AFHTTPSessionManager *manager;

@end

@implementation MyManager


+(id)shareManager{
    static MyManager *shareMyManager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shareMyManager = [[self alloc] init];
    });
    
    return shareMyManager;
}

-(id)init{
    
    if (self = [super init]) {
        self.manager = [AFHTTPSessionManager manager];
        
        self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [self.manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [self.manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        self.manager.responseSerializer = [AFJSONResponseSerializer  serializer];
//        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];

        [self.manager.requestSerializer setTimeoutInterval:TIMEOUT];
        self.loginStatus = NO;

    }
    return self;
}

-(void)addJWT{
    if([self loadUserInfoFromKeyChaninWithKey:@"jwt"]){
        
        NSString *JWT = [NSString stringWithFormat:@"Bearer %@",[self loadUserInfoFromKeyChaninWithKey:@"jwt"]];
        
        [self.manager.requestSerializer setValue:JWT forHTTPHeaderField:@"Authorization"];
    }
}

-(NSString *)getJWT{
    if([self loadUserInfoFromKeyChaninWithKey:@"jwt"]){
        
        NSString *JWT = [NSString stringWithFormat:@"Bearer %@",[self loadUserInfoFromKeyChaninWithKey:@"jwt"]];
            
        return JWT;
    }
    else{
        return nil;
    }
}

-(void)requestWithoutAutoRetryWithMethod:(HTTPMethod)method WithPath:(NSString *)path WithParams:(NSDictionary *)params WithSuccessBlock:(requestSuccessBlock)success WithFailurBlock:(requestFailureBlock)failure{
    NSDictionary *parameters = @{@"token":[self loadUserFBTokenFromKeyChaninWithKey]};
    
    [self.manager POST:[ApiBuilder getLogin] parameters:parameters progress:nil success:^(NSURLSessionTask *task, NSDictionary * responseObject) {
        if (responseObject) {
            [[MyManager shareManager] saveUserInfoToKeyChain:responseObject];
            [[MyManager shareManager] addJWT];
            
            [self requestWithMethod:method WithPath:path WithParams:params WithSuccessBlock:success WithFailurBlock:failure];
//            [self requestWithMethod:method WithPath:path WithParams:params WithSuccessBlock:^(NSDictionary *dic) {
//                success(dic);
//            } WithFailurBlock:^(NSError *error, int statusCode) {
//                failure(error, statusCode);
//            }];
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        //TODO: facebook token error;
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
        NSString *code = [serializedData objectForKey:@"code"];
        if ([code intValue] == 106 ||[code intValue] == 201) {
            [PublicAppDelegate.window.rootViewController presentViewController:[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil] animated:YES completion:nil];
        }
    }];
}

- (void)requestWithMethod:(HTTPMethod)method WithPath:(NSString *)path WithParams:(NSDictionary*)params WithSuccessBlock:(requestSuccessBlock)success
          WithFailurBlock:(requestFailureBlock)failure
{
    switch (method) {
        case GET:{
            [self.manager GET:path parameters:params progress:nil success:^(NSURLSessionTask *task, NSDictionary * responseObject) {
                NSLog(@"JSON: %@", responseObject);
                success(responseObject);
            } failure:^(NSURLSessionTask *operation, NSError *error) {
//                NSLog(@"Error: %@", error);
//                NSInteger statusCode = 0;
//                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)operation.response;
//                
//                if ([httpResponse isKindOfClass:[NSHTTPURLResponse class]]) {
//                    statusCode = httpResponse.statusCode;
//                }
//                failure(error, (int)statusCode);
                
                NSInteger internetStatusCode = error.code;
                
                if (internetStatusCode == -1009) {
                    [self showVaildMessageWithTitle:@"網路連線有問題" content:@"請檢察網路連線狀態"];
                }
                else{
                    NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                    if (errorData != nil) {
                        NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
                        NSString *code = [serializedData objectForKey:@"code"];
                        if ([code intValue] == 102) {
                            [self requestWithoutAutoRetryWithMethod:method WithPath:path WithParams:params WithSuccessBlock:success WithFailurBlock:failure];
//                            [self requestWithoutAutoRetryWithMethod:method WithPath:path WithParams:params WithSuccessBlock:^(NSDictionary *dic) {
//                                success(dic);
//                            } WithFailurBlock:^(NSError *error, int statusCode) {
//                                failure(error, statusCode);
//                            }];
                        }
                        else{
                            failure(error, 422);
                        }
                    }
                    else{
                        [self showVaildMessageWithTitle:@"網路連線不佳" content:@"請檢察網路狀態，再重新進入"];
                    }

                }
            }];
            break;
        }
        case POST:{
            [self.manager POST:path parameters:params progress:nil success:^(NSURLSessionTask *task, NSDictionary * responseObject) {
                NSLog(@"JSON: %@", responseObject);
                success(responseObject);
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                NSInteger internetStatusCode = error.code;
                
                if (internetStatusCode == -1009) {
                    [self showVaildMessageWithTitle:@"網路連線有問題" content:@"請檢察網路連線狀態"];
                }
                else{
                    NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                    if (errorData != nil) {
                        NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
                        NSString *code = [serializedData objectForKey:@"code"];
                        if ([code intValue] == 102) {
                            [self requestWithoutAutoRetryWithMethod:method WithPath:path WithParams:params WithSuccessBlock:success WithFailurBlock:failure];
//                            [self requestWithoutAutoRetryWithMethod:method WithPath:path WithParams:params WithSuccessBlock:^(NSDictionary *dic) {
//                                success(dic);
//                            } WithFailurBlock:^(NSError *error, int statusCode) {
//                                failure(error, statusCode);
//                            }];
                        }
                        else{
                            failure(error, 422);
                        }
                    }
                    else{
                        [self showVaildMessageWithTitle:@"網路連線不佳" content:@"請檢察網路狀態，再重新進入"];
                    }

                }
            }];
            break;
        }
        case PATCH:{
            [self.manager PATCH:path parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                success(responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSInteger internetStatusCode = error.code;
                
                if (internetStatusCode == -1009) {
                    [self showVaildMessageWithTitle:@"網路連線有問題" content:@"請檢察網路連線狀態"];
                }
                else{
                    NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                    if (errorData != nil) {
                        NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
                        NSString *code = [serializedData objectForKey:@"code"];
                        if ([code intValue] == 102) {
                            [self requestWithoutAutoRetryWithMethod:method WithPath:path WithParams:params WithSuccessBlock:success WithFailurBlock:failure];
//                            [self requestWithoutAutoRetryWithMethod:method WithPath:path WithParams:params WithSuccessBlock:^(NSDictionary *dic) {
//                                success(dic);
//                            } WithFailurBlock:^(NSError *error, int statusCode) {
//                                failure(error, statusCode);
//                            }];
                        }
                        else{
                            failure(error, 422);
                        }
                    }
                    else{
                        [self showVaildMessageWithTitle:@"網路連線不佳" content:@"請檢察網路狀態，再重新進入"];
                    }
                }

            }];
            break;
        }
        case PUT:{
            [self.manager PUT:path parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                success(responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSInteger internetStatusCode = error.code;
                
                if (internetStatusCode == -1009) {
                    [self showVaildMessageWithTitle:@"網路連線有問題" content:@"請檢察網路連線狀態"];
                }
                else{
                    NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                    if (errorData != nil) {
                        NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
                        NSString *code = [serializedData objectForKey:@"code"];
                        if ([code intValue] == 102) {
                            [self requestWithoutAutoRetryWithMethod:method WithPath:path WithParams:params WithSuccessBlock:success WithFailurBlock:failure];
//                            [self requestWithoutAutoRetryWithMethod:method WithPath:path WithParams:params WithSuccessBlock:^(NSDictionary *dic) {
//                                success(dic);
//                            } WithFailurBlock:^(NSError *error, int statusCode) {
//                                failure(error, statusCode);
//                            }];
                        }
                        else{
                            failure(error, 422);
                        }
                    }
                    else{
                        [self showVaildMessageWithTitle:@"網路連線不佳" content:@"請請檢察網路狀態，再重新進入"];
                    }
                }

            }];
        }
            break;
        default:
            [NSException raise:@"Unexpected httpType" format:@"type :%d", method];
            break;
    }
}

-(void)saveUserFBTokenToKeyChain:(NSString *)token{
//    NSMutableDictionary *userFBToken = [[NSMutableDictionary alloc] init];
//    [userFBToken setValue:token forKey:@"fbToken"];
//    
//    [FGKeychain delete:USER_FB_TOKEN];
//    
//    [FGKeychain save:USER_FB_TOKEN data:userFBToken];
    NSLog(@"======saveUserFBTokenToKeyChain======");
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:USER_FB_TOKEN];

}

-(void)delUserFBData{
//    [FGKeychain delete:USER_FB_TOKEN];
    NSLog(@"======delUserFBData======");
    NSLog(@"%@", [NSThread callStackSymbols]);
    if([[NSUserDefaults standardUserDefaults] objectForKey:USER_FB_TOKEN] != nil){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_FB_TOKEN];
    }
}

-(NSString *)loadUserFBTokenFromKeyChaninWithKey{
    NSLog(@"======loadUserFBTokenFromKeyChaninWithKey======");

    NSString *fbtoken = [[NSUserDefaults standardUserDefaults] objectForKey:USER_FB_TOKEN];
    return fbtoken;
//    return [[FGKeychain load:USER_FB_TOKEN] objectForKey:@"fbToken"];
}

-(void)saveUserInfoToKeyChain:(NSDictionary *)aData{
//    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
//    
//    [userInfo setValue:[[aData objectForKey:@"items"] objectForKey:@"jwt"] forKey:@"jwt"];
    
//    NSLog(@"key userinfo = %@", userInfo);
//    
//    //先刪除
//    [FGKeychain delete:USER_DATA];
//    //再存
//    [FGKeychain save:USER_DATA data:userInfo];
    NSLog(@"======saveUserInfoToKeyChain:aData:======");

    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    
    [userInfo setValue:[[aData objectForKey:@"items"] objectForKey:@"jwt"] forKey:@"jwt"];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:USER_DATA] != nil){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_DATA];
    };
    
    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:USER_DATA];

}

-(void)delUserData{
//    [FGKeychain delete:USER_DATA];
    NSLog(@"======delUserData======");

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_DATA];
}

-(NSString *)loadUserInfoFromKeyChaninWithKey:(NSString *)key{
    NSLog(@"======loadUserInfoFromKeyChaninWithKey:key:======");

    NSMutableDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DATA];
    NSString *jwt = [userInfo objectForKey:key];
    return jwt;
//    return [[FGKeychain load:USER_DATA] objectForKey:key];
}

-(void)getUserDataWithJWT:(NSDictionary *)jwtDic WithComplete:(complete)complete{
    
    if (jwtDic != nil) {
        [self saveUserInfoToKeyChain:jwtDic];
    }
    
    if ([self loadUserInfoFromKeyChaninWithKey:@"jwt"]) {
        [self addJWT];
    }
    
    NSDictionary *tmp = self.manager.requestSerializer.HTTPRequestHeaders;
    NSLog(@"tmp = %@",tmp);
    
    [self.manager GET:[ApiBuilder getUserData] parameters:nil progress:nil success:^(NSURLSessionTask *task, NSDictionary * responseObject) {
        if (responseObject) {
            self.memberData = [[MemberData alloc] initWithDictionary:[responseObject objectForKey:@"items"]];
            self.loginStatus = YES;
            //更新使用者資料通知所有畫面出現要更新
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserDataDidChangeNotification" object:nil];
            complete(YES, 200);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        
        NSInteger internetStatusCode = error.code;
        
        if (internetStatusCode == -1009) {
            [self showVaildMessageWithTitle:@"網路連線有問題" content:@"請檢察網路連線狀態"];
        }
        else{
            
            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            if (errorData != nil) {
                NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
                NSString *code = [serializedData objectForKey:@"code"];
                
                if ([code intValue] == 102) {
                    NSDictionary *parameters = @{@"token":[self loadUserFBTokenFromKeyChaninWithKey]};
                    [self.manager POST:[ApiBuilder getLogin] parameters:parameters progress:nil success:^(NSURLSessionTask *task, NSDictionary * responseObject) {
                        if (responseObject) {
                            [self getUserDataWithJWT:responseObject WithComplete:complete];                        }
                        else{
                            
                        }
                    } failure:^(NSURLSessionTask *operation, NSError *error) {
                        NSInteger internetStatusCode2 = error.code;
                        
                        if (internetStatusCode2 == -1009) {
                            [self showVaildMessageWithTitle:@"網路連線有問題" content:@"請檢察網路連線狀態"];
                        }
                        else{
                            //fb token login error
                            NSData *errorData2 = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                            if (errorData2 != nil) {
                                NSDictionary *serializedData2 = [NSJSONSerialization JSONObjectWithData:errorData2 options:kNilOptions error:nil];
                                NSString *code2 = [serializedData2 objectForKey:@"code"];
                                //                        complete(NO, [code2 intValue]);
                                
                                if ([code2 intValue] == 106 ||[code2 intValue] == 201) {
                                    LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
                                    UINavigationController *loginNavi = [[UINavigationController alloc] initWithRootViewController:loginViewController];
                                    [PublicAppDelegate.mainTabBarController presentViewController:loginNavi animated:YES completion:nil];
                                }
                            }
                            else{
                                [self showVaildMessageWithTitle:@"網路連線不佳" content:@"請檢察網路狀態，再重新進入"];
                            }

                        }
                    }];
                }
            }
            else{
                [self showVaildMessageWithTitle:@"網路連線不佳" content:@"請檢察網路狀態，再重新進入"];
            }
            
        }
        
        

    }];

//    [self requestWithMethod:GET WithPath:[ApiBuilder getUserData] WithParams:nil WithSuccessBlock:^(NSDictionary *dic) {
//        if (dic) {
//            self.memberData = [[MemberData alloc] initWithDictionary:[dic objectForKey:@"items"]];
//            self.loginStatus = YES;
//            complete(YES, 200);
//        }
//    } WithFailurBlock:^(NSError *error, int statusCode) {
//        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
//        NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
//        NSString *code = [serializedData objectForKey:@"code"];
//            complete(NO, [code intValue]);
//    }];
}

-(void)showVaildMessageWithTitle:(NSString *)title content:(NSString *)message{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    alertController.view.tintColor = DEFAULT_COLOR;
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    
    [alertController addAction:confirmAction];
    
    [PublicAppDelegate.mainTabBarController presentViewController:alertController animated:YES completion:nil];
}

-(void)changeMemberData:(MemberData *)data{
    self.memberData = data;
}

-(BOOL)netWork{
    
    if(([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable) || ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable)){
        return YES;
    }
    else{
        return NO;
    }
    
}

+(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

-(void)logOut{
    
    self.memberData = nil;
    [self delUserData];
    [self delUserFBData];
    self.loginStatus = NO;
    
    FBSDKLoginManager *logMeOut = [[FBSDKLoginManager alloc] init];
    [logMeOut logOut];
    
    [self refreshALLViewData];
    
    if ([PublicAppDelegate.mainTabBarController selectedIndex] == 3) {
        [PublicAppDelegate.mainTabBarController setSelectedIndex:0];
    }
    
    if ([self.myManagerDelegate respondsToSelector:@selector(clickedLogOut)]) {
        [self.myManagerDelegate clickedLogOut];
    }
    
    [PublicAppDelegate.drawer close];
    
}

-(void)refreshALLViewData{
    
    MainTabBarController *myMainTabBarController = PublicAppDelegate.mainTabBarController;
    
    BeaconViewController *beaconVC = (BeaconViewController *)[[myMainTabBarController.beaconNavi viewControllers] firstObject];
    if ([beaconVC isViewLoaded]) {
        [beaconVC refreshActivityData];
    }
    
    BarcodeViewController *barcodeVC = (BarcodeViewController *)[[myMainTabBarController.barcodeNavi viewControllers] firstObject];
    if ([barcodeVC isViewLoaded]) {
        [barcodeVC refreshActivityData];
    }
    
}


-(BOOL)getAttestationTime{
    
    NSDictionary *tmp = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ATTESTATION];
    
    NSDate *lastAttestationTime = [tmp objectForKey:USER_ATTESTATION_TIME];
    
    NSTimeInterval now = [[NSDate date] timeIntervalSinceDate:lastAttestationTime];
    
    long nowDate = (long)now;
        
    if(nowDate >= USER_ATTESTATION_TIMEOUT-1){
        return YES;
    }
    else{
        return NO;
    }
}

-(void)setAttestationTime:(NSString *)phoneNumber{
    AttestationTime = [NSDate date];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:USER_ATTESTATION] != nil){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_ATTESTATION];
    }
    
    NSDictionary *dic = @{USER_ATTESTATION_TIME:AttestationTime,USER_ATTESTATION_NUMBER:phoneNumber};
//    [[NSUserDefaults standardUserDefaults] setObject:AttestationTime forKey:USER_ATTESTATION_TIME];
//    [[NSUserDefaults standardUserDefaults] setObject:phoneNumber forKey:USER_ATTESTATION_NUMBER];
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:USER_ATTESTATION];
}

@end
