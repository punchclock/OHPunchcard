//
//  OHPunchcardView.h
//  OHPunchcard
//
//  Created by Oskar Hagberg on 2013-05-16.
//  Copyright (c) 2013 Oskar Hagberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OHPunchcardView;
@protocol OHPunchcardDataSource;
@protocol OHPunchcardDelegate;

@protocol OHPunchcardDataSource <NSObject>

- (float)punchcardView:(OHPunchcardView*)punchardView fractionForIndexPath:(NSIndexPath*)indexPath;

@optional
- (UIColor*)punchcardView:(OHPunchcardView*)punchardView colorForIndexPath:(NSIndexPath*)indexPath;
- (NSString*)punchcardView:(OHPunchcardView*)punchcardView titleForPopupAtIndexPath:(NSIndexPath*)indexPath;
- (NSString*)punchcardView:(OHPunchcardView*)punchardView titleForColumn:(NSInteger)column;
- (NSString*)punchcardView:(OHPunchcardView*)punchardView titleForRow:(NSInteger)row;

@end

@protocol OHPunchcardDelegate <NSObject>

@optional
- (void)punchcardView:(OHPunchcardView*)punchardView didSelectItemAtIndexPath:(NSIndexPath*)indexPath;
- (void)punchcardView:(OHPunchcardView*)punchardView didDeselectItemAtIndexPath:(NSIndexPath*)indexPath;


@end

@interface OHPunchcardView : UIView

@property (nonatomic, weak) id<OHPunchcardDataSource> dataSource;
@property (nonatomic, weak) id<OHPunchcardDelegate> delegate;

@property (nonatomic) NSUInteger columns;
@property (nonatomic) NSUInteger rows;
@property (nonatomic) CGFloat cellSize;
@property (nonatomic) CGFloat padding;
@property (nonatomic, copy) UIColor* strokeColor;

- (void)setPadding:(CGFloat)padding animated:(BOOL)animated;
- (void)setCellSize:(CGFloat)cellSize animated:(BOOL)animated;

- (CGRect)offsetFrameForCellAtIndexPath:(NSIndexPath*)indexPath;


@end

