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
    
    sizeOfSquare = 5;
    numberOfHorizontalSquares = self.mainView.frame.size.width/sizeOfSquare;
    numberOfVerticalSquares = self.mainView.frame.size.height/sizeOfSquare;
    
    [self initGrid];
    buttonOverlay = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonOverlay.frame = self.mainView.frame;
    [buttonOverlay addTarget:self action:@selector(randomize) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:buttonOverlay];
    
    //[self fillGridWithRandomViews];
    //[self updateDisplay];
}

- (void)initGrid
{
    grid = [[GameOfLifeGrid alloc] initWithRows:numberOfHorizontalSquares columns:numberOfVerticalSquares squareSize:sizeOfSquare andFrame:self.mainView.frame];
    [self.mainView addSubview:[grid getGridView]];
    [grid randomize];
}

- (void)randomize
{
    [grid randomize];
}

/*
- (void)fillGridWithRandomViews
{
    for (int y=0;y < numberOfVerticalSquares;y++)
    {
        for (int x=0;x < numberOfHorizontalSquares;x++)
        {
            UIView *square = [[UIView alloc] initWithFrame:CGRectMake(x * sizeOfSquare, y * sizeOfSquare, sizeOfSquare, sizeOfSquare)];
            
            int onoff = arc4random() % 2;
            
            if (onoff == 1)
            {
                square.backgroundColor = [UIColor whiteColor];
            }
            else
            {
                square.backgroundColor = [UIColor blackColor];
            }
            [self.mainView addSubview:square];
            [grid setObject:square inRow:x andColumn:y];
        }
    }

}

- (void)updateDisplay
{
    for (int y=0;y < numberOfVerticalSquares;y++)
    {
        for (int x=0;x < numberOfHorizontalSquares;x++)
        {
            
        }
    }
    
}


 - (void)updateDisplay
 {
 for (int y=0;y < numberOfVerticalSquares;y++)
 {
 for (int x=0;x < numberOfHorizontalSquares;x++)
 {
 UIView *square = [[UIView alloc] initWithFrame:CGRectMake(x * sizeOfSquare, y * sizeOfSquare, sizeOfSquare, sizeOfSquare)];
 
 int onoff = arc4random() % 2;
 
 if (onoff == 1)
 {
 square.backgroundColor = [UIColor whiteColor];
 }
 else
 {
 square.backgroundColor = [UIColor blackColor];
 }
 [self.view addSubview:square];
 }
 }
 
 }
 */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)buttonOverlayTouchUpInside:(UIButton *)sender
{
    [grid randomize];
}
@end
