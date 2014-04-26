//
//  BackgroundView.m
//  hourglass
//
//  Created by Matze on 25/04/14.
//  Copyright (c) 2014 hourglass. All rights reserved.
//

#import "BackgroundView.h"

@implementation BackgroundView

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    NSRect navigatorBar = [self bounds];
    NSBezierPath *path = [NSBezierPath bezierPath];
    
    // setting some X and Y cooardinates to use for drawing
    CGFloat outerTop = NSMaxY(navigatorBar) - TRIANGLE_HEIGHT; // top border of panel without triangle height
    CGFloat innerTop = outerTop - CORNER_RADIUS; // inner top border of panel without triangle height
    CGFloat Bottom = outerTop - BUTTON_SIZE; // lower bottom
    CGFloat outerRight = NSMaxX(navigatorBar); // outer right hand border
    CGFloat outerLeft = NSMinX(navigatorBar); // outer left hand border
    
    NSPoint topRightControlPoint = NSMakePoint(outerRight, outerTop);
    NSPoint topLeftControlPoint = NSMakePoint(outerLeft, outerTop);
    
    [path moveToPoint:NSMakePoint(_triangle, NSMaxY(navigatorBar))]; // Starting point at touchpoint with system status bar
    [path lineToPoint:NSMakePoint(_triangle + TRIANGLE_WIDTH / 2, outerTop)]; // draw right arm of the triangle
    [path lineToPoint:NSMakePoint(outerRight - CORNER_RADIUS, outerTop)];
    [path curveToPoint:NSMakePoint(outerRight, innerTop) controlPoint1:topRightControlPoint controlPoint2:topRightControlPoint];
    [path lineToPoint:NSMakePoint(outerRight, Bottom)];
    [path lineToPoint:NSMakePoint(outerLeft, Bottom)];
    [path lineToPoint:NSMakePoint(outerLeft, innerTop)];
    [path curveToPoint:NSMakePoint(outerLeft + CORNER_RADIUS, outerTop) controlPoint1:topLeftControlPoint controlPoint2:topLeftControlPoint];
    [path lineToPoint:NSMakePoint(outerRight/2 - TRIANGLE_WIDTH/2,outerTop)];
    [path closePath]; // drawing left arm of triangle
    
    NSGradient *fillGradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedRed:(235/255.0) green:(235/255.0) blue:(235/255.0) alpha:1.0] endingColor:[NSColor colorWithCalibratedRed:(200/255.0) green:(200/255.0) blue:(200/255.0) alpha:1.0]];
    [fillGradient drawInBezierPath:path angle:270.0];
    
    [NSGraphicsContext saveGraphicsState];
    
    NSBezierPath *clip = [NSBezierPath bezierPathWithRect:[self bounds]];
    [clip appendBezierPath:path];
    [clip addClip];
    
    [NSGraphicsContext restoreGraphicsState];
}
@end
