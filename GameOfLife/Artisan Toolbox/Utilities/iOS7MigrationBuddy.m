/*  
 *	iOS7MigrationBuddy.m
 *  ArtisanDemo
 *
 *  Created by Scott Wasserman on 9/17/13.
 *  Copyright (c) 2013 Artisan Mobile, Inc. All rights reserved.
 */

#import "iOS7MigrationBuddy.h"

@implementation iOS7MigrationBuddy

+ (BOOL)osIs61rLess
{
    return ([[UIDevice currentDevice].systemVersion floatValue] < 7.0);
}

+ (BOOL)osIs7OrGreater
{
    return ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0);
}

+ (CGFloat)topOfScreenOffet
{
    if ([iOS7MigrationBuddy osIs7OrGreater])
    {
        return 64;
    }
    else
    {
        return 44;
    }
}

@end
