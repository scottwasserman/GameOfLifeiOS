//
//  GameOfLifeGrid.h
//  GameOfLife
//
//  Created by Scott Wasserman on 1/23/14.
//  Copyright (c) 2014 Artisan Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameOfLifeGrid : NSObject
{
    NSMutableArray *gridArray;
    NSMutableArray *updateArray;
    int rows;
    int columns;
    int sizeOfSquare;
    UIView *gridView;
    int randomFactor;
    int age;
    BOOL growing;
}

- (id)initWithSquareSize:(int)squareSize andFrame:(CGRect)frame;
- (UIView *)getGridView;
- (void)randomize;
- (void)randomizeFromRow:(int)fromRow toRow:(int)toRow fromColumn:(int)fromColumn toColumn:(int)toColumn;
- (void)nextGeneration;
- (void)killCellAtRow:(int)row column:(int)column;
- (void)reviveCellAtRow:(int)row column:(int)column;
- (void)startGrowing;
- (void)stopGrowing;
- (BOOL)isGrowing;
- (void)destroyLifeInGrid;
- (int)getAge;
@end
