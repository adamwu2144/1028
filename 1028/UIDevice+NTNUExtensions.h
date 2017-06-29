//
//  UIDevice+NTNUExtensions.h
//  1028
//
//  Created by fg on 2017/5/24.
//  Copyright © 2017年 fg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, NTNUDeviceType) {
    DeviceAppleUnknown,
    DeviceAppleSimulator,
    DeviceAppleiPhone,
    DeviceAppleiPhone3G,
    DeviceAppleiPhone3GS,
    DeviceAppleiPhone4,
    DeviceAppleiPhone4S,
    DeviceAppleiPhone5,
    DeviceAppleiPhone5C,
    DeviceAppleiPhone5S,
    DeviceAppleiPhone6,
    DeviceAppleiPhone6_Plus,
    DeviceAppleiPhone6S,
    DeviceAppleiPhone6S_Plus,
    DeviceAppleiPhoneSE,
    DeviceAppleiPhone7,
    DeviceAppleiPhone7_Plus,
    DeviceAppleiPodTouch,
    DeviceAppleiPodTouch2G,
    DeviceAppleiPodTouch3G,
    DeviceAppleiPodTouch4G,
    DeviceAppleiPad,
    DeviceAppleiPad2,
    DeviceAppleiPad3G,
    DeviceAppleiPad4G,
    DeviceAppleiPad5G_Air,
    DeviceAppleiPadMini,
    DeviceAppleiPadMini2G,
    DeviceAppleiPadPro12,
    DeviceAppleiPadPro9
};



@interface UIDevice (NTNUExtensions)

- (NSString *)ntnu_deviceDescription;
- (NTNUDeviceType)ntnu_deviceType;

@end
