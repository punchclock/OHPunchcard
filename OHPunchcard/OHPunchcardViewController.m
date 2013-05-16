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

@interface OHPunchcardViewController () <OHPunchcardDelegate, OHPunchcardDataSource>

@property (nonatomic, strong) OHPunchcardView* punchcardView;

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

}

#pragma mark - OHPunchcardDataSource

- (float)punchcardView:(OHPunchcardView*)punchardView fractionForIndexPath:(NSIndexPath*)indexPath
{
    return ranged_random(0.0, 1.0);
}

- (UIColor*)punchcardView:(OHPunchcardView*)punchardView colorForIndexPath:(NSIndexPath*)indexPath
{
    return [self randomHSBColor];
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
