//
//  MCBeaconViewController.h
//  FG
//
//  Created by fg on 2016/7/18.
//  Copyright © 2016年 FG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MCTaskClass;

@interface MCBeaconViewController : UIViewController

-(id)initWithActivityTask:(MCTaskClass *)task;
-(void)checkLocationPremission;
-(void)checkBlueToothPowerState;
@end
