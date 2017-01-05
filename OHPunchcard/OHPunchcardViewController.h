//
//  OHPunchcardViewController.h
//  OHPunchcard
//
//  Created by Oskar Hagberg on 2013-05-16.
//  Copyright (c) 2013 Oskar Hagberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHPunchcardView.h"

@interface OHPunchcardViewController : UIViewController
@property (weak, nonatomic) IBOutlet OHPunchcardView *punchcardView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end
