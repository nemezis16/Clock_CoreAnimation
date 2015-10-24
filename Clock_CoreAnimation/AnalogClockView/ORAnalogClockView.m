//
//  ORAnalogClockView.m
//  Clock_UIViewAnimation
//
//  Created by MacBook on 23.10.15.
//  Copyright (c) 2015 Osadchuk. All rights reserved.
//

#import "ORAnalogClockView.h"
#import <QuartzCore/QuartzCore.h>

#define degreesToRadians(deg) (deg / 180.0 * M_PI)

NSString * const PSAnalogClockViewClockFace  = @"clock_face";
NSString * const PSAnalogClockViewHourHand   = @"hour_hand";
NSString * const PSAnalogClockViewMinuteHand = @"minute_hand";
NSString * const PSAnalogClockViewSecondHand = @"second_hand";
NSString * const PSAnalogClockViewCenterCap  = @"center_cap";

@interface ORAnalogClockView ()

@property (nonatomic, retain) NSTimer *clockUpdateTimer;
@property (nonatomic, retain) NSCalendar *calendar;
@property (nonatomic, retain) NSDate *now;

@property (nonatomic, retain) UIImageView *secondHandImageView;
@property (nonatomic, retain) UIImageView *minuteHandImageView;
@property (nonatomic, retain) UIImageView *hourHandImageView;
@property (nonatomic, retain) UIImageView *clockFaceImageView;
@property (nonatomic, retain) UIImageView *centreCapImageView;

- (void)updateHoursHand;
- (void)updateMinutesHand;
- (void)updateSecondsHand;
- (int)hours;
- (int)minutes;
- (int)seconds;
- (void)addImageViews;

@end



@implementation ORAnalogClockView

@synthesize secondHandImageView  = _secondHandImageView;
@synthesize minuteHandImageView  = _minuteHandImageView;
@synthesize hourHandImageView    = _hourHandImageView;
@synthesize clockFaceImageView   = _clockFaceImageView;
@synthesize centreCapImageView   = _centreCapImageView;

@synthesize clockUpdateTimer     = _clockUpdateTimer;
@synthesize calendar             = _calendar;
@synthesize now                  = _now;

@synthesize rotationPoint= _rotationPoint;

#pragma mark -
#pragma mark Initializers


-(instancetype)initWithFrame:(CGRect)frame andImages:(NSDictionary *)images
{
    self = [super initWithFrame:frame];
    if (self) {
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        
        CGRect imageViewFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
        _rotationPoint=CGPointMake(frame.size.width/2, frame.size.height/2);
        
        _clockFaceImageView  = [[UIImageView alloc] initWithFrame:imageViewFrame];
        _hourHandImageView   = [[UIImageView alloc] initWithFrame:imageViewFrame];
        _minuteHandImageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
        _secondHandImageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
        _centreCapImageView  = [[UIImageView alloc] initWithFrame:imageViewFrame];
        
        //set images to properties form dictionary
        if (images) {
            self.clockFaceImage  = [images objectForKey:PSAnalogClockViewClockFace];
            self.hourHandImage   = [images objectForKey:PSAnalogClockViewHourHand];
            self.minuteHandImage = [images objectForKey:PSAnalogClockViewMinuteHand];
            self.secondHandImage = [images objectForKey:PSAnalogClockViewSecondHand];
            self.centerCapImage  = [images objectForKey:PSAnalogClockViewCenterCap];
            
            [self addImageViews];
        }
    }
    return self;
}

//add image views if subviews doesn't contain this image
- (void)addImageViews
{
    NSArray *subViews = [self subviews];
    
    if (self.clockFaceImageView.image && ![subViews containsObject:self.clockFaceImageView]) {
        [self addSubview:self.clockFaceImageView];
    }
    if (self.hourHandImageView.image && ![subViews containsObject:self.hourHandImageView]) {
        [self addSubview:self.hourHandImageView];
    }
    if (self.minuteHandImageView.image && ![subViews containsObject:self.minuteHandImageView]) {
        [self addSubview:self.minuteHandImageView];
    }
    if (self.secondHandImageView.image && ![subViews containsObject:self.secondHandImageView]) {
        [self addSubview:self.secondHandImageView];
    }
    if (self.centreCapImageView.image && ![subViews containsObject:self.centreCapImageView]) {
        [self addSubview:self.centreCapImageView];
    }
}


#pragma mark -
#pragma mark Start and Update the clock

- (void)start
{
	self.clockUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateClockTimeAnimated) userInfo:nil repeats:YES];
    [self updateClockTimeAnimated];
}


