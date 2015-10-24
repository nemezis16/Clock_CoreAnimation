//
//  ORViewController.m
//  Clock_UIViewAnimation
//
//  Created by MacBook on 22.10.15.
//  Copyright (c) 2015 Osadchuk. All rights reserved.
//

#import "ORViewController.h"
#import "ORAnalogClockView.h"

@interface ORViewController ()

@end

@implementation ORViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self instantiateClockUsingADictionaryOfImages];
}

- (void)instantiateClockUsingADictionaryOfImages
{
    ORAnalogClockView *analogClock3 = [[ORAnalogClockView alloc] initWithFrame:CGRectMake(60, 120, 200, 200)
                                                                     andImages:[self images]];
    [self.view addSubview:analogClock3];
    [analogClock3 start];
}

- (NSDictionary *)images
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [UIImage imageNamed:@"clock"], PSAnalogClockViewClockFace,
            [UIImage imageNamed:@"clock_hour_hand"], PSAnalogClockViewHourHand,
            [UIImage imageNamed:@"clock_minute_hand"], PSAnalogClockViewMinuteHand,
            [UIImage imageNamed:@"clock_second_hand"], PSAnalogClockViewSecondHand,
            [UIImage imageNamed:@"clock_centre_point"], PSAnalogClockViewCenterCap,
            nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
