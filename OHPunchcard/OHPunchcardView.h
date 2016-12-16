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


#pragma mark - Protocol definitions

@protocol OHPunchcardDataSource <NSObject>

- (float)punchcardView:(OHPunchcardView*)punchcardView fractionForItemAtIndexPath:(NSIndexPath*)indexPath;

@optional
- (UIColor*)punchcardView:(OHPunchcardView*)punchcardView colorForItemAtIndexPath:(NSIndexPath*)indexPath;
- (NSString*)punchcardView:(OHPunchcardView*)punchcardView titleForPopupAtIndexPath:(NSIndexPath*)indexPath;
- (NSString*)punchcardView:(OHPunchcardView*)punchcardView titleForColumn:(NSInteger)column;
- (NSString*)punchcardView:(OHPunchcardView*)punchcardView titleForRow:(NSInteger)row;

@end

@protocol OHPunchcardDelegate <NSObject>

@optional
- (void)punchcardView:(OHPunchcardView*)punchcardView didSelectItemAtIndexPath:(NSIndexPath*)indexPath;
- (void)punchcardView:(OHPunchcardView*)punchcardView didDeselectItemAtIndexPath:(NSIndexPath*)indexPath;

@end

