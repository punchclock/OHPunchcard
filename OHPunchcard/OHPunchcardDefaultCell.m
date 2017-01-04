//
//  OHPunchcardDefaultCell.m
//  OHPunchcard
//
//  Created by Jon Gherardini on 12/16/16.
//  Copyright © 2016 Oskar Hagberg. All rights reserved.
//

#import "OHPunchcardDefaultCell.h"

@implementation OHPunchcardDefaultCell

#pragma mark - Initializers

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.opaque = NO;
    self.clipsToBounds = YES;
    self.strokeColor = [UIColor whiteColor];
}

#pragma mark - Property getters/setters

- (void)setDiameter:(CGFloat)diameter
{
    _diameter = diameter;
    [self setNeedsDisplay];
}

- (void)setFillColor:(UIColor *)fillColor
{
    _fillColor = [fillColor copy];
    [self setNeedsDisplay];
}

- (void)setStrokeColor:(UIColor *)strokeColor
{
    _strokeColor = [strokeColor copy];
    [self setNeedsDisplay];
}

#pragma mark - UICollectionViewCell

- (void)drawRect:(CGRect)rect
{
    
    CGFloat edge = MIN(rect.size.width, rect.size.height);
    CGRect ellipseRect = CGRectZero;
    if (self.diameter == 1.0) {
        ellipseRect = rect;
    } else {
        CGFloat inset = (edge - self.diameter * edge) / 2.0;
        inset = floorf(inset) + 1.0;
        ellipseRect = CGRectInset(rect, inset, inset);
    }
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextClearRect(c, rect);
    
    //Debug
    //    CGContextSetFillColorWithColor(c, [UIColor whiteColor].CGColor);
    //    CGContextFillRect(c, rect);
    
    CGContextSetFillColorWithColor(c, self.fillColor.CGColor);
    CGContextFillEllipseInRect(c, ellipseRect);
    
    CGContextSetLineWidth(c, 1);
    CGContextSetStrokeColorWithColor(c, self.strokeColor.CGColor);
    CGContextStrokeEllipseInRect(c, ellipseRect);
    
}

// TODO: determine if still needed
/*
#pragma mark - UICollectionReusableView (superclass of UICollectionViewCell)


- (void)willTransitionFromLayout:(UICollectionViewLayout *)oldLayout toLayout:(UICollectionViewLayout *)newLayout
{
    //    if ([newLayout isKindOfClass:[OHCalendarWeekLayout class]]) {
    //        self.circle = NO;
    //    } else {
    //        self.circle = YES;
    //    }
    [self setNeedsDisplay];
}
*/
@end
