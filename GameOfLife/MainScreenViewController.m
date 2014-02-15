//
//  MainScreenViewController.m
//  GameOfLife
//
//  Created by Scott Wasserman on 1/23/14.
//  Copyright (c) 2014 Artisan Mobile. All rights reserved.
//

#import "MainScreenViewController.h"
#import "GameOfLifeGrid.h"
#import "UIView+FrameMagic.h"
#import "UILabel+TextMagic.h"
#import "SlideOutToolStrip.h"
#import <QuartzCore/QuartzCore.h>

@interface MainScreenViewController ()

@end

@implementation MainScreenViewController

static float delayBetweenGenerations = 0.1;

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
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        sizeOfSquare = 8;
    }
    else
    {
        sizeOfSquare = 3;
    }

    [self buildLifeGrid];
    [self initDeathBox];
    
    [self addOverlays];
    [grid startGrowing];
    [toolStrip setGenerationLabel:[grid getAge]];
    [self nextGeneration];
    
}


#pragma mark -
#pragma mark grid lifecycle methods

- (void)addOverlays
{
    toolStrip = [[SlideOutToolStrip alloc] initWithParentView:self.mainView];
    [self.mainView addSubview:toolStrip];
}

- (void)buildLifeGrid
{
    grid = [[GameOfLifeGrid alloc] initWithSquareSize:sizeOfSquare andFrame:CGRectMake(self.mainView.frame.origin.x,self.mainView.frame.origin.y,self.mainView.frame.size.width,self.mainView.frame.size.height)];
    [self.mainView addSubview:[grid getGridView]];
    [grid randomize];
}

- (void)nextGeneration
{
    [grid nextGeneration];
    [toolStrip setGenerationLabel:[grid getAge]];
    [self performSelector:@selector(nextGeneration) withObject:nil afterDelay:delayBetweenGenerations];
}


#pragma mark -
#pragma mark DeathBox-related methods

- (void)initDeathBox
{
    deathBoxSize = 40;
    
    deathBoxOffset = trunc(deathBoxSize/2);
    
    deathBoxButtonOverlay = [UIButton buttonWithType:UIButtonTypeCustom];
    deathBoxButtonOverlay.frame = self.mainView.frame;
    //[deathBoxButtonOverlay addTarget:self action:@selector(toggleRunning) forControlEvents:UIControlEventTouchUpInside];
    [deathBoxButtonOverlay addTarget:self action:@selector(dragBegan:withEvent:) forControlEvents: UIControlEventTouchDown];
    [deathBoxButtonOverlay addTarget:self action:@selector(dragMoving:withEvent:) forControlEvents: UIControlEventTouchDragInside];
    [deathBoxButtonOverlay addTarget:self action:@selector(dragEnded:withEvent:) forControlEvents: UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [self.mainView addSubview:deathBoxButtonOverlay];
    
    deathBoxView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"skull-icon.png"]];
    deathBoxView.frame = CGRectMake(0,0,deathBoxSize,deathBoxSize);
    deathBoxView.hidden = YES;
    [self.mainView addSubview:deathBoxView];
}

- (void)dragBegan:(UIControl *)c withEvent:ev
{
    [self handleTouchWithEvent:ev];
}

- (void)dragMoving:(UIControl *)c withEvent:ev
{
    [self handleTouchWithEvent:ev];
    [grid stopGrowing];
}

- (void)handleTouchWithEvent:ev
{
    UITouch *touch = [[ev allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    
    int touchBoxTopX = touchPoint.x - deathBoxOffset;
    int touchBoxTopY = touchPoint.y - deathBoxOffset;
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
    
    NSDictionary * killParameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithInt:touchBoxTopX], @"touchBoxTopX",
                                     [NSNumber numberWithInt:touchBoxTopY], @"touchBoxTopY",
                                     [NSNumber numberWithInt:touchBoxBottomX], @"touchBoxBottomX",
                                     [NSNumber numberWithInt:touchBoxBottomY], @"touchBoxBottomY",
                                     nil];
    [self performSelectorInBackground:@selector(killCellsInBackground:)
                           withObject:killParameters];
    
}

- (void)killCellsInBackground:(NSDictionary *)killParameters
{
    int beginningXCell = trunc([[killParameters objectForKey:@"touchBoxTopX"] integerValue]/sizeOfSquare);
    int beginningYCell = trunc([[killParameters objectForKey:@"touchBoxTopY"] integerValue]/sizeOfSquare);
    int endingXCell = trunc([[killParameters objectForKey:@"touchBoxBottomX"] integerValue]/sizeOfSquare);
    int endingYCell = trunc([[killParameters objectForKey:@"touchBoxBottomY"] integerValue]/sizeOfSquare);
    
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
    [grid startGrowing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
