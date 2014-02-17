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
    int deathLifeBoxSize;
    int deathLifeBoxOffset;
    UIImageView *deathLifeBoxView;
    UIButton *deathLifeBoxButtonOverlay;
    BOOL needToRestartGrowing;
    
    // For toolbar
    UILabel *generationCounterLabel;
    UIButton *playButton;
    UIButton *pauseButton;
    UIImageView *arrowUnderLeaves;
    UIImageView *arrowUnderSkull;
    BOOL inKillMode;
}

@property (strong, nonatomic) IBOutlet UIView *mainView;

@end
