//
//  Array2D.m
//  GameOfLife
//
//  Created by Scott Wasserman on 1/23/14.
//  Copyright (c) 2014 Artisan Mobile. All rights reserved.
//

#import "Array2D.h"

@implementation Array2D

-(id)initWithRows:(int)numberOfRows andColumns:(int)numberOfColumns
{
    self = [super init];
    if (self)
    {
        rows = numberOfRows;
        columns = numberOfColumns;
        gridArray = [[NSMutableArray alloc] initWithCapacity:(rows*columns)];
        [self initArray];
    }
    return self;
}

-(void)initArray
{
    for (int i=0;i < (rows*columns);i++)
    {
        [gridArray addObject:[[NSObject alloc] init]];
    }
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
