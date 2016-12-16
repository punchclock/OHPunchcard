//
//  OHPunchcardViewController.m
//  OHPunchcard
//
//  Created by Oskar Hagberg on 2013-05-16.
//  Copyright (c) 2013 Oskar Hagberg. All rights reserved.
//

#import "OHPunchcardViewController.h"

#define ranged_random(min, max) ((float)rand()/RAND_MAX * (max-min)+min)

@interface OHPunchcardViewController () <OHPunchcardDelegate, OHPunchcardDataSource>

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
    
    self.punchcardView.delegate = self;
    self.punchcardView.dataSource = self;
    self.punchcardView.cellSize = 30.0; //To fit the toolbar
    self.punchcardView.backgroundColor = [UIColor whiteColor];
//    self.punchcardView.columns = 1;
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

#pragma mark - OHPunchcardDataSource

- (NSString*)punchcardView:(OHPunchcardView *)punchcardView titleForColumn:(NSInteger)column
{
    static NSArray* titles = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        titles = @[@"一", @"二", @"三", @"四", @"五", @"六", @"七"];
    });
    return column < titles.count ? titles[column] : nil;
}
//
//- (NSString*)punchcardView:(OHPunchcardView *)punchcardView titleForRow:(NSInteger)row
//{
//    static NSArray* titles = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        titles = @[@"0", @"2", @"4", @"6", @"8", @"10", @"12", @"14", @"16", @"18", @"20", @"22"];
//    });
//    return row < titles.count ? titles[row] : nil;
//}

//- (NSString*)punchcardView:(OHPunchcardView*)punchcardView titleForPopupAtIndexPath:(NSIndexPath*)indexPath
//{
//    return [NSString stringWithFormat:@"%d,%d", indexPath.section, indexPath.row];
//}

- (float)punchcardView:(OHPunchcardView*)punchcardView fractionForItemAtIndexPath:(NSIndexPath*)indexPath
{
    return [self.data[indexPath.section][indexPath.row] floatValue];
}

- (UIColor*)punchcardView:(OHPunchcardView*)punchcardView colorForItemAtIndexPath:(NSIndexPath*)indexPath
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

- (IBAction)paddingChanged:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        [self.punchcardView setPadding:2 animated:YES];
    } else {
        [self.punchcardView setPadding:10 animated:YES];
    }
}

- (IBAction)cellSizeChanged:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        [self.punchcardView setCellSize:12.0 animated:YES];
    } else if (sender.selectedSegmentIndex == 1) {
        [self.punchcardView setCellSize:32.0 animated:YES];
    } else {
        [self.punchcardView setCellSize:44.0 animated:YES];
    }
}

- (IBAction)columnCountChanged:(UISegmentedControl *)sender {
    // Linking the column count to the text on the button is not the best,
    // but it's fine enough for a demo app
    NSInteger columnCount = [[[[sender titleForSegmentAtIndex:[sender selectedSegmentIndex]] componentsSeparatedByString:@": "] lastObject] integerValue];
    self.punchcardView.columns = columnCount > 0 ? columnCount : 1;
}

@end
