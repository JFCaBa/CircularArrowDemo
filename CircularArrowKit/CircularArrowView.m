//
//  CircularArrowView.m
//  CircularArrowKit
//
//  Created by Robert Ryan on 11/13/17.
//  Copyright © 2017 Robert Ryan. All rights reserved.
//

#import "CircularArrowView.h"

@interface CircularArrowView ()

/// The shape layer for the arrow

@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CAShapeLayer *circleLayer;

@end


@implementation CircularArrowView

@synthesize fillColor = _fillColor;
@synthesize fullCircleColor = _fullCircleColor;
@synthesize startAngle = _startAngle;
@synthesize endAngle = _endAngle;
@synthesize lineWidth = _lineWidth;
@synthesize arrowWidth = _arrowWidth;
@synthesize clockwise = _clockwise;
@synthesize headWidth =_headWidth;

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self updatePath];
}

- (void)configure {
    self.startAngle  = -M_PI_2;
    self.endAngle    = M_PI * 3 / 4;
    self.fillColor   = [UIColor blueColor];
    self.lineWidth   = 0;
    self.arrowWidth  = 40;
    self.clockwise   = true;
    self.headWidth   = 60;
    
    self.shapeLayer = [[CAShapeLayer alloc]init];
    self.circleLayer = [[CAShapeLayer alloc]init];
    
    [self updatePath];
}

/**
 Update path based upon properties.
 
 Note, in this example, I'm just updating the path property of some CAShapeLayer, but if you wanted
 to have some custom color pattern that was revealed by updating this path, you could use this CAShapeLayer
 as a mask instead, revealing some colored pattern (or whatever) instead.
 */
- (void)updatePath
{
    [self drawFullCircle];
    
    CGRect rect = self.bounds;
    
    CGPoint center = CGPointMake(rect.size.width / 2.0, rect.size.height / 2.0);
    CGFloat radius = MIN(rect.size.width / 2.0, rect.size.height / 2.0) - self.headWidth;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(center.x + cosf(self.startAngle) * (radius + self.arrowWidth / 2.0), center.y + sinf(self.startAngle) * (radius + self.arrowWidth / 2.0))];
    
    [path addArcWithCenter:center radius:radius + self.arrowWidth / 2.0 startAngle:self.startAngle endAngle:self.endAngle clockwise:self.clockwise];
    
    [path addLineToPoint:CGPointMake(center.x + cosf(self.endAngle) * (radius + self.headWidth), center.y + sinf(self.endAngle) * (radius + self.headWidth))];
    
    CGFloat theta = asinf((self.headWidth * 1.5) / radius / 2.0) * (self.clockwise ? 1.0 : -1.0);
    CGFloat pointDistance = radius / cosf(theta);
    
    [path addLineToPoint:CGPointMake(center.x + cosf(self.endAngle + theta) * pointDistance, center.y + sinf(self.endAngle + theta) * pointDistance)];
    
    [path addLineToPoint:CGPointMake(center.x + cosf(self.endAngle) * (radius - self.headWidth), center.y + sinf(self.endAngle) * (radius - self.headWidth))];
    
    [path addLineToPoint:CGPointMake(center.x + cosf(self.endAngle) * (radius - self.arrowWidth / 2.0), center.y + sinf(self.endAngle) * (radius - self.arrowWidth / 2.0))];
    
    [path addArcWithCenter:center radius:radius - self.arrowWidth / 2 startAngle:self.endAngle endAngle:self.startAngle clockwise:!self.clockwise];
    
    [path closePath];
    
    [self.shapeLayer setPath:path.CGPath];
    [self.shapeLayer setFillColor:self.fillColor.CGColor];
    [self.shapeLayer setStrokeColor:[UIColor clearColor].CGColor];
    [self.shapeLayer setLineWidth:0];
    
    [self.layer addSublayer:self.shapeLayer];
}

- (void) drawFullCircle
{
    CGRect rect = self.bounds;
    
    CGPoint center = CGPointMake(rect.size.width / 2.0, rect.size.height / 2.0);
    CGFloat radius = MIN(rect.size.width / 2.0, rect.size.height / 2.0) - self.headWidth / 2;
    
    //Create the gray circle
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath addArcWithCenter:center radius:(radius - self.headWidth / 2) startAngle:0 endAngle:2 * M_PI clockwise:YES];
    
    [self.circleLayer setPath:bezierPath.CGPath];
    [self.circleLayer setStrokeColor:self.fullCircleColor.CGColor];
    [self.circleLayer setFillColor:[UIColor clearColor].CGColor];
    [self.circleLayer setLineWidth:_arrowWidth];
    [self.layer addSublayer:self.circleLayer];
}

- (void) didChangeValueForKey:(NSString *)key
{
    [self updatePath];
}
@end
