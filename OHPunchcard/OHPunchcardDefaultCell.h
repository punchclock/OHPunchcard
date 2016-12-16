//
//  OHPunchcardDefaultCell.h
//  OHPunchcard
//
//  Created by Jon Gherardini on 12/16/16.
//  Copyright © 2016 Oskar Hagberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OHPunchcardDefaultCell : UICollectionViewCell

@property (nonatomic) CGFloat diameter; // 0.0 - 1.0
@property (nonatomic, copy) UIColor* fillColor;
@property (nonatomic, copy) UIColor* strokeColor;

@end
