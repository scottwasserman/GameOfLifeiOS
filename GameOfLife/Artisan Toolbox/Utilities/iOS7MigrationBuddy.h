/*  
 *	iOS7MigrationBuddy.h
 *  ArtisanDemo
 *
 *  Created by Scott Wasserman on 9/17/13.
 *  Copyright (c) 2013 Artisan Mobile, Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>

/*
 *  Helper interface used to check the OS version of the current
 *  device and adjust the screen layout accordingly
 */

@interface iOS7MigrationBuddy : NSObject

/*  
 *	Checks device/simulator to see which OS, 6.1 and below or
 *  7.0 and above, is running
 */

+ (BOOL)osIs61rLess;
+ (BOOL)osIs7OrGreater;

/*
 *  Transition from iOS6 and iOS7 requires an offset of 20 units
 *  at the top of the screen
 */

+ (CGFloat)topOfScreenOffet;

@end
