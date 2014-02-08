/*
 *  NSString+NiftyAdditions.m
 *  
 *
 *  Created by Scott Wasserman on 9/15/13.
 *  Copyright (c) 2013 Artisan Mobile, Inc. All rights reserved.
 */

#import "NSString+NiftyAdditions.h"

@implementation NSString (NiftyAdditions)

// HTML-related stuff
- (NSString *)escapeHTML
{
    /* Could definitely put a little more work into this one */
    NSString *escaped = [self stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    escaped = [escaped stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    return escaped;
}
- (NSString *)URLEncode
{
    CFStringRef encoded = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                  (__bridge CFStringRef)self,
                                                                  NULL,
                                                                  CFSTR(":/?#[]@!$&'()*+,;="),
                                                                  kCFStringEncodingUTF8);
    return [NSString stringWithString:(__bridge_transfer NSString *)encoded];
}

- (NSString *)URLDecode
{
    CFStringRef decoded = CFURLCreateStringByReplacingPercentEscapes( kCFAllocatorDefault,
                                                                     (__bridge CFStringRef)self,
                                                                     CFSTR(":/?#[]@!$&'()*+,;=") );
    return [NSString stringWithString:(__bridge_transfer NSString *)decoded];
}

+ (NSString *)queryStringWithBase:(NSString *)base parameters:(NSDictionary *)params prefixed:(BOOL)prefixed
{
    /* Append base if specified. */
    NSMutableString *str = [NSMutableString stringWithCapacity:0];
    if(base)
    {
        [str appendString:base];
    }
    
    /* Append each name-value pair. */
    if(params)
    {
        int i;
        NSArray *names = [params allKeys];
        for(i = 0; i < [names count]; i++)
        {
            if(i == 0 && prefixed)
            {
                [str appendString:@"?"];
            }
            else if(i > 0)
            {
                [str appendString:@"&"];
            }
            NSString *name = [names objectAtIndex:i];
            if([[params objectForKey:name] isKindOfClass:[NSArray class]])
            {
                NSArray *array = [params objectForKey:name];
                [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
                 {
                     NSString *value = (NSString *)obj;
                     NSString *pair = [NSString stringWithFormat:@"%@[]=%@", name, value ];
                     [str appendString:pair];
                     if(obj != [array lastObject])
                     {
                         [str appendString:@"&"];
                     }
                 }];
            }
            else
            {
                NSString *value = [[params objectForKey:name] URLEncode];
                NSString *pair = [NSString stringWithFormat:@"%@=%@", name, value ];
                [str appendString:pair];
            }
        }
    }
    return [NSString stringWithString:str];
}

// Nifty String stuff
- (NSString *)stringByTrimmingWhitspace
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)isBlank
{
    NSString *trimmed = [self stringByTrimmingWhitspace];
    return ([trimmed length] == 0);
}

- (BOOL)substringExists:(NSString *)checkSubstring
{
    return [NSString substringExists:checkSubstring inString:self];
}

+ (BOOL)substringExists:(NSString *)checkSubstring inString:(NSString *)checkString
{
    if ( ([checkSubstring length] == 0) || ([checkString length] == 0) )
    {
        return NO;
    }
    
    NSRange rangeOfSubstring = [checkString rangeOfString:checkSubstring];
    return ( (!(rangeOfSubstring.location == NSNotFound)) && (rangeOfSubstring.length > 0) );
}


+ (NSString*)stringBetweenString:(NSString*)startString andString:(NSString *)endString withstring:(NSString*)string
{
    NSScanner* scanner = [NSScanner scannerWithString:string];
    [scanner setCharactersToBeSkipped:nil];
    [scanner scanUpToString:startString intoString:NULL];
    if ([scanner scanString:startString intoString:NULL])
    {
        NSString* result = nil;
        if ([scanner scanUpToString:endString intoString:&result])
        {
            return result;
        }
    }
    return nil;
}


- (NSString*)stringBetweenString:(NSString*)startString andString:(NSString *)endString
{
    return [NSString stringBetweenString:startString andString:endString withstring:self];
}


@end
