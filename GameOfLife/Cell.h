//
//  Cell.h
//  GameOfLife
//
//  Created by Scott Wasserman on 1/25/14.
//  Copyright (c) 2014 Artisan Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    black = 0,
    white = 1,
    red = 2,
    orange = 3,
    yellow = 4,
    green = 5,
    blue = 6,
    purple = 7
} CellColor;

@interface Cell : NSObject
{
    UIView *view;
    int age;
    int deaths;
    BOOL alive;
    CellColor initialColorOfCell;
    CellColor currentColorOfCell;
}

-(id)initWithFrame:(CGRect)frame andColor:(CellColor)cellColor;
-(CellColor)getCurrentColor;
-(CellColor)getInitialColor;
-(UIView *)getView;

-(BOOL)isAlive;
-(void)birth;
-(void)kill;
-(void)revive;
-(void)age;
-(void)destroy;
@end
