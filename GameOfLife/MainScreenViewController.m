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
    [self seedGrid];
    [self initDeathBox];
    
    [self buildToolStrip];
    [grid startGrowing];
    [self nextGeneration];
    needToRestartGrowing = NO;
    inKillMode = NO;
}

- (void)updateGenerationCounterLabel
{
    generationCounterLabel.text = [NSString stringWithFormat:@"Generation %d",[grid getAge]];
}

#pragma mark -
#pragma mark button methods

- (void)armageddon
{
    [self pauseGrowing];
    
    CATransition* transition = [CATransition animation];
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.duration = 1.0f;
    transition.type =  @"rippleEffect";
    [grid.getGridView.layer removeAllAnimations];
    [grid.getGridView.layer addAnimation:transition forKey:kCATransition];
    
    [grid destroyLifeInGrid];
    
    [UIView commitAnimations];
}

- (void)seedMode
{
    arrowUnderSkull.hidden = YES;
    arrowUnderLeaves.hidden = NO;
    inKillMode = NO;
}

- (void)killMode
{
    arrowUnderSkull.hidden = NO;
    arrowUnderLeaves.hidden = YES;
    inKillMode = YES;
}

- (void)seedGrid
{
    needToRestartGrowing = [grid isGrowing];
    [self pauseGrowing];
    [grid randomize];
    if (needToRestartGrowing)
    {
        [self startGrowing];
    }
}

- (void)pauseGrowing
{
    [grid stopGrowing];
    pauseButton.hidden = YES;
    playButton.hidden = NO;
}

- (void)startGrowing
{
    [grid startGrowing];
    pauseButton.hidden = NO;
    playButton.hidden = YES;
}

#pragma mark -
#pragma mark grid lifecycle methods

- (void)buildToolStrip
{
	CGFloat horizontalPadding = 20;
    
    toolStrip = [[SlideOutToolStrip alloc] initWithParentView:self.mainView];
    UIView *toolStripView = [[UIView alloc] initWithFrame:[toolStrip getToolViewFrame]];
    
    // Generation label
    generationCounterLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,toolStripView.frame.size.width - 5,20)];
    generationCounterLabel.backgroundColor = [UIColor clearColor];
    generationCounterLabel.font = [UIFont boldSystemFontOfSize:12];
    generationCounterLabel.textAlignment = NSTextAlignmentRight;
    generationCounterLabel.textColor = [UIColor whiteColor];
    [toolStripView addSubview:generationCounterLabel];
    [self updateGenerationCounterLabel];
    
    // Pause button
    pauseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [pauseButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    [pauseButton setTintColor:[UIColor whiteColor]];
    [pauseButton addTarget:self action:@selector(pauseGrowing) forControlEvents:UIControlEventTouchUpInside];
    pauseButton.frame = CGRectMake(horizontalPadding, 0, 35, 35);
    [pauseButton centerVerticallyInFrame:toolStripView.frame];
    [toolStripView addSubview:pauseButton];
    
    // Play button
    playButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [playButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    [playButton setTintColor:[UIColor whiteColor]];
    [playButton addTarget:self action:@selector(startGrowing) forControlEvents:UIControlEventTouchUpInside];
    playButton.frame = pauseButton.frame;
    [toolStripView addSubview:playButton];
    playButton.hidden = YES;
    
    // Seeds Mode
    UIButton *seedsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [seedsButton setImage:[UIImage imageNamed:@"leaves.png"] forState:UIControlStateNormal];
    [seedsButton setTintColor:[UIColor greenColor]];
    [seedsButton addTarget:self action:@selector(seedMode) forControlEvents:UIControlEventTouchUpInside];
    seedsButton.frame = CGRectMake(horizontalPadding, 0, 35, 35);
    [seedsButton centerVerticallyInFrame:toolStripView.frame];
    [seedsButton setX:[playButton rightXCoordinate] + 20];
    [toolStripView addSubview:seedsButton];
    
    // Arrow under leaves
    arrowUnderLeaves = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"up-arrow.png"]];
    [arrowUnderLeaves centerHorizontallyInFrame:seedsButton.frame];
    [arrowUnderLeaves setX:arrowUnderLeaves.frame.origin.x + seedsButton.frame.origin.x];
    [arrowUnderLeaves setY:[seedsButton bottomYCoordinate] + 8];
    [toolStripView addSubview:arrowUnderLeaves];
    
    // Skull Mode
    UIButton *skullButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [skullButton setImage:[UIImage imageNamed:@"skull-icon-with-alpha.png"] forState:UIControlStateNormal];
    [skullButton setTintColor:[UIColor blackColor]];
    [skullButton addTarget:self action:@selector(killMode) forControlEvents:UIControlEventTouchUpInside];
    skullButton.frame = CGRectMake(horizontalPadding, 0, 35, 35);
    [skullButton centerVerticallyInFrame:toolStripView.frame];
    [skullButton setX:[seedsButton rightXCoordinate] + 20];
    [toolStripView addSubview:skullButton];
    
    // Arrow under skull
    arrowUnderSkull = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"up-arrow.png"]];
    [arrowUnderSkull centerHorizontallyInFrame:skullButton.frame];
    [arrowUnderSkull setX:arrowUnderSkull.frame.origin.x + skullButton.frame.origin.x];
    [arrowUnderSkull setY:[skullButton bottomYCoordinate] + 8];
    [toolStripView addSubview:arrowUnderSkull];
    arrowUnderSkull.hidden = YES;
    inKillMode = NO;
    
    // Nuke button
    UIButton *nukeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [nukeButton setImage:[UIImage imageNamed:@"nuke-icon.png"] forState:UIControlStateNormal];
    [nukeButton setTintColor:[UIColor orangeColor]];
    [nukeButton addTarget:self action:@selector(armageddon) forControlEvents:UIControlEventTouchUpInside];
    nukeButton.frame = CGRectMake(horizontalPadding, 0, 35, 35);
    [nukeButton centerVerticallyInFrame:toolStripView.frame];
    [nukeButton setX:toolStripView.frame.size.width - 20 - nukeButton.frame.size.width];
    [toolStripView addSubview:nukeButton];
    
    [toolStrip setToolView:toolStripView];
    
    [self.mainView addSubview:toolStrip];
}