- (void)updateClockTimeAnimated
{
    [self addImageViews];
    
    self.now = [NSDate date];
    
    [self updateHoursHand];
    [self updateMinutesHand];
    [self updateSecondsHand];
    
    
}

- (void) runClockAnimationOnView:(UIView*)view rotateFrom:(CGFloat)from to:(CGFloat)to withDuration:(NSInteger)duration andKey:(NSString*)key;
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:from];
    rotationAnimation.toValue =[NSNumber numberWithFloat: to];
    rotationAnimation.duration = duration;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAAnimationLinear];
    [view.layer addAnimation:rotationAnimation forKey:key];
}

- (void)updateHoursHand
{
    if (nil == self.hourHandImage) {
        return;
    }
    int hoursFrom=[self getHourAngle:[self hours]-1];
    int hours = [self getHourAngle:[self hours]];
    
    double hourAngleFrom = degreesToRadians(hoursFrom);
    double hourAngle = degreesToRadians(hours);
   
    
    if (self.minutes==0) 
    [self runClockAnimationOnView:self.hourHandImageView rotateFrom:hourAngleFrom to:hourAngle withDuration:1 andKey:@"rotateAnimationHours"];
    
    self.hourHandImageView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, hourAngle);
}

-(float)getHourAngle:(int)hours{
    
    int degreesPerHour   = 30;
    int degreesPerMinute = 0.5;
    
    int hoursFor12HourClock = hours < 12 ? hours : hours - 12;
    
    float rotationForHoursComponent  = hoursFor12HourClock * degreesPerHour;
    float rotationForMinuteComponent = degreesPerMinute * [self minutes];
    
    float totalRotation = rotationForHoursComponent + rotationForMinuteComponent;
    
    return totalRotation;
}

- (void)updateMinutesHand
{
    if (nil == self.minuteHandImage) {
        return;
    }
    
    int degreesPerMinute = 6;
    
    double minutesAngleFrom = degreesToRadians(([self minutes]-1) * degreesPerMinute);
    double minutesAngle = degreesToRadians([self minutes] * degreesPerMinute);
    
     if (self.seconds==0) 
    [self runClockAnimationOnView:self.minuteHandImageView rotateFrom:minutesAngleFrom to:minutesAngle withDuration:1 andKey:@"rotationAnimationMinutes"];
    
    self.minuteHandImageView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, minutesAngle);
}

- (void)updateSecondsHand
{
    if (nil == self.secondHandImage) {
        return;
    }
    
    int degreesPerSecond = 6;
    
    double secondsAngle = degreesToRadians([self seconds] * degreesPerSecond);
    
    double secondsAngleFrom = degreesToRadians(([self seconds]-1) * degreesPerSecond);
    
    [self runClockAnimationOnView:self.secondHandImageView rotateFrom:secondsAngleFrom to:secondsAngle withDuration:1 andKey:@"rotationAnimationSeconds"];
    
    self.secondHandImageView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, secondsAngle);
}

- (int)hours
{
    return [[self.calendar components:NSHourCalendarUnit fromDate:self.now] hour];
}

- (int)minutes
{
    return [[self.calendar components:NSMinuteCalendarUnit fromDate:self.now] minute];
}

- (int)seconds
{
    return [[self.calendar components:NSSecondCalendarUnit fromDate:self.now] second];;
}

#pragma mark -
#pragma mark Setters + getters for adding clock images

- (void)setSecondHandImage:(UIImage *)secondHandImage
{
    self.secondHandImageView.image = secondHandImage;
}

- (UIImage *)secondHandImage
{
    return self.secondHandImageView.image;
}

- (void)setMinuteHandImage:(UIImage *)minuteHandImage
{
    self.minuteHandImageView.image = minuteHandImage;
}

- (UIImage *)minuteHandImage
{
    return self.minuteHandImageView.image;
}

- (void)setHourHandImage:(UIImage *)hourHandImage
{
    self.hourHandImageView.image = hourHandImage;
}

- (UIImage *)hourHandImage
{
    return  self.hourHandImageView.image;
}

- (void)setCenterCapImage:(UIImage *)centerCapImage
{
    self.centreCapImageView.image = centerCapImage;
}

- (UIImage *)centerCapImage
{
    return  self.centreCapImageView.image;
}

- (void)setClockFaceImage:(UIImage *)clockFaceImage
{
    self.clockFaceImageView.image = clockFaceImage;
}

- (UIImage *)clockFaceImage
{
    return self.clockFaceImageView.image;
}




@end
