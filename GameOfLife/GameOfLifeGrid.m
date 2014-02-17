//
//  GameOfLifeGrid.m
//  GameOfLife
//
//  Created by Scott Wasserman on 1/23/14.
//  Copyright (c) 2014 Artisan Mobile. All rights reserved.
//

#import "GameOfLifeGrid.h"
#include <stdlib.h>
#import "Cell.h"

@implementation GameOfLifeGrid

- (id)initWithSquareSize:(int)squareSize andFrame:(CGRect)frame
{
    self = [super init];
    if (self)
    {
        gridView = [[UIView alloc] initWithFrame:frame];
        sizeOfSquare = squareSize;
        rows = trunc(gridView.frame.size.width/sizeOfSquare);
        columns = trunc(gridView.frame.size.height/sizeOfSquare);
        gridArray = [[NSMutableArray alloc] initWithCapacity:(rows*columns)];
        randomFactor = 20;
        [self buildCellArray];
        growing = NO;
    }
    return self;
}

#pragma mark -
#pragma mark grid lifecycle methods

- (void)destroyLifeInGrid
{
    [self stopGrowing];
    age = 0;
    for (int column=0;column < columns;column++)
    {
        for (int row=0;row < rows;row++)
        {
            [self destroyCellAtRow:row column:column];
        }
    }
}

- (void)buildCellArray
{
    age = 0;
    
    for (int column=0;column < columns;column++)
    {
        for (int row=0;row < rows;row++)
        {
            // Create new cell
            Cell *cell = [[Cell alloc] initWithFrame:CGRectMake(row * sizeOfSquare, column * sizeOfSquare, sizeOfSquare, sizeOfSquare) andColor:black];
            [gridView addSubview:[cell getView]];
            [gridArray addObject:cell];
        }
    }
}

- (void)randomize
{
    [self randomizeFromRow:0 toRow:rows fromColumn:0 toColumn:columns];
}

- (void)randomizeFromRow:(int)fromRow toRow:(int)toRow fromColumn:(int)fromColumn toColumn:(int)toColumn
{
    for (int column=fromColumn;column < toColumn;column++)
    {
        for (int row=fromRow;row < toRow;row++)
        {
            int on = arc4random() % randomFactor;
            
            if (on == 0)
            {
                [self birthCellAtRow:row column:column];
            }
            else
            {
                //[self killCellAtRow:x column:y];
            }
        }
    }

}

- (void)nextGeneration
{
    if (growing)
    {
        for (int column=0;column < columns-2;column++)
        {
            for (int row=0;row < rows-2;row++)
            {
                [self nextGenerationForGridAtRow:row column:column];
            }
        }
        
        age++;
    }
}

#pragma mark -
#pragma mark cell math methods

/*
    Calculation for center cell at grid that starts at top left
    column
    -------
row | | | |
    |-----|
    | |X| |
    |-----|
    | | | |
    -------
 
    eg if center cell is at 1,1 then the grid would start at 0,0
*/
- (int)numberOfLiveNeighborsForGridAtRow:(int)row column:(int)column
{
    int numberOfLiveNeighbors = 0;
    
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
    
    return numberOfLiveNeighbors;
}

- (void)nextGenerationForGridAtRow:(int)row column:(int)column
{
    // TODO: Deal with the last grids somehow
    
    if ((row + 2 <= rows) && (column + 2 <= columns))
    {
        int numberOfLiveNeighbors = [self numberOfLiveNeighborsForGridAtRow:row column:column];
        
        BOOL currentCellIsAlive = [self cellIsAliveAtRow:row+1 column:column+1];
        
        if (currentCellIsAlive)
        {
            // Less than 2 or great than 3 live neighbors kills it
            if ((numberOfLiveNeighbors < 2) || (numberOfLiveNeighbors > 3))
            {
                [self killCellAtRow:row+1 column:column+1];
            }
            else
            {
                [self ageCellAtRow:row+1 column:column+1];
                
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


#pragma mark -
#pragma mark cell lifecycle methods

- (void)startGrowing
{
    growing = YES;
}

- (void)stopGrowing
{
    growing = NO;
}

- (int)getAge
{
    return age;
}

- (BOOL)isGrowing
{
    return growing;
}

- (void)destroyCellAtRow:(int)row column:(int)column andArray:(NSMutableArray*)array
{
    [((Cell*)[array objectAtIndex:row + (column * rows)]) destroy];
}

- (void)birthCellAtRow:(int)row column:(int)column andArray:(NSMutableArray*)array
{
    [((Cell*)[array objectAtIndex:row + (column * rows)]) birth];
}

- (void)ageCellAtRow:(int)row column:(int)column andArray:(NSMutableArray*)array
{
    [((Cell*)[array objectAtIndex:row + (column * rows)]) age];
}

- (void)reviveCellAtRow:(int)row column:(int)column andArray:(NSMutableArray*)array
{
    [((Cell*)[array objectAtIndex:row + (column * rows)]) revive];
}

- (void)killCellAtRow:(int)row column:(int)column andArray:(NSMutableArray*)array
{
    [((Cell*)[array objectAtIndex:row + (column * rows)]) kill];
}

- (BOOL)cellIsAliveAtRow:(int)row column:(int)column andArray:(NSMutableArray*)array
{
    return [((Cell*)[array objectAtIndex:row + (column * rows)]) isAlive];
}

- (void)destroyCellAtRow:(int)row column:(int)column
{
    [self destroyCellAtRow:row column:column andArray:gridArray];
}

- (void)birthCellAtRow:(int)row column:(int)column
{
    [self birthCellAtRow:row column:column andArray:gridArray];
}

- (void)ageCellAtRow:(int)row column:(int)column
{
    [self ageCellAtRow:row column:column andArray:gridArray];
}

- (void)reviveCellAtRow:(int)row column:(int)column
{
    [self reviveCellAtRow:row column:column andArray:gridArray];
}

- (void)killCellAtRow:(int)row column:(int)column
{
    [self killCellAtRow:row column:column andArray:gridArray];
}

- (BOOL)cellIsAliveAtRow:(int)row column:(int)column
{
    return [self cellIsAliveAtRow:row column:column andArray:gridArray];
}

#pragma mark -
#pragma mark grid view methods

- (UIView *)getGridView
{
    return gridView;
}



@end
