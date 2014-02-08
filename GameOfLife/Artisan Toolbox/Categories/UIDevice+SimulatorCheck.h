/*
 *  UIDevice+SimulatorCheck.h
 *  ArtisanDemo
 *
 *  Created by Scott Wasserman on 10/7/13.
 *  Copyright (c) 2013 Artisan Mobile, Inc. All rights reserved.
 */

@interface UIDevice (SimulatorCheck)

/*
 *  Checks to see if the current device is a iPhone simulator
 */
+ (BOOL)currentDeviceIsIpadSimulator;
/*
 *  Checks to see if the current device is a iPad simulator
 */
+ (BOOL)currentDeviceIsIphoneSimulator;

/*
 *  Used to check if the current device being used is
 *  a simulator, using the previous two methods.
 */
+ (BOOL)currentDeviceIsSimulator;
@end
