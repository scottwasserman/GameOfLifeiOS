//
//  MainScreenViewController.h
//  GameOfLife
//
//  Created by Scott Wasserman on 1/23/14.
//  Copyright (c) 2014 Artisan Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameOfLifeGrid.h"

@interface MainScreenViewController : UIViewController
{
    GameOfLifeGrid *grid;
    CGFloat sizeOfSquare;
    CGFloat numberOfHorizontalSquares;
    CGFloat numberOfVerticalSquares;
}

@property (strong, nonatomic) IBOutlet UIView *mainView;

@end