- (void)buildLifeGrid
{
    grid = [[GameOfLifeGrid alloc] initWithSquareSize:sizeOfSquare andFrame:CGRectMake(self.mainView.frame.origin.x,self.mainView.frame.origin.y,self.mainView.frame.size.width,self.mainView.frame.size.height)];
    [self.mainView addSubview:[grid getGridView]];
}

- (void)nextGeneration
{
    [grid nextGeneration];
    [self updateGenerationCounterLabel];
    [self performSelector:@selector(nextGeneration) withObject:nil afterDelay:delayBetweenGenerations];
}


#pragma mark -
#pragma mark DeathBox-related methods

- (void)initDeathBox
{
    deathLifeBoxSize = 40;
    
    deathLifeBoxOffset = trunc(deathLifeBoxSize/2);
    
    deathLifeBoxButtonOverlay = [UIButton buttonWithType:UIButtonTypeCustom];
    deathLifeBoxButtonOverlay.frame = self.mainView.frame;
    //[deathLifeBoxButtonOverlay addTarget:self action:@selector(touchDown:withEvent:) forControlEvents:UIControlEventTouchDown];
    [deathLifeBoxButtonOverlay addTarget:self action:@selector(dragBegan:withEvent:) forControlEvents: UIControlEventTouchDown];
    [deathLifeBoxButtonOverlay addTarget:self action:@selector(dragMoving:withEvent:) forControlEvents: UIControlEventTouchDragInside];
    [deathLifeBoxButtonOverlay addTarget:self action:@selector(dragEnded:withEvent:) forControlEvents: UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [self.mainView addSubview:deathLifeBoxButtonOverlay];
    
    deathLifeBoxView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leaves-icon.png"]];
    deathLifeBoxView.frame = CGRectMake(0,0,deathLifeBoxSize,deathLifeBoxSize);
    deathLifeBoxView.hidden = YES;
    [self.mainView addSubview:deathLifeBoxView];
}

- (void)dragBegan:(UIControl *)c withEvent:ev
{
    needToRestartGrowing = [grid isGrowing];
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
    
    int touchBoxTopX = touchPoint.x - deathLifeBoxOffset;
    int touchBoxTopY = touchPoint.y - deathLifeBoxOffset;
    int touchBoxBottomX = touchBoxTopX + deathLifeBoxSize;
    int touchBoxBottomY = touchBoxTopY + deathLifeBoxSize;
    
    if (inKillMode)
    {
        [deathLifeBoxView setImage:[UIImage imageNamed:@"skull-icon.png"]];
    }
    else
    {
        [deathLifeBoxView setImage:[UIImage imageNamed:@"leaves-icon.png"]];
    }
    deathLifeBoxView.frame = CGRectMake(touchBoxTopX, touchBoxTopY, deathLifeBoxSize, deathLifeBoxSize);
    deathLifeBoxView.hidden = NO;
    
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
    
    NSDictionary *killGrowParameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithInt:touchBoxTopX], @"touchBoxTopX",
                                     [NSNumber numberWithInt:touchBoxTopY], @"touchBoxTopY",
                                     [NSNumber numberWithInt:touchBoxBottomX], @"touchBoxBottomX",
                                     [NSNumber numberWithInt:touchBoxBottomY], @"touchBoxBottomY",
                                     nil];
    if (inKillMode)
    {
        [self performSelectorInBackground:@selector(killCellsInBackground:) withObject:killGrowParameters];
    }
    else
    {
        [self performSelectorInBackground:@selector(growCellsInBackground:) withObject:killGrowParameters];
    }
    
}

- (void)growCellsInBackground:(NSDictionary *)killParameters
{
    int beginningXCell = trunc([[killParameters objectForKey:@"touchBoxTopX"] integerValue]/sizeOfSquare);
    int beginningYCell = trunc([[killParameters objectForKey:@"touchBoxTopY"] integerValue]/sizeOfSquare);
    int endingXCell = trunc([[killParameters objectForKey:@"touchBoxBottomX"] integerValue]/sizeOfSquare);
    int endingYCell = trunc([[killParameters objectForKey:@"touchBoxBottomY"] integerValue]/sizeOfSquare);
   
    [grid randomizeFromRow:beginningXCell toRow:endingXCell fromColumn:beginningYCell toColumn:endingYCell];
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
    deathLifeBoxView.hidden = YES;
    if (needToRestartGrowing)
    {
        [grid startGrowing];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
