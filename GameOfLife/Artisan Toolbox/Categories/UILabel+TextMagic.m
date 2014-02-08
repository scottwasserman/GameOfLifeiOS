/*
 *  UILabel+TextMagic.m
 *  
 *
 *  Created by Scott Wasserman on 8/28/13.
 *  Copyright (c) 2013 Scott Wasserman All rights reserved.
 */

#import "UILabel+TextMagic.h"

@implementation UILabel (TextMagic)

- (CGFloat)actualTextWidth
{
    return [self actualTextSize].width;
}

- (CGFloat)actualTextHeight
{
    return [self actualTextSize].height;
}

- (CGSize)actualTextSize
{
    return [self actualTextSizeConstrainedByWidth:self.frame.size.width
                                        andHeight:self.frame.size.height];
}

- (CGSize)actualTextSizeConstrainedByWidth:(CGFloat)width andHeight:(CGFloat)height
{
    return [self.text sizeWithFont:self.font
                 constrainedToSize:CGSizeMake(width,height)
                     lineBreakMode:self.lineBreakMode];
}

- (CGSize)actualTextSizeWithString:(NSString *)stringToSize
{
    return [stringToSize sizeWithFont:self.font
                    constrainedToSize:CGSizeMake(self.frame.size.width,self.frame.size.height)
                        lineBreakMode:self.lineBreakMode];
}

- (void)setTextAndResizeFrame:(NSString *)text
{
    self.text = text;
    [self adjustFrameToTextWidthAndHeight];
}

// This is the same thing as SizeToFit
- (void)adjustFrameHeightToTextHeight
{
    CGSize labelActualTextSize = [self actualTextSize];
    self.frame = CGRectMake(self.frame.origin.x,self.frame.origin.y,self.frame.size.width,labelActualTextSize.height);
}

- (void)adjustFrameWidthToTextWidth
{
    CGSize labelActualTextSize = [self actualTextSize];
    self.frame = CGRectMake(self.frame.origin.x,self.frame.origin.y,labelActualTextSize.width,self.frame.size.height);
}

- (void)adjustFrameToTextWidthAndHeight
{
    CGSize labelActualTextSize = [self actualTextSize];
    self.frame = CGRectMake(self.frame.origin.x,self.frame.origin.y,labelActualTextSize.width,labelActualTextSize.height);
}

- (CGFloat)bottomYCoordinate
{
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)rightXCoordinate
{
    return self.frame.origin.x + self.frame.size.width;
}

- (int)numberOfLinesToPad
{
    CGSize fontSize = [self.text sizeWithFont:self.font];
    CGSize actualSize = [self actualTextSize];
    return (self.frame.size.height - actualSize.height) / fontSize.height;
}

- (void)alignTop
{
    for(int i = 0; i < [self numberOfLinesToPad]; i++)
    {
        self.text = [self.text stringByAppendingString:@"\n "];
    }
}

- (void)alignBottom
{
    for(int i = 0; i < [self numberOfLinesToPad]; i++)
    {
        self.text = [NSString stringWithFormat:@" \n%@",self.text];
    }
}

- (CGRect)buildStrikethroughFrameWithHeight:(int)strikethroughHeight
{
    CGFloat strikethroughY = self.frame.origin.y + (self.frame.size.height/2) - (strikethroughHeight/2);
    
    CGFloat strikethroughX = self.frame.origin.x;
    
    if (self.textAlignment == NSTextAlignmentCenter)
    {
        strikethroughX = self.frame.origin.x + ((self.frame.size.width - [self actualTextWidth])/2);
    }
    else if (self.textAlignment == NSTextAlignmentRight)
    {
        strikethroughX = self.frame.origin.x + (self.frame.size.width) - ((self.frame.size.width - [self actualTextWidth])/2);
    }
    
    return CGRectMake(strikethroughX,strikethroughY,[self actualTextWidth],strikethroughHeight);
}

@end
