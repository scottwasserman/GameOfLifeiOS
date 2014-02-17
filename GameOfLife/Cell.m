//
//  Cell.m
//  GameOfLife
//
//  Created by Scott Wasserman on 1/25/14.
//  Copyright (c) 2014 Artisan Mobile. All rights reserved.
//

#import "Cell.h"

@implementation Cell

-(id)initWithFrame:(CGRect)frame andColor:(CellColor)cellColor
{
    self = [super init];
    if (self)
    {
        view = [[UIView alloc] initWithFrame:frame];
        initialColorOfCell = cellColor;
        currentColorOfCell = cellColor;
        alive = NO;
        view.backgroundColor = [self translateColorToUIColor:initialColorOfCell];
        view.hidden = YES;
    }
    return self;
}

#pragma mark -
#pragma mark Questions about cell

-(BOOL)isAlive
{
    return alive;
}

#pragma mark -
#pragma mark Cell lifecycle methods

-(void)kill
{
    view.hidden = YES;
    deaths++;
    alive = NO;
}

-(void)revive
{
    age = 0;
    view.hidden = NO;
    [self setColor:initialColorOfCell];
    [self resetAlpha];
    alive = YES;
}

-(void)age
{
    age++;
    if (view.alpha < 1)
    {
        view.alpha = view.alpha + 0.05;
    }
    
    /*
    if (age > 10)
    {
        view.alpha = 1;
        [self setColor:red];
    }
    
    if (age > 15)
    {
        view.alpha = 1;
        [self setColor:blue];
    }
    
    if (age > 20)
    {
        view.alpha = 1;
        [self setColor:green];
    }
     */
}

-(void)birth
{
    view.hidden = NO;
    [self resetAlpha];
    age = 0;
    deaths = 0;
    alive = YES;
}

-(void)destroy
{
    view.hidden = YES;
    [self resetAlpha];
    age = 0;
    deaths = 0;
    alive = NO;
    [self setColor:initialColorOfCell];
}

#pragma mark -
#pragma mark Color-related methods
-(void)setColor:(CellColor)color
{
    currentColorOfCell = color;
    view.backgroundColor = [self translateColorToUIColor:currentColorOfCell];
}

-(CellColor)getCurrentColor
{
    return currentColorOfCell;
}

-(CellColor)getInitialColor
{
    return initialColorOfCell;
}

-(UIColor*)translateColorToUIColor:(CellColor)color
{
    UIColor *translatedColor;
    
    switch (color) {
        case black:
            translatedColor = [UIColor blackColor];
            break;
        case white:
            translatedColor = [UIColor whiteColor];
            break;
        case red:
            translatedColor = [UIColor redColor];
            break;
        case orange:
            translatedColor = [UIColor orangeColor];
            break;
        case yellow:
            translatedColor = [UIColor yellowColor];
            break;
        case green:
            translatedColor = [UIColor greenColor];
            break;
        case blue:
            translatedColor = [UIColor blueColor];
            break;
        case purple:
            translatedColor = [UIColor purpleColor];
            break;
            
        default:
            translatedColor = [UIColor blackColor];
            break;
    }
    
    return translatedColor;
}

#pragma mark -
#pragma mark View methods

-(UIView *)getView
{
    return view;
}

-(void)resetAlpha
{
    view.alpha = 0.1;
}

@end
