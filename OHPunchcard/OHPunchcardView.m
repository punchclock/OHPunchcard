//
//  OHPunchcardView.m
//  OHPunchcard
//
//  Created by Oskar Hagberg on 2013-05-16.
//  Copyright (c) 2013 Oskar Hagberg. All rights reserved.
//

#import "OHPunchcardView.h"
#import "OHPunchcardLayout.h"
#import "OHPunchcardPopup.h"
#import "OHPunchcardDefaultCell.h"
#import "OHPunchcardColumnLegend.h"
#import "OHPunchcardRowLegend.h"

static NSString* const OHPunchcardViewDefaultCellIdentifier = @"OHPunchcardViewDefaultCellIdentifier";
static NSString* const OHPunchcardViewColumnLegendViewIdentifier = @"OHPunchcardViewColumnLegendViewIdentifier";
static NSString* const OHPunchcardViewRowLegendViewIdentifier = @"OHPunchcardViewRowLegendViewIdentifier";

@interface OHPunchcardView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic) CGRect layoutBounds;
@property (nonatomic, strong) OHPunchcardLayout* layout;
@property (nonatomic, strong) OHPunchcardPopup* popup;

@end

@implementation OHPunchcardView

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
    _columns = 7;
    _rows = 12;
    _padding = 2.0;
    _cellSize = 32.0;
    _layoutBounds = CGRectZero;
    
    self.backgroundColor = [UIColor whiteColor];
    self.strokeColor = [UIColor blackColor];
    
    OHPunchcardLayout* layout = [[OHPunchcardLayout alloc] init];
    self.layout = layout;
    UICollectionView* collectionView =
    [[UICollectionView alloc] initWithFrame:self.bounds
                       collectionViewLayout:layout];
    
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    collectionView.translatesAutoresizingMaskIntoConstraints = YES;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    [collectionView registerClass:[OHPunchcardDefaultCell class]
       forCellWithReuseIdentifier:OHPunchcardViewDefaultCellIdentifier];
    [collectionView registerClass:[OHPunchcardColumnLegend class]
       forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
              withReuseIdentifier:OHPunchcardViewColumnLegendViewIdentifier];
    [collectionView registerClass:[OHPunchcardRowLegend class]
       forSupplementaryViewOfKind:OHPunchcardElementKindRowTitle
              withReuseIdentifier:OHPunchcardViewRowLegendViewIdentifier];

    [self addSubview:collectionView];
    self.collectionView = collectionView;
}

#pragma mark - Property getters/setters

- (void)setColumns:(NSUInteger)columns
{
    if (_columns != columns) {
        _columns = columns;
        [self.collectionView reloadData];
        return;
    }
}

- (void)setPadding:(CGFloat)padding
{
    if (_padding != padding) {
        _padding = padding;
        [self configureLayout:self.layout];
    }
}

- (void)setPadding:(CGFloat)padding animated:(BOOL)animated
{
    if (_padding != padding) {
        _padding = padding;
        OHPunchcardLayout* layout = [[OHPunchcardLayout alloc] init];
        self.layout = layout;
        [self configureLayout:layout];
        [self.collectionView setCollectionViewLayout:layout animated:animated];
    }
}

- (void)setCellSize:(CGFloat)cellSize
{
    if (_cellSize != cellSize) {
        _cellSize = cellSize;
        [self configureLayout:self.layout];
    }
}

- (void)setCellSize:(CGFloat)cellSize animated:(BOOL)animated
{
    if (_cellSize != cellSize) {
        _cellSize = cellSize;
        OHPunchcardLayout* layout = [[OHPunchcardLayout alloc] init];
        self.layout = layout;
        [self configureLayout:layout];
        [self.collectionView setCollectionViewLayout:layout animated:animated];
    }
}

#pragma mark - Helper methods

- (void)configureLayout:(OHPunchcardLayout*)layout
{
    CGFloat contentWidth = self.columns * self.cellSize + (self.columns - 1) * self.padding;
    layout.minimumLineSpacing = 0.0;
    layout.minimumInteritemSpacing = self.padding;
    layout.itemSize = CGSizeMake(self.cellSize, self.cellSize);
    layout.headerReferenceSize = CGSizeZero;
    layout.footerReferenceSize = CGSizeZero;
    CGFloat inset = (self.bounds.size.width - contentWidth)/2;
    layout.sectionInset = UIEdgeInsetsMake(self.padding/2, inset, self.padding/2, inset);
    [layout invalidateLayout];
}

- (NSString*)defaultTitleForColumn:(NSInteger)column
{
    static NSArray* titles = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{        
        NSCalendar* cal = [NSCalendar currentCalendar];
        if (cal.firstWeekday == 1) {
            titles = @[@"S", @"M", @"T", @"W", @"T", @"F", @"S"];
        } else {
            titles = @[@"M", @"T", @"W", @"T", @"F", @"S", @"S"];
        }
    });
    return column < titles.count ? titles[column] : nil;
}

- (NSString*)defaultTitleForRow:(NSInteger)row
{
    static NSArray* titles = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        titles = @[@"0", @"2", @"4", @"6", @"8", @"10", @"12", @"14", @"16", @"18", @"20", @"22"];
    });
    return row < titles.count ? titles[row] : nil;
}

