//
//  OHPunchcardColumnLegend.h
//  OHPunchcard
//
//  Created by Jon Gherardini on 12/16/16.
//  Copyright © 2016 Oskar Hagberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OHPunchcardColumnLegend : UICollectionReusableView

@property (nonatomic) CGFloat inset;
@property (nonatomic) CGFloat cellSize;
@property (nonatomic) CGFloat padding;
@property (nonatomic) NSInteger columns;
@property (nonatomic, strong) NSArray* labels;

@end
