//
//  OHPunchcardColumnLegend.m
//  OHPunchcard
//
//  Created by Jon Gherardini on 12/16/16.
//  Copyright © 2016 Oskar Hagberg. All rights reserved.
//

#import "OHPunchcardColumnLegend.h"

@implementation OHPunchcardColumnLegend

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
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - Property getters/setters

- (void)setColumns:(NSInteger)columns
{
    if (_columns != columns) {
        _columns = columns;
        for (UILabel* label in self.labels) {
            [label removeFromSuperview];
        }
        NSMutableArray* labels = [NSMutableArray array];
        for (int i = 0; i<columns; i++) {
            UILabel* label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor clearColor];
            [labels addObject:label];
            [self addSubview:label];
        }
        self.labels = labels;
        [self setNeedsLayout];
    }
}

#pragma mark - UIView

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat x = self.inset;
    for (UILabel* label in self.labels) {
        label.frame = CGRectMake(x, 0.0, self.cellSize, self.bounds.size.height);
        x += self.cellSize + self.padding;
    }
}

@end