- (CGRect)offsetFrameForCellAtIndexPath:(NSIndexPath*)indexPath
{
    UICollectionViewLayoutAttributes* attr = [self.collectionView layoutAttributesForItemAtIndexPath:indexPath];
    CGRect frame = attr.frame;
    frame = CGRectOffset(frame, 0.0, -self.collectionView.contentOffset.y);
    return frame;
}

#pragma mark - Popup management

- (void)showPopupForIndexPath:(NSIndexPath*)indexPath
{
    if (self.popup) {
        [self.popup hide];
    }
    float diameter = [self.dataSource punchcardView:self fractionForItemAtIndexPath:indexPath];
    UIColor* fillColor = [UIColor whiteColor];
    if ([self.dataSource respondsToSelector:@selector(punchcardView:colorForItemAtIndexPath:)]) {
        fillColor = [self.dataSource punchcardView:self colorForItemAtIndexPath:indexPath];
    }
    NSString* title = [NSString stringWithFormat:@"%.02f", diameter];
    if ([self.dataSource respondsToSelector:@selector(punchcardView:titleForPopupAtIndexPath:)]) {
        title = [self.dataSource punchcardView:self titleForPopupAtIndexPath:indexPath];
    }
    
    CGRect cellFrame = [self offsetFrameForCellAtIndexPath:indexPath];
    cellFrame = CGRectInset(cellFrame, (1-diameter)*cellFrame.size.width/2, (1-diameter)*cellFrame.size.height/2);
    CGFloat width = self.bounds.size.width - 20.0;
    CGRect popupFrame = CGRectMake(0.0, 0.0, width, width);
    OHPunchcardPopup* popup = [[OHPunchcardPopup alloc] initWithFrame:popupFrame];
    popup.textLabel.text = title;
    popup.textLabel.textColor = self.strokeColor;
    popup.diameter = 1.0;
    popup.fillColor = [fillColor colorWithAlphaComponent:0.9];
    popup.strokeColor = self.strokeColor;
    [self addSubview:popup];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [popup addGestureRecognizer:tap];
    self.popup = popup;
    
    [popup showInView:self FromRect:cellFrame];
    
}

#pragma mark - Gesture recognizers

- (void)tap:(UITapGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateEnded){
        OHPunchcardPopup* popup = (OHPunchcardPopup*)sender.view;
        [popup hide];
    }
}

#pragma mark - UICollectionView

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!CGRectEqualToRect(self.bounds, self.layoutBounds)) {
        self.layoutBounds = self.bounds;
        [self configureLayout:self.layout];
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    [self.collectionView setBackgroundColor:backgroundColor];
}

#pragma mark - UICollectionViewDataSource

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(self.collectionView.bounds.size.width, self.cellSize);
    }
    return CGSizeZero;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.rows;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.columns;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    OHPunchcardDefaultCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:OHPunchcardViewDefaultCellIdentifier forIndexPath:indexPath];
    UIColor* fillColor = [UIColor whiteColor];
    if ([self.dataSource respondsToSelector:@selector(punchcardView:colorForItemAtIndexPath:)]) {
        fillColor = [self.dataSource punchcardView:self colorForItemAtIndexPath:indexPath];
    }
    cell.fillColor = fillColor;
    cell.strokeColor = self.strokeColor;
    
    float diameter = [self.dataSource punchcardView:self fractionForItemAtIndexPath:indexPath];
    cell.diameter = diameter;
    
    return cell;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([UICollectionElementKindSectionHeader isEqualToString:kind]) {
        if (indexPath.section == 0) {
            OHPunchcardColumnLegend* legend = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:OHPunchcardViewColumnLegendViewIdentifier forIndexPath:indexPath];
            legend.cellSize = self.cellSize;
            legend.padding = self.padding;
            UICollectionViewFlowLayout* layout = (UICollectionViewFlowLayout*)collectionView.collectionViewLayout;
            legend.inset = layout.sectionInset.left;
            legend.columns = self.columns;
            BOOL providesTitle = [self.dataSource respondsToSelector:@selector(punchcardView:titleForColumn:)];
            for (int i = 0; i<self.columns; i++) {
                NSString* text = nil;
                if (providesTitle) {
                    text = [self.dataSource punchcardView:self titleForColumn:i];
                } else {
                    text = [self defaultTitleForColumn:i];
                }
                UILabel* label = legend.labels[i];
                label.textColor = self.strokeColor;
                label.text = text;
            }
            return legend;
        }
    } else if ([OHPunchcardElementKindRowTitle isEqualToString:kind]) {
        OHPunchcardRowLegend* legend = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:OHPunchcardViewRowLegendViewIdentifier forIndexPath:indexPath];
        NSString* text = nil;
        if ([self.dataSource respondsToSelector:@selector(punchcardView:titleForRow:)]) {
            text = [self.dataSource punchcardView:self titleForRow:indexPath.section];
        } else {
            text = [self defaultTitleForRow:indexPath.section];
        }
        legend.label.text = text;
        legend.label.textColor = self.strokeColor;
        return legend;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self showPopupForIndexPath:indexPath];
    if ([self.delegate respondsToSelector:@selector(punchcardView:didSelectItemAtIndexPath:)]) {
        [self.delegate punchcardView:self didSelectItemAtIndexPath:indexPath];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(punchcardView:didDeselectItemAtIndexPath:)]) {
        [self.delegate punchcardView:self didDeselectItemAtIndexPath:indexPath];
    }
}

@end
