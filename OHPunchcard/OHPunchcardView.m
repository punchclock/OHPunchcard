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
static NSString* const OHPunchcardViewWeekendLegendViewIdentifier = @"OHPunchcardViewWeekendLegendViewIdentifier";

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

@interface OHPunchcardWeekdayLegend : UICollectionReusableView

@property (nonatomic) CGFloat gutterWidth;
@property (nonatomic) CGFloat cellSize;
@property (nonatomic) CGFloat padding;
@property (nonatomic, strong) NSArray* labels;

@end

@implementation OHPunchcardWeekdayLegend

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
    
    NSArray* weekdays = @[@"M", @"T", @"W", @"T", @"F", @"S", @"S"];
    
    NSMutableArray* labels = [NSMutableArray array];
    for (int i = 0; i<7; i++) {
        UILabel* label = [[UILabel alloc] init];
        label.text = weekdays[i];
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

@interface OHPunchcardView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView* collectionView;

@property (nonatomic) CGFloat cellSize;
@property (nonatomic) CGFloat padding;

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
    self.padding = 2.0;
    self.cellSize = 32.0;
    CGFloat contentWidth = 7 * _cellSize + 6 * _padding;
    
    OHPunchcardLayout* layout = [[OHPunchcardLayout alloc] init];
    layout.minimumLineSpacing = 0.0;
    layout.minimumInteritemSpacing = _padding;
    layout.itemSize = CGSizeMake(_cellSize, _cellSize);
    layout.headerReferenceSize = CGSizeZero;
    layout.footerReferenceSize = CGSizeZero;
    
    CGFloat gutters = self.bounds.size.width - contentWidth;
    layout.sectionInset = UIEdgeInsetsMake(_padding/2, gutters/2.0, _padding/2, gutters/2.0);
    
    UICollectionView* collectionView =
    [[UICollectionView alloc] initWithFrame:self.bounds
                       collectionViewLayout:layout];
    
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    [collectionView registerClass:[OHPunchcardDefaultCell class]
       forCellWithReuseIdentifier:OHPunchcardViewDefaultCellIdentifier];
    [collectionView registerClass:[OHPunchcardWeekdayLegend class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:OHPunchcardViewWeekendLegendViewIdentifier];

    [self addSubview:collectionView];
    self.collectionView = collectionView;
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
    return 12;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 7;
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
            OHPunchcardWeekdayLegend* legend = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:OHPunchcardViewWeekendLegendViewIdentifier forIndexPath:indexPath];
            legend.cellSize = self.cellSize;
            legend.padding = self.padding;
            UICollectionViewFlowLayout* layout = (UICollectionViewFlowLayout*)collectionView.collectionViewLayout;
            legend.gutterWidth = layout.sectionInset.left;
            return legend;
        }
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


@implementation NSIndexPath (OHPunchcardViewAdditions)

+ (NSIndexPath *)indexPathForHourspan:(NSInteger)hourspan inWeekday:(NSInteger)weekday
{
    return [NSIndexPath indexPathForRow:hourspan inSection:weekday];
}

- (NSInteger)hourspan
{
    return self.row;
}

- (NSInteger)weekday
{
    return self.section;
}


@end
