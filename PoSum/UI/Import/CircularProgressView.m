//
//  CircularProgressView.m
//  PoSum
//
//  Created by Po Sam on 19/05/14.
//  Copyright (c) 2014 Po Sam. All rights reserved.
//

#import "CircularProgressView.h"

@interface CircularProgressView () {
    CGFloat _value;
    CGFloat _minValue;
    CGFloat _maxValue;
    
    CGFloat _criticicalRangeStart;
    
    CGFloat _lineWidth;
    CGFloat _radius;
    
    CGPoint _center;
    
    UIColor *_drawColor;
}

@end

@implementation CircularProgressView

#pragma mark - Life cycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setDefaultValues];
}

#pragma mark - Initialization

- (void)setDefaultValues {
    _value = 0;
    _minValue = 0;
    _maxValue = 100;
    
    _criticicalRangeStart = NSNotFound;
    
    _lineWidth = 10;
    _radius = fminf(self.bounds.size.width, self.bounds.size.height)/2-1;
    
    _center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    _drawColor = [UIColor colorWithRed:255.0/255.0 green:191.0/255.0 blue:17.0/255.0 alpha:1.0];
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
}

- (void)setValue:(CGFloat)value {
    _value = value;
    
    [self setNeedsDisplay];
}

- (void)setDrawColor:(UIColor*)color {
    _drawColor = color;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
//    [self drawCircleWithContext:context];
    [self drawDonutSegmentWithContext:context];
}

/**
 *	Method to draw two circles around the gauge range
 */
- (void)drawCircleWithContext:(CGContextRef)context {
    CGContextSaveGState(context);
    
    [_drawColor set];
    
    float strokeLineWidth = 1.0f;
    CGContextSetLineWidth(context, strokeLineWidth);
    // Draw inner circle
    CGContextBeginPath(context);
    CGContextAddArc(context, _center.x, _center.y, _radius - _lineWidth - (strokeLineWidth/2.0f), 0, 2*M_PI, 0);
    CGContextStrokePath(context);
    
    // Draw outer circle
    CGContextBeginPath(context);
    CGContextAddArc(context, _center.x, _center.y, _radius + (strokeLineWidth/2.0f), 0, 2*M_PI, 0);
    CGContextStrokePath(context);
    
    CGContextRestoreGState(context);
}

- (void)drawDonutSegmentWithContext:(CGContextRef)context {
    // Set angle offset
    static float angleOffset = 90.0f / 180.0f * M_PI;
    
    // Set total length of arc
    static float arcLength = 4.0f/2.0f * M_PI;
    
    // Set starting position of arc with clock wise direction
    float startAngle = 0.0f + angleOffset;
    
    // Determine ending position of arc with clock wise direction
    float endAngle = (_value/_maxValue)*arcLength + angleOffset;
    
    // Create restore point for the context
    CGContextSaveGState(context);
    
    // Create an arc path to represent the skeleton of the donut segment
    CGMutablePathRef arcPath = CGPathCreateMutable();
    
    // Move to starting position of the arc path
    CGPathMoveToPoint(arcPath, NULL, _center.x, _center.y + _radius - (_lineWidth/2));
    // Add the ending position of the arc path
    CGPathAddArc(arcPath, NULL, _center.x, _center.y, _radius - (_lineWidth/2), startAngle, endAngle, 0);
    
    // Create the donut segment by filling the skeleton arc path with volume
    CGPathRef strokedArc = CGPathCreateCopyByStrokingPath(arcPath, NULL,
                                                          _lineWidth,
                                                          kCGLineCapButt,
                                                          kCGLineJoinMiter, // the default
                                                          10);
    
    // Add the donut segment to the context
    CGContextAddPath(context, strokedArc);
    // Set the drawing color
    [_drawColor set];
    
    // Add shadow to the donut
    CGColorRef shadowColor = [UIColor colorWithWhite:1.0 alpha:0.75].CGColor;
    CGContextSetShadowWithColor(context,
                                CGSizeMake(0, 0),   // Offset
                                (_value/_maxValue)*25.0f + 5.0f,               // Radius
                                shadowColor);
    
    // Draw the donut segment with shadow
    CGContextFillPath(context);
    
    // Restore the context
    CGContextRestoreGState(context);
}

@end
