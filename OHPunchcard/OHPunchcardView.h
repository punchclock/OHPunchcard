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

// Set the desired value in the setup method; 12 rows is the default
typedef enum OHPunchcardViewRowCount : NSUInteger {
    OHPunchcardView12Rows = 12, // For compressed view of 12 2-hour circles
    OHPunchcardView24Rows = 24  // For GitHub-style 24 hour view
} OHPunchcardViewRowCount;

@interface OHPunchcardView : UIView

@property (nonatomic, weak) id<OHPunchcardDataSource> dataSource;
@property (nonatomic, weak) id<OHPunchcardDelegate> delegate;

@property (nonatomic, readonly) NSUInteger columns;
@property (nonatomic, readonly) OHPunchcardViewRowCount rows;
@property (nonatomic, readonly) CGFloat cellSize;
@property (nonatomic, readonly) CGFloat padding;
@property (nonatomic, copy) UIColor* strokeColor;

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

