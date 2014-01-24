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
    int rows;
    int columns;
    int sizeOfSquare;
    UIView *gridView;
}

-(id)initWithRows:(int)numberOfRows columns:(int)numberOfColumns squareSize:(int)squareSize andFrame:(CGRect)frame;
-(UIView *)getGridView;
-(void)randomize;

@end
