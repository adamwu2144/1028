//
//  UIDevice+NTNUExtensions.m
//  1028
//
//  Created by fg on 2017/5/24.
//  Copyright © 2017年 fg. All rights reserved.
//

#import <sys/utsname.h>
#import "UIDevice+NTNUExtensions.h"

@implementation UIDevice (NTNUExtensions)

- (NSString *)ntnu_deviceDescription
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

- (NTNUDeviceType)ntnu_deviceType
{
    NSNumber *deviceType = [[self ntnu_deviceTypeLookupTable] objectForKey:[self ntnu_deviceDescription]];
    return [deviceType unsignedIntegerValue];
}

- (NSDictionary *)ntnu_deviceTypeLookupTable
{
    return @{
             @"i386": @(DeviceAppleSimulator),
             @"x86_64": @(DeviceAppleSimulator),
             @"iPod1,1": @(DeviceAppleiPodTouch),
             @"iPod2,1": @(DeviceAppleiPodTouch2G),
             @"iPod3,1": @(DeviceAppleiPodTouch3G),
             @"iPod4,1": @(DeviceAppleiPodTouch4G),
             @"iPhone1,1": @(DeviceAppleiPhone),
             @"iPhone1,2": @(DeviceAppleiPhone3G),
             @"iPhone2,1": @(DeviceAppleiPhone3GS),
             @"iPhone3,1": @(DeviceAppleiPhone4),
             @"iPhone3,3": @(DeviceAppleiPhone4),
             @"iPhone4,1": @(DeviceAppleiPhone4S),
             @"iPhone5,1": @(DeviceAppleiPhone5),
             @"iPhone5,2": @(DeviceAppleiPhone5),
             @"iPhone5,3": @(DeviceAppleiPhone5C),
             @"iPhone5,4": @(DeviceAppleiPhone5C),
             @"iPhone6,1": @(DeviceAppleiPhone5S),
             @"iPhone6,2": @(DeviceAppleiPhone5S),
             @"iPhone7,1": @(DeviceAppleiPhone6_Plus),
             @"iPhone7,2": @(DeviceAppleiPhone6),
             @"iPhone8,1" :@(DeviceAppleiPhone6S),
             @"iPhone8,2" :@(DeviceAppleiPhone6S_Plus),
             @"iPhone8,4" :@(DeviceAppleiPhoneSE),
             @"iPhone9,1" :@(DeviceAppleiPhone7),
             @"iPhone9,3" :@(DeviceAppleiPhone7),
             @"iPhone9,2" :@(DeviceAppleiPhone7_Plus),
             @"iPhone9,4" :@(DeviceAppleiPhone7_Plus),
             @"iPad1,1": @(DeviceAppleiPad),
             @"iPad2,1": @(DeviceAppleiPad2),
             @"iPad3,1": @(DeviceAppleiPad3G),
             @"iPad3,4": @(DeviceAppleiPad4G),
             @"iPad2,5": @(DeviceAppleiPadMini),
             @"iPad4,1": @(DeviceAppleiPad5G_Air),
             @"iPad4,2": @(DeviceAppleiPad5G_Air),
             @"iPad4,4": @(DeviceAppleiPadMini2G),
             @"iPad4,5": @(DeviceAppleiPadMini2G),
             @"iPad4,7":@(DeviceAppleiPadMini),
             @"iPad6,7":@(DeviceAppleiPadPro12),
             @"iPad6,8":@(DeviceAppleiPadPro12),
             @"iPad6,3":@(DeviceAppleiPadPro9),
             @"iPad6,4":@(DeviceAppleiPadPro9)
             };
}

@end
