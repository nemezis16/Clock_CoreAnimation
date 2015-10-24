//
//  ORAnalogClockView.h
//  Clock_UIViewAnimation
//
//  Created by MacBook on 23.10.15.
//  Copyright (c) 2015 Osadchuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


extern NSString * const PSAnalogClockViewClockFace;
extern NSString * const PSAnalogClockViewHourHand;
extern NSString * const PSAnalogClockViewMinuteHand;
extern NSString * const PSAnalogClockViewSecondHand;
extern NSString * const PSAnalogClockViewCenterCap;

@interface ORAnalogClockView : UIView

@property (nonatomic, strong) UIImage *secondHandImage;
@property (nonatomic, strong) UIImage *minuteHandImage;
@property (nonatomic, strong) UIImage *hourHandImage;
@property (nonatomic, strong) UIImage *centerCapImage;
@property (nonatomic, strong) UIImage *clockFaceImage;
@property (nonatomic, assign) CGPoint rotationPoint;


- (id)initWithFrame:(CGRect)frame andImages:(NSDictionary *)images;
- (void)start;
- (void)updateClockTimeAnimated;


@end
