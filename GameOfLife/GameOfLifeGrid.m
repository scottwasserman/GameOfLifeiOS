//
//  GameOfLifeGrid.m
//  GameOfLife
//
//  Created by Scott Wasserman on 1/23/14.
//  Copyright (c) 2014 Artisan Mobile. All rights reserved.
//

#import "GameOfLifeGrid.h"
#include <stdlib.h>

@implementation GameOfLifeGrid

-(id)initWithRows:(int)numberOfRows columns:(int)numberOfColumns squareSize:(int)squareSize andFrame:(CGRect)frame
{
    self = [super init];
    if (self)
    {
        rows = numberOfRows;
        columns = numberOfColumns;
        sizeOfSquare = squareSize;
        gridArray = [[NSMutableArray alloc] initWithCapacity:(rows*columns)];
        gridView = [[UIView alloc] initWithFrame:frame];
        randomFactor = 4;
        [self initArray];
    }
    return self;
}

-(void)initArray
{
    for (int y=0;y < columns;y++)
    {
        for (int x=0;x < rows;x++)
        {
            UIView *square = [[UIView alloc] initWithFrame:CGRectMake(x * sizeOfSquare, y * sizeOfSquare, sizeOfSquare, sizeOfSquare)];
            square.backgroundColor = [UIColor blackColor];
            square.hidden = YES;

            [gridView addSubview:square];
            [gridArray addObject:square];
        }
    }
}

-(void)randomize
{
    for (int y=0;y < columns;y++)
    {
        for (int x=0;x < rows;x++)
        {
            int on = arc4random() % randomFactor;
            
            if (on == 0)
            {
                [self turnOnCellAtRow:x column:y];
            }
            else
            {
                [self turnOffCellAtRow:x column:y];
            }
        }
    }
}

-(void)turnOnCellAtRow:(int)row column:(int)column
{
    ((UIView*)[gridArray objectAtIndex:(row * column)]).hidden = NO;
}

-(void)turnOffCellAtRow:(int)row column:(int)column
{
    ((UIView*)[gridArray objectAtIndex:(row * column)]).hidden = YES;
}

-(UIView *)getGridView
{
    return gridView;
}

-(void)setObject:(id)currObject inRow:(int)currRow andColumn:(int)currColumn
{
    [gridArray replaceObjectAtIndex:(currRow * currColumn) withObject:currObject];
}

-(id)getObjectInRow:(int)currRow andColumn:(int)currColumn
{
    return [gridArray objectAtIndex:(currRow * currColumn)];
}


@end
