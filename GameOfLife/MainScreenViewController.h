//
//  MainScreenViewController.h
//  GameOfLife
//
//  Created by Scott Wasserman on 1/23/14.
//  Copyright (c) 2014 Artisan Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameOfLifeGrid.h"
#import "SlideOutToolStrip.h"

@interface MainScreenViewController : UIViewController
{
    GameOfLifeGrid *grid;
    SlideOutToolStrip *toolStrip;
    CGFloat sizeOfSquare;
    UIView *overlayView;
    CGFloat numberOfHorizontalSquares;
    CGFloat numberOfVerticalSquares;
    UIImageView *rightArrow;
    int deathBoxSize;
    int deathBoxOffset;
    UIImageView *deathBoxView;
    UIButton *deathBoxButtonOverlay;
}

@property (strong, nonatomic) IBOutlet UIView *mainView;

@end
