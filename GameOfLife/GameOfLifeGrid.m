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
        randomFactor = 10;
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
            square.backgroundColor = [UIColor grayColor];
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
                [self birthCellAtRow:x column:y];
            }
            else
            {
                [self killCellAtRow:x column:y];
            }
        }
    }
}


- (void)nextGeneration
{
    for (int y=0;y < columns-2;y++)
    {
        for (int x=0;x < rows-2;x++)
        {
            [self nextGenerationForGridAtRow:x column:y];
        }
    }

}

- (void)nextGenerationForGridAtRow:(int)row column:(int)column
{
    int numberOfLiveNeighbors = 0;
    
    // TODO: Deal with the last grids somehow
    
    if ((row + 2 <= rows) && (column + 2 <= columns))
    {
        // Row 1
        if ([self cellIsAliveAtRow:row column:column])
        {
            numberOfLiveNeighbors++;
        }
        if ([self cellIsAliveAtRow:row+1 column:column])
        {
            numberOfLiveNeighbors++;
        }
        if ([self cellIsAliveAtRow:row+2 column:column])
        {
            numberOfLiveNeighbors++;
        }
        // Row 2
        if ([self cellIsAliveAtRow:row column:column+1])
        {
            numberOfLiveNeighbors++;
        }
        if ([self cellIsAliveAtRow:row+2 column:column+1])
        {
            numberOfLiveNeighbors++;
        }
        // Row 3
        if ([self cellIsAliveAtRow:row column:column+2])
        {
            numberOfLiveNeighbors++;
        }
        if ([self cellIsAliveAtRow:row+1 column:column+2])
        {
            numberOfLiveNeighbors++;
        }
        if ([self cellIsAliveAtRow:row+2 column:column+2])
        {
            numberOfLiveNeighbors++;
        }
        
        BOOL currentCellIsAlive = [self cellIsAliveAtRow:row+1 column:column+1];
        
        if (currentCellIsAlive)
        {
            // Less than 2 or great than 3 live neighbors kills it
            if ((numberOfLiveNeighbors < 2) || (numberOfLiveNeighbors > 3))
            {
                [self killCellAtRow:row+1 column:column+1];
            }
        }
        else
        {
            if (numberOfLiveNeighbors == 3)
            {
                [self reviveCellAtRow:row+1 column:column+1];
            }
        }
    }
}

-(void)birthCellAtRow:(int)row column:(int)column
{
    ((UIView*)[gridArray objectAtIndex:row + (column * rows)]).hidden = NO;
}

-(void)reviveCellAtRow:(int)row column:(int)column
{
    ((UIView*)[gridArray objectAtIndex:row + (column * rows)]).hidden = NO;
}

-(void)killCellAtRow:(int)row column:(int)column
{
    ((UIView*)[gridArray objectAtIndex:row + (column * rows)]).hidden = YES;
}

-(BOOL)cellIsAliveAtRow:(int)row column:(int)column
{
    return !((UIView*)[gridArray objectAtIndex:row + (column * rows)]).hidden;
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
