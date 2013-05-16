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


@end

@protocol OHPunchcardDelegate <NSObject>

@optional
- (void)punchcardView:(OHPunchcardView*)punchardView didSelectItemAtIndexPath:(NSIndexPath*)indexPath;
- (void)punchcardView:(OHPunchcardView*)punchardView didDeselectItemAtIndexPath:(NSIndexPath*)indexPath;


@end

@interface OHPunchcardView : UIView

@property (nonatomic, weak) id<OHPunchcardDataSource> dataSource;
@property (nonatomic, weak) id<OHPunchcardDelegate> delegate;


@end

@interface NSIndexPath (OHPunchcardViewAdditions)

+ (NSIndexPath *)indexPathForHourspan:(NSInteger)hourspan inWeekday:(NSInteger)weekday;

@property (nonatomic, readonly) NSInteger hourspan;
@property (nonatomic, readonly) NSInteger weekday;


@end
