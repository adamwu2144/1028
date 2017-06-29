//
//  RtlsEngine.h
//  RtlsEngine
//
//  Created by LeeDa on 2015/3/5.
//  Copyright (c) 2015年 DoubleService.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RtlsEngine : NSObject 
/**
 * @brief This a full version of comment description.
 *
 * @param serverURL A serverURL of the RTLS ststem (ex: @" http://192.168.20.9/api/").
 * @param device A unique deviceID of this iOS device.
 *
 * @return Return a RtlsEngine Object.
 *
 * @warning ServerURL and Device can not be empty; A useful RTLS must be initialized via this method.
 *
 */
-(id) initRtlsEngineWithServerURL:(NSString*)serverURL;

-(void) initLBS;
/**
 * @brief To start the RTLS engine for scaning beacon signals; after the engine initialized.
 */

-(void) startScan;

/**
 * @brief To pause the RTLS engine.
 */
-(void) pauseScan;
/**
 * @brief To set a nickname of this device; it is not a unnecessary varible.
 */
-(void) setNickName:(NSString*)reciveNickName;
/**
 * @brief To set an unique deviceID which can ifenify this device for RTLS system.
 */
-(void) setDeviceID:(NSString*)reciveID;
/**
 * @brief To set how many scan times per locating; default value: 5.
 */

-(void) setScanTimesPerLocatePosition:(int)reciveTimes;
/**
 * @brief To set a RTLS server url.
 */

-(void) setServerUrl:(NSString*)reciveUrl;
/**
 * @brief To set a UUID value for beacon scanning; default value: E2C56DB5-DFFB-48D2-B060-D0F5A71096E0
 */
-(void) setBeaconUUID:(NSString*)reciveBeaconUUID;

/**
 * @brief To check device has connected a WiFi or not
 * @return Return y/n.
 */
-(BOOL) isWifiConnected;
//--JPMS API-------
-(void) jpmsEngine_apiPOST_checkStartPmsNumByNum:(NSString*)startNo;
-(void) jpmsEngine_apiPOST_checkStartPmsNumByIPMAC;
//Aruba for connect with Aruba AP
-(void)jpmsEngine_apiPOST_checkStartPmsNumByIPMACWithAPBrand:(NSString*)APBrand;
-(void)jpmsEngine_apiPOST_userConnectWithEmail:(NSString*)email WithSex: (NSString*)sex Withbday:(NSString*)bday Withtel:(NSString*)tel;
-(NSString *) jpmsEngine_getMACaddress;
-(NSString *) jpmsEngine_getUserID;
-(NSString *) jpmsEngine_getAction;
-(NSString *) getConnSSID;
-(void)getPushMessage;//WiFi pushmessage

@end
