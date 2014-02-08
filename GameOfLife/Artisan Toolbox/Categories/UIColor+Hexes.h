/*
 *  UIColor+Hexes.h
 * 
 *  Contains properties of UIColor, such as raw hex value,
 *  or string representation of hex value.
 *
 *  Created by Scott Wasserman on 9/5/13.
 *  Copyright (c) 2013 Artisan Mobile, Inc. All rights reserved.
 */

@interface UIColor (Hexes)

/*
 *  Takes hex string of the form @"#123456" and returns
 *  the corresponding UIColor.
 */
+ (UIColor *)colorWithHexString:(NSString *)str;

/*
 *  Takes hex value (raw) of the form 0x123456 and returns
 *  the corresponding UIColor.
 */
+ (UIColor *)colorWithHex:(UInt32)col;

@end
