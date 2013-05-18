//
//  OHPunchcardView.m
//  OHPunchcard
//
//  Created by Oskar Hagberg on 2013-05-16.
//  Copyright (c) 2013 Oskar Hagberg. All rights reserved.
//

#import "OHPunchcardView.h"
#import "OHPunchcardLayout.h"

static NSString* const OHPunchcardViewDefaultCellIdentifier = @"OHPunchcardViewDefaultCellIdentifier";
static NSString* const OHPunchcardViewColumnLegendViewIdentifier = @"OHPunchcardViewColumnLegendViewIdentifier";
static NSString* const OHPunchcardViewRowLegendViewIdentifier = @"OHPunchcardViewRowLegendViewIdentifier";

@interface OHPunchcardDefaultCell : UICollectionViewCell

//@property (nonatomic, weak, readonly) UILabel* label;
@property (nonatomic) CGFloat diameter; // 0.0 - 1.0
@property (nonatomic, copy) UIColor* fillColor;
@property (nonatomic, copy) UIColor* strokeColor;
@property (nonatomic) BOOL circle;

@end

@implementation OHPunchcardDefaultCell

//@synthesize label = _label;

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

- (void)setDiameter:(CGFloat)diameter
{
    _diameter = diameter;
    [self setNeedsDisplay];
}

- (void)setFillColor:(UIColor *)fillColor
{
    _fillColor = [fillColor copy];
    [self setNeedsDisplay];
}

- (void)setStrokeColor:(UIColor *)strokeColor
{
    _strokeColor = [strokeColor copy];
    [self setNeedsDisplay];
}

- (void)setup
{
    self.opaque = NO;
    self.clipsToBounds = YES;
    self.circle = YES;
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
//    CGContextSetFillColorWithColor(c, [UIColor whiteColor].CGColor);
//    CGContextFillRect(c, rect);

    
    CGContextSetFillColorWithColor(c, self.fillColor.CGColor);
    
    if (self.circle) {
        CGContextFillEllipseInRect(c, ellipseRect);
    } else {
        CGContextFillRect(c, ellipseRect);
    }
    
    CGContextSetLineWidth(c, 1);
    CGContextSetStrokeColorWithColor(c, self.strokeColor.CGColor);
    if (self.circle) {
        CGContextStrokeEllipseInRect(c, ellipseRect);
    } else {
        CGContextStrokeRect(c, ellipseRect);
    }
    
}

- (void)willTransitionFromLayout:(UICollectionViewLayout *)oldLayout toLayout:(UICollectionViewLayout *)newLayout
{
    //    if ([newLayout isKindOfClass:[OHCalendarWeekLayout class]]) {
    //        self.circle = NO;
    //    } else {
    //        self.circle = YES;
    //    }
    [self setNeedsDisplay];
}

@end

@interface OHPunchcardColumnLegend : UICollectionReusableView

@property (nonatomic) CGFloat gutterWidth;
@property (nonatomic) CGFloat cellSize;
@property (nonatomic) CGFloat padding;
@property (nonatomic, strong) NSArray* labels;

@end

@implementation OHPunchcardColumnLegend

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
    
    
    NSMutableArray* labels = [NSMutableArray array];
    for (int i = 0; i<7; i++) {
        UILabel* label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        [labels addObject:label];
        [self addSubview:label];
    }
    self.labels = labels;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat x = self.gutterWidth;
    for (UILabel* label in self.labels) {
        label.frame = CGRectMake(x, 0.0, self.cellSize, self.bounds.size.height);
        x += self.cellSize + self.padding;
    }
}

@end

@interface OHPunchcardRowLegend : UICollectionReusableView

@property (nonatomic, strong) UILabel* label;

@end

@implementation OHPunchcardRowLegend

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
    
    UILabel* label = [[UILabel alloc] initWithFrame:self.bounds];
    label.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    label.textAlignment = NSTextAlignmentRight;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    [self addSubview:label];
    
    self.label = label;
    
}

@end

@interface OHPunchcardView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView* collectionView;

@end

@implementation OHPunchcardView

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
    self.columns = 7;
    self.rows = 12;
    self.padding = 2.0;
    self.cellSize = 32.0;
    
    UICollectionView* collectionView =
    [[UICollectionView alloc] initWithFrame:self.bounds
                       collectionViewLayout:[self newLayout]];
    
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
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

- (void)updateLayout:(BOOL)animated
{
    [self.collectionView setCollectionViewLayout:[self newLayout] animated:animated];
}

- (UICollectionViewLayout*)newLayout
{
    CGFloat cellSize = self.cellSize;
    CGFloat padding = self.padding;
    
    CGFloat contentWidth = 7 * cellSize + 6 * padding;

    OHPunchcardLayout* layout = [[OHPunchcardLayout alloc] init];
    layout.minimumLineSpacing = 0.0;
    layout.minimumInteritemSpacing = padding;
    layout.itemSize = CGSizeMake(cellSize, cellSize);
    layout.headerReferenceSize = CGSizeZero;
    layout.footerReferenceSize = CGSizeZero;
    
    CGFloat gutters = self.bounds.size.width - contentWidth;
    layout.sectionInset = UIEdgeInsetsMake(padding/2, gutters/2.0, padding/2, gutters/2.0);
    return layout;
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
    frame = CGRectOffset(frame, 0.0, self.collectionView.contentOffset.y);
    return frame;
}

#pragma mark - UICollectionViewDataSource implementation

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(self.collectionView.bounds.size.width, _cellSize);
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
    UIColor* fillColor = [UIColor redColor];
    if ([self.dataSource respondsToSelector:@selector(punchcardView:colorForIndexPath:)]) {
        fillColor = [self.dataSource punchcardView:self colorForIndexPath:indexPath];
    }
    cell.fillColor = fillColor;
    
    float diameter = [self.dataSource punchcardView:self fractionForIndexPath:indexPath];
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
            legend.gutterWidth = layout.sectionInset.left;
            BOOL providesTitle = [self.dataSource respondsToSelector:@selector(punchcardView:titleForColumn:)];
            for (int i = 0; i<7; i++) {
                NSString* text = nil;
                if (providesTitle) {
                    text = [self.dataSource punchcardView:self titleForColumn:i];
                } else {
                    text = [self defaultTitleForColumn:i];
                }
                UILabel* label = legend.labels[i];
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
        return legend;
    }
    return nil;
}

#pragma mark UICollectionViewDelegate implementation

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
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
