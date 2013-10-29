//
//  HGBackgroundView.m
//  hourglass
//
//  Created by Matze on 22.10.13.
//  Copyright (c) 2013 hourglass. All rights reserved.
//

#import "HGBackgroundView.h"

#define FILL_OPACITY 0.9f
#define STROKE_OPACITY 1.0f

#define LINE_THICKNESS 1.0f
#define CORNER_RADIUS 6.0f

@implementation HGBackgroundView

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    NSRect contentRect = NSInsetRect([self bounds], LINE_THICKNESS, LINE_THICKNESS);
    NSBezierPath *path = [NSBezierPath bezierPath];
    
    // setting some X and Y cooardinates to use for drawing
    CGFloat outerTop = NSMaxY(contentRect) - TRIANGLE_HEIGHT; // top border of panel without triangle height
    CGFloat innerTop = outerTop - CORNER_RADIUS; // inner top border of panel without triangle height
    CGFloat outerBottom = NSMinY(contentRect); // lower bottom
    CGFloat innerBottom = outerBottom + CORNER_RADIUS; // inner bottom
    CGFloat outerRight = NSMaxX(contentRect); // outer right hand border
    CGFloat innerRight = outerRight - CORNER_RADIUS; // inner right hand border
    CGFloat outerLeft = NSMinX(contentRect); // outer left hand border
    CGFloat innerLeft = outerLeft + CORNER_RADIUS; // inner left hand border
    
    NSPoint topRightControlPoint = NSMakePoint(outerRight, outerTop);
    NSPoint topLeftControlPoint = NSMakePoint(outerLeft, outerTop);
    NSPoint bottomRightControlPoint = NSMakePoint(outerRight, outerBottom);
    NSPoint bottomLeftControlPoint = NSMakePoint(outerLeft, outerBottom);
    
    [path moveToPoint:NSMakePoint(_triangle, NSMaxY(contentRect))]; // Starting point at touchpoint with system status bar
    [path lineToPoint:NSMakePoint(_triangle + TRIANGLE_WIDTH / 2, outerTop)]; // draw right arm of the triangle
    [path lineToPoint:NSMakePoint(innerRight, outerTop)];
    [path curveToPoint:NSMakePoint(outerRight, innerTop) controlPoint1:topRightControlPoint controlPoint2:topRightControlPoint];
    [path lineToPoint:NSMakePoint(outerRight, innerBottom)];
    [path curveToPoint:NSMakePoint(innerRight, outerBottom) controlPoint1:bottomRightControlPoint controlPoint2:bottomRightControlPoint];
    [path lineToPoint:NSMakePoint(innerLeft, outerBottom)];
    [path curveToPoint:NSMakePoint(outerLeft, innerBottom) controlPoint1:bottomLeftControlPoint controlPoint2:bottomLeftControlPoint];
    [path lineToPoint:NSMakePoint(outerLeft, innerTop)];
    [path curveToPoint:NSMakePoint(innerLeft, outerTop) controlPoint1:topLeftControlPoint controlPoint2:topLeftControlPoint];
    [path lineToPoint:NSMakePoint(outerRight/2 - TRIANGLE_WIDTH/2,outerTop)];
    [path closePath]; // drawing left arm of triangle
    
    [NSGraphicsContext saveGraphicsState];
    
    NSBezierPath *clip = [NSBezierPath bezierPathWithRect:[self bounds]];
    [clip appendBezierPath:path];
    [clip addClip];
    
    [path setLineWidth:LINE_THICKNESS * 2];
    [[NSColor whiteColor] setStroke];
    [path stroke];
    
    [NSGraphicsContext restoreGraphicsState];
}

@end
