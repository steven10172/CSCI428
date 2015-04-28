//
//  WhiteBoard.m
//  Whiteboard
//
//  Created by Steven Brice  on 4/27/15.
//  Copyright (c) 2015 Steven Brice. All rights reserved.
//

#import "WhiteBoard.h"

@interface WhiteBoard ()

@end

@implementation WhiteBoard

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hue = 0.0;
        [self initContext:frame];
        [self setBackgroundColor:[UIColor redColor]];
        UIColor* bgColor = [self backgroundColor];
        if([bgColor isEqual:[UIColor redColor]]) {
            return self;
        }
    }
    return self;
}

- (BOOL) initContext:(CGRect)frame {
    
    CGSize size = frame.size;
    int bitmapByteCount;
    int	bitmapBytesPerRow;
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow = (size.width * 4);
    bitmapByteCount = (bitmapBytesPerRow * size.height);
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    self.cacheBitmap = malloc( bitmapByteCount );
    if (self.cacheBitmap == NULL){
        return NO;
    }
    self.cacheContext = CGBitmapContextCreate (self.cacheBitmap, size.width, size.height, 8, bitmapBytesPerRow, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaNoneSkipFirst);
    
    
    // Start Drawing out as White
    CGContextSetRGBFillColor(self.cacheContext, 1.0,1.0,1.0,1.0);
    CGContextFillRect(self.cacheContext, frame);
    CGContextSaveGState(self.cacheContext);
    
    return YES;
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    [self drawToCache:touch];
}

- (void) drawToCache:(UITouch*)touch {
    self.hue += 0.005;
    if(self.hue > 1.0) self.hue = 0.0;
    UIColor *color = [UIColor colorWithHue:self.hue saturation:0.7 brightness:1.0 alpha:1.0];
    
    CGContextSetStrokeColorWithColor(self.cacheContext, [color CGColor]);
    CGContextSetLineCap(self.cacheContext, kCGLineCapRound);
    CGContextSetLineWidth(self.cacheContext, 15);
    
    CGPoint lastPoint = [touch previousLocationInView:self];
    CGPoint newPoint = [touch locationInView:self];
    
    CGContextMoveToPoint(self.cacheContext, lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(self.cacheContext, newPoint.x, newPoint.y);
    CGContextStrokePath(self.cacheContext);
    CGRect dirtyPoint1 = CGRectMake(lastPoint.x-10, lastPoint.y-10, 20, 20);
    CGRect dirtyPoint2 = CGRectMake(newPoint.x-10, newPoint.y-10, 20, 20);
    [self setNeedsDisplayInRect:CGRectUnion(dirtyPoint1, dirtyPoint2)];
}

- (void) drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGImageRef cacheImage = CGBitmapContextCreateImage(self.cacheContext);
    CGContextDrawImage(context, self.bounds, cacheImage);
    CGImageRelease(cacheImage);
}



@end