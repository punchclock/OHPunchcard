//
//  OHPunchcardPopup.h
//  OHPunchcard
//
//  Created by Oskar Hagberg on 2013-05-18.
//  Copyright (c) 2013 Oskar Hagberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OHPunchcardPopup : UIView

@property (nonatomic, strong) UILabel* textLabel;
@property (nonatomic) CGFloat diameter;
@property (nonatomic, copy) UIColor* fillColor;
@property (nonatomic, copy) UIColor* strokeColor;
@property (nonatomic) CGRect originRect;

- (void)showInView:(UIView*)view FromRect:(CGRect)rect;
- (void)hide;

@end
