//
//  OHPunchcardViewController.m
//  OHPunchcard
//
//  Created by Oskar Hagberg on 2013-05-16.
//  Copyright (c) 2013 Oskar Hagberg. All rights reserved.
//

#import "OHPunchcardViewController.h"
#import "OHPunchcardView.h"

#define ranged_random(min, max) ((float)rand()/RAND_MAX * (max-min)+min)

@interface Popup : UIView

@property (nonatomic) CGFloat diameter;
@property (nonatomic, copy) UIColor* fillColor;
@property (nonatomic, copy) UIColor* strokeColor;

@end

@implementation Popup

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
    self.strokeColor = [UIColor whiteColor];
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
//        CGContextSetFillColorWithColor(c, [UIColor whiteColor].CGColor);
//        CGContextFillRect(c, rect);
    
    CGContextSetFillColorWithColor(c, self.fillColor.CGColor);    
    CGContextFillEllipseInRect(c, ellipseRect);

    CGContextSetLineWidth(c, 4);
    CGContextSetStrokeColorWithColor(c, self.strokeColor.CGColor);
    CGContextStrokeEllipseInRect(c, ellipseRect);

    
}


@end

@interface OHPunchcardViewController () <OHPunchcardDelegate, OHPunchcardDataSource>

@property (nonatomic, strong) OHPunchcardView* punchcardView;
@property (nonatomic, strong) NSArray* data;
@property (nonatomic, strong) NSArray* colors;

@end

@implementation OHPunchcardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    OHPunchcardView* punchcardView = [[OHPunchcardView alloc] initWithFrame:self.view.bounds];
    punchcardView.delegate = self;
    punchcardView.dataSource = self;
    punchcardView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    punchcardView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:punchcardView];
    self.punchcardView = punchcardView;
    
    NSMutableArray* data = [NSMutableArray array];
    NSMutableArray* colors = [NSMutableArray array];
    for (int i = 0; i<12; i++) {
        NSMutableArray* rowData = [NSMutableArray array];
        NSMutableArray* rowColors = [NSMutableArray array];
        [data addObject:rowData];
        [colors addObject:rowColors];
        for (int i = 0; i<7; i++) {
            float value = ranged_random(0.0, 1.0);
            [rowData addObject:@(value)];
            [rowColors addObject:[self randomHSBColor]];
        }
    }
    self.data = data;
    self.colors = colors;

}

#pragma mark - OHPunchcardDelegate

- (void)punchcardView:(OHPunchcardView *)punchardView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    float value = [self.data[indexPath.section][indexPath.row] floatValue];
    
    CGRect cellFrame = [self.punchcardView offsetFrameForCellAtIndexPath:indexPath];
    CGFloat circleWidth = cellFrame.size.width * value;
    CGFloat width = self.view.bounds.size.width - 20.0;
    CGRect popupFrame = CGRectMake(0.0, 0.0, width, width);
    Popup* popup = [[Popup alloc] initWithFrame:popupFrame];
    popup.diameter = 1.0;
    popup.fillColor = [self.colors[indexPath.section][indexPath.row] colorWithAlphaComponent:0.9];
    popup.center = CGPointMake(cellFrame.origin.x + cellFrame.size.width/2.0, cellFrame.origin.y + cellFrame.size.height/2.0);
    [self.view addSubview:popup];
    popup.transform = CGAffineTransformMakeScale(circleWidth/popupFrame.size.width, circleWidth/popupFrame.size.height);
    [UIView animateWithDuration:0.2 animations:^{
        popup.transform = CGAffineTransformIdentity;
        popup.center = self.view.center;
    }];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [popup addGestureRecognizer:tap];
}

- (void)tap:(UITapGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateEnded){
        [sender.view removeFromSuperview];
    }
}

#pragma mark - OHPunchcardDataSource

//- (NSString*)punchcardView:(OHPunchcardView *)punchardView titleForColumn:(NSInteger)column
//{
//    static NSArray* titles = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        titles = @[@"M", @"T", @"O", @"T", @"F", @"L", @"S"];
//    });
//    return column < titles.count ? titles[column] : nil;
//}
//
//- (NSString*)punchcardView:(OHPunchcardView *)punchardView titleForRow:(NSInteger)row
//{
//    static NSArray* titles = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        titles = @[@"0", @"2", @"4", @"6", @"8", @"10", @"12", @"14", @"16", @"18", @"20", @"22"];
//    });
//    return row < titles.count ? titles[row] : nil;
//}

- (float)punchcardView:(OHPunchcardView*)punchardView fractionForIndexPath:(NSIndexPath*)indexPath
{
    return [self.data[indexPath.section][indexPath.row] floatValue];
}

- (UIColor*)punchcardView:(OHPunchcardView*)punchardView colorForIndexPath:(NSIndexPath*)indexPath
{
    return self.colors[indexPath.section][indexPath.row];
}



#define ARC4RANDOM_MAX      0x100000000
- (UIColor*)randomHSBColor
{
    double h = ranged_random(0.2, 0.2);
    double s = ranged_random(0.0, 0.4);
    double b = ranged_random(0.8, 1.0);
    return [UIColor colorWithHue:h saturation:s brightness:b alpha:1.0];
}


@end
