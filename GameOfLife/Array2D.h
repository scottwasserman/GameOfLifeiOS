//
//  Array2D.h
//  GameOfLife
//
//  Created by Scott Wasserman on 1/23/14.
//  Copyright (c) 2014 Artisan Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Array2D : NSObject
{
    NSMutableArray *gridArray;
    int rows;
    int columns;
}

-(id)initWithRows:(int)numberOfRows andColumns:(int)numberOfColumns;
-(void)setObject:(id)currObject inRow:(int)currRow andColumn:(int)currColumn;
-(id)getObjectInRow:(int)currRow andColumn:(int)currColumn;
@end
