//
//  SlideOutToolStrip.m
//  GameOfLife
//
//  Created by Scott Wasserman on 2/7/14.
//  Copyright (c) 2014 Artisan Mobile. All rights reserved.
//

#import "SlideOutToolStrip.h"
#import "UIView+FrameMagic.h"
#import <QuartzCore/QuartzCore.h>

@implementation SlideOutToolStrip
static CGFloat leftOffScreenWidth = 10;
static CGFloat toolstripHeight = 80;
static CGFloat rightPadding = 5;
static CGFloat bottomPadding = 10;
static CGFloat tabWidth = 30;

- (id)initWithParentView:(UIView *)view
{
    parentView = view;
    self = [super initWithFrame:CGRectMake((leftOffScreenWidth * -1),0, parentView.frame.size.width - rightPadding + 5, toolstripHeight)];
    [self setX:(self.frame.size.width * -1) + tabWidth];
    
    if (self) {
        [self setupToolStrip];
    }
    return self;
}

- (void)setupToolStrip
{
    [self setFrameYPixelsUpFromBottomOfScreen:bottomPadding screenHeight:parentView.frame.size.height];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;

    self.backgroundColor = [UIColor clearColor];
   
    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
    background.backgroundColor = [UIColor blackColor];
    background.alpha = 0.6;
    [self addSubview:background];
    
    UIView *tab = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - tabWidth, 0, tabWidth, self.frame.size.height)];
    tab.backgroundColor = [UIColor blackColor];
    tab.alpha = 0.3;
    [self addSubview:tab];
    
    rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right-arrow.png"]];
    [rightArrow centerVerticallyInFrame:tab.frame];
    [rightArrow centerHorizontallyInFrame:tab.frame];
    [rightArrow setX:rightArrow.frame.origin.x + tab.frame.origin.x];
    [self addSubview:rightArrow];
    
    leftArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"left-arrow.png"]];
    [leftArrow centerVerticallyInFrame:tab.frame];
    [leftArrow centerHorizontallyInFrame:tab.frame];
    [leftArrow setX:leftArrow.frame.origin.x + tab.frame.origin.x];
    [self addSubview:leftArrow];
    leftArrow.hidden = YES;
    
    tabButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tabButton.frame = tab.frame;
    tabButton.backgroundColor = [UIColor clearColor];
    [tabButton addTarget:self action:@selector(toggleToolStrip:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:tabButton];
    
}

- (void)setToolView:(UIView *)view
{
    if (toolView)
    {
        [toolView removeFromSuperview];
    }
    
    [self addSubview:view];
}

- (CGRect)getToolViewFrame
{
    return CGRectMake(0, 0, tabButton.frame.origin.x , self.frame.size.height);
}

- (void)toggleToolStrip:(id)sender
{
    if (rightArrow.hidden)
    {
        [self slideIn];
    }
    else
    {
        [self slideOut];
    }
}

- (void)slideIn
{
    CATransition* transition = [CATransition animation];
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.duration = 0.3f;
    transition.type = kCATransitionMoveIn;
    [self.layer removeAllAnimations];
    [self.layer addAnimation:transition forKey:kCATransition];
    
    rightArrow.hidden = NO;
    leftArrow.hidden = YES;
    [self setX:(self.frame.size.width * -1) + tabWidth];
    
    [UIView commitAnimations];

}

- (void)slideOut
{
    CATransition* transition = [CATransition animation];
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromLeft;
    [self.layer removeAllAnimations];
    [self.layer addAnimation:transition forKey:kCATransition];

    rightArrow.hidden = YES;
    leftArrow.hidden = NO;
    [self setX:(leftOffScreenWidth * -1)];
    
    [UIView commitAnimations];
}

@end
