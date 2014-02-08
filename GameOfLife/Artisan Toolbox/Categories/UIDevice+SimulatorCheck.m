/*
 *  UIDevice+SimulatorCheck.m
 *  ArtisanDemo
 *
 *  Created by Scott Wasserman on 10/7/13.
 *  Copyright (c) 2013 Artisan Mobile, Inc. All rights reserved.
 */

#import "UIDevice+SimulatorCheck.h"

@implementation UIDevice (SimulatorCheck)

+ (BOOL)currentDeviceIsIpadSimulator
{
    return [[[UIDevice currentDevice] model] isEqualToString:@"iPad Simulator"];
}

+ (BOOL)currentDeviceIsIphoneSimulator
{
    return [[[UIDevice currentDevice] model] isEqualToString:@"iPhone Simulator"];
}

+ (BOOL)currentDeviceIsSimulator
{
    return ([self currentDeviceIsIphoneSimulator] || [self currentDeviceIsIpadSimulator]);
}

@end
