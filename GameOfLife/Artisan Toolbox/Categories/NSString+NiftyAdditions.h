/*
 *  NSString+NiftyAdditions.h
 *
 *  Created by Scott Wasserman on 9/15/13.
 *  Copyright (c) 2013 Artisan Mobile, Inc. All rights reserved.
 */

@interface NSString (NiftyAdditions)

// HTML-related stuff

/*
 *  Replaces the instances of < and > with their char equivalents &gt; and &lt;
 *  used to type < and > without them definining an HTML tag
 */
- (NSString *)escapeHTML;
/*
 *  Encodes a string, preserving its URL format. Specifically, searches the 
 *  string for any instances of the characters :/?#[]@!$&'()*+,;=  and replaces
 *  them with their UTF8 equivalent
 */
- (NSString *)URLEncode;
/*
 *  Decodes a string in URL format, Specifically, it will remove all instances of
 *  the characters :/?#[]@!$&'()*+,;= and replace them with their character
 *  equivalent
 */
- (NSString *)URLDecode;

+ (NSString *)queryStringWithBase:(NSString *)base parameters:(NSDictionary *)params prefixed:(BOOL)prefixed;

// Nifty String stuff

//  Trims the white space out of a string
- (NSString *)stringByTrimmingWhitspace;

//  Tests to see if the string is empty/blank
- (BOOL)isBlank;


// Checks the existence of a given substring checkSubstring in the string 
- (BOOL)substringExists:(NSString *)checkSubstring;
+ (BOOL)substringExists:(NSString *)checkSubstring inString:(NSString *)checkString;


// Returns the string between startString and endString
- (NSString*)stringBetweenString:(NSString*)startString andString:(NSString *)endString;
+ (NSString*)stringBetweenString:(NSString*)startString andString:(NSString *)endString withstring:(NSString*)string;

@end
