//
//  OHPunchcardPopup.m
//  OHPunchcard
//
//  Created by Oskar Hagberg on 2013-05-18.
//  Copyright (c) 2013 Oskar Hagberg. All rights reserved.
//

#import "OHPunchcardPopup.h"

@implementation OHPunchcardPopup

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
    UILabel* textLabel = [[UILabel alloc] initWithFrame:self.bounds];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.textColor = [UIColor blackColor];
    textLabel.font = [UIFont systemFontOfSize:42.0];
    textLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:textLabel];
    self.textLabel = textLabel;
}

#pragma mark - Helper methods

- (void)showInView:(UIView*)view FromRect:(CGRect)rect
{
    self.originRect = rect;
    [view addSubview:self];
    self.center = CGPointMake(rect.origin.x + rect.size.width/2.0, rect.origin.y + rect.size.height/2.0);
    self.transform = CGAffineTransformMakeScale(rect.size.width/self.bounds.size.width, rect.size.width/self.bounds.size.height);
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformIdentity;
        self.center = self.superview.center;
    }];
}

- (void)hide
{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.center = CGPointMake(self.originRect.origin.x + self.originRect.size.width/2.0, self.originRect.origin.y + self.originRect.size.height/2.0);
        self.transform = CGAffineTransformMakeScale(self.originRect.size.width/self.bounds.size.width, self.originRect.size.width/self.bounds.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UIView

- (void)layoutSubviews
{
    CGRect bounds = self.bounds;
    [super layoutSubviews];
    CGFloat diameter = MIN(bounds.size.width, bounds.size.height);
    CGFloat edge = sqrtf((diameter*diameter)/2);
    self.textLabel.frame = CGRectMake((bounds.size.width - edge)/2.0, (bounds.size.height - edge) / 2.0, edge, edge);
}

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
    //        CGContextSetFillColorWithColor(c, [UIColor whiteColor].CGColor);
    //        CGContextFillRect(c, rect);
    
    CGContextSetFillColorWithColor(c, self.fillColor.CGColor);
    CGContextFillEllipseInRect(c, ellipseRect);
    
    CGContextSetLineWidth(c, 4);
    CGContextSetStrokeColorWithColor(c, self.strokeColor.CGColor);
    CGContextStrokeEllipseInRect(c, CGRectInset(ellipseRect, 2.0, 2.0));
    
}

@end
