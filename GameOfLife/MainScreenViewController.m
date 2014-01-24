//
//  MainScreenViewController.m
//  GameOfLife
//
//  Created by Scott Wasserman on 1/23/14.
//  Copyright (c) 2014 Artisan Mobile. All rights reserved.
//

#import "MainScreenViewController.h"
#import "GameOfLifeGrid.h"

@interface MainScreenViewController ()

@end

@implementation MainScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    sizeOfSquare = 3;
    numberOfHorizontalSquares = self.mainView.frame.size.width/sizeOfSquare;
    numberOfVerticalSquares = self.mainView.frame.size.height/sizeOfSquare;
    deathBoxSize = 40;
    
    [self initGrid];
    buttonOverlay = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonOverlay.frame = self.mainView.frame;
    //[buttonOverlay addTarget:self action:@selector(toggleRunning) forControlEvents:UIControlEventTouchUpInside];
    [buttonOverlay addTarget:self action:@selector(dragBegan:withEvent:) forControlEvents: UIControlEventTouchDown];
    [buttonOverlay addTarget:self action:@selector(dragMoving:withEvent:) forControlEvents: UIControlEventTouchDragInside];
    [buttonOverlay addTarget:self action:@selector(dragEnded:withEvent:) forControlEvents: UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [self.mainView addSubview:buttonOverlay];

    deathBoxView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"skull-icon.png"]];
    deathBoxView.frame = CGRectMake(0,0,deathBoxSize,deathBoxSize);
    deathBoxView.hidden = YES;
    [self.mainView addSubview:deathBoxView];
    
    [self startRunning];
}

- (void)dragBegan:(UIControl *)c withEvent:ev
{
    [self handleTouchWithEvent:ev];
}

- (void)dragMoving:(UIControl *)c withEvent:ev
{
    [self handleTouchWithEvent:ev];
    [self stopRunning];
}

- (void)handleTouchWithEvent:ev
{
    UITouch *touch = [[ev allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    
    int touchBoxTopX = touchPoint.x - trunc(deathBoxSize/2);
    int touchBoxTopY = touchPoint.y - trunc(deathBoxSize/2);
    int touchBoxBottomX = touchBoxTopX + deathBoxSize;
    int touchBoxBottomY = touchBoxTopY + deathBoxSize;
    
    deathBoxView.frame = CGRectMake(touchBoxTopX, touchBoxTopY, deathBoxSize, deathBoxSize);
    deathBoxView.hidden = NO;
    
    if (touchBoxTopX < 0)
    {
        touchBoxTopX = 0;
    }
    if (touchBoxTopY < 0)
    {
        touchBoxTopY = 0;
    }
    if (touchBoxBottomX > [grid getGridView].frame.size.width)
    {
        touchBoxBottomX = [grid getGridView].frame.size.width;
    }
    if (touchBoxBottomY > [grid getGridView].frame.size.height)
    {
        touchBoxBottomY = [grid getGridView].frame.size.height;
    }
    
    int beginningXCell = trunc(touchBoxTopX/sizeOfSquare);
    int beginningYCell = trunc(touchBoxTopY/sizeOfSquare);
    int endingXCell = trunc(touchBoxBottomX/sizeOfSquare);
    int endingYCell = trunc(touchBoxBottomY/sizeOfSquare);
    
    for (int y=beginningYCell;y < endingYCell;y++)
    {
        for (int x=beginningXCell;x < endingXCell;x++)
        {
            [grid killCellAtRow:x column:y];
        }
    }

}

- (void)dragEnded:(UIControl *)c withEvent:ev
{
    deathBoxView.hidden = YES;
    [self startRunning];
}

- (void)startRunning
{
    if (!running)
    {
        running = YES;
        [self nextGeneration];
    }
}

- (void)stopRunning
{
    running = NO;
}

- (void)nextGeneration
{
    [grid nextGeneration];
    if (running)
    {
        [self performSelector:@selector(nextGeneration) withObject:nil afterDelay:0.1];
    }
}

- (void)toggleRunning
{
    if (running)
    {
        running = NO;
    }
    else
    {
        running = YES;
        [self nextGeneration];
    }
}

- (void)initGrid
{
    grid = [[GameOfLifeGrid alloc] initWithRows:numberOfHorizontalSquares columns:numberOfVerticalSquares squareSize:sizeOfSquare andFrame:self.mainView.frame];
    [self.mainView addSubview:[grid getGridView]];
    [grid randomize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
