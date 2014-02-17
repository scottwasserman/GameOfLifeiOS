//
//  SlideOutToolStrip.h
//  GameOfLife
//
//  Created by Scott Wasserman on 2/7/14.
//  Copyright (c) 2014 Artisan Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideOutToolStrip : UIView
{
    UILabel *generationCounterLabel;
    UIView *parentView;
    UIView *toolView;
    UIButton *tabButton;
    UIImageView *rightArrow;
    UIImageView *leftArrow;
    UIView *overlayView;
}

- (id)initWithParentView:(UIView *)view;
- (void)setToolView:(UIView *)view;
- (CGRect)getToolViewFrame;
@end
