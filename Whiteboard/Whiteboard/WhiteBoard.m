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
    // Create a UIView with the size of the parent View
    self = [super initWithFrame:frame];

    if (self) {
        // Set the default value of the hue
        self.hue = 0.0;
        
        // Initialize the Cache Context for the bitmap
        [self initContext:frame];
        
        // Set the background color of the view
        [self setBackgroundColor:[UIColor whiteColor]];
        
        CGRect buttonFrame = CGRectMake(frame.size.width - 50, frame.size.height - 30, 40, 25);
        UIButton *button = [[UIButton alloc] initWithFrame: buttonFrame];
        [button setTitle: @"Save" forState: UIControlStateNormal];
        [button addTarget:self action:@selector(downloadImage) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor: [UIColor blueColor] forState: UIControlStateNormal];
        [self addSubview:button];
    }
    return self;
}

- (BOOL) initContext:(CGRect)frame {
    CGSize size = frame.size; // Get size of the UIView
    int bitmapByteCount;
    int	bitmapBytesPerRow;
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; red, green, blue, and alpha.
    bitmapBytesPerRow = (size.width * 4);
    
    // Total bytes in the bitmap
    bitmapByteCount = (bitmapBytesPerRow * size.height);
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    self.cacheBitmap = malloc( bitmapByteCount );
    
    // If memory isn't allocated return NO
    if (self.cacheBitmap == NULL){
        return NO;
    }
    
    // Create the Cache Context from the Bitmap
    self.cacheContext = CGBitmapContextCreate (self.cacheBitmap, size.width, size.height, 8, bitmapBytesPerRow, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaNoneSkipFirst);
    
    
    // Start Drawing out as White
    CGContextSetRGBFillColor(self.cacheContext, 1.0,1.0,1.0,1.0);
    CGContextFillRect(self.cacheContext, frame);
    CGContextSaveGState(self.cacheContext);
    
    return YES;
}

// Called every time a touch event is dragged
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    // Draw the new touch point
    [self drawToCache:touch];
}

// Draw the new touch event to the cached Bitmap
- (void) drawToCache:(UITouch*)touch {
    self.hue += 0.005;
    if(self.hue > 1.0) self.hue = 0.0;
    
    // Get a Color Object of the line
    UIColor *color = [UIColor colorWithHue:self.hue saturation:0.7 brightness:1.0 alpha:1.0];
    
    // Set the line size, type, and color
    CGContextSetStrokeColorWithColor(self.cacheContext, [color CGColor]);
    CGContextSetLineCap(self.cacheContext, kCGLineCapRound);
    CGContextSetLineWidth(self.cacheContext, 15);
    
    // Get the current and last touch point
    CGPoint lastPoint = [touch previousLocationInView:self];
    CGPoint newPoint = [touch locationInView:self];
    
    // Draw the new line
    CGContextMoveToPoint(self.cacheContext, lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(self.cacheContext, newPoint.x, newPoint.y);
    CGContextStrokePath(self.cacheContext);
    
    // Calculate the dirty pixels that needs to be updated
    CGRect dirtyPoint1 = CGRectMake(lastPoint.x-10, lastPoint.y-10, 20, 20);
    CGRect dirtyPoint2 = CGRectMake(newPoint.x-10, newPoint.y-10, 20, 20);
    
    // Only update the dirty pixels to improve performance
    [self setNeedsDisplayInRect:CGRectUnion(dirtyPoint1, dirtyPoint2)];
}


// Draw the cachedBitmap to the UIView
- (void) drawRect:(CGRect)rect {
    // Get the current Graphics Context
    //UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Get the Image to draw
    CGImageRef cacheImage = CGBitmapContextCreateImage(self.cacheContext);
    
    // Draw the ImageContext to the screen
    CGContextDrawImage(context, self.bounds, cacheImage);
    
    //UIGraphicsEndImageContext();
    
    // Release the cacheImage context
    CGImageRelease(cacheImage);
}


-(void)downloadImage {
    UIImage *image = [UIImage imageWithCGImage:CGBitmapContextCreateImage(self.cacheContext)];

    NSLog(@" %@", image);
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

-(void)image:(UIImage*)image didFinishSavingWithError:(NSError *)error contextInfo:(void*)contextInfo {
    if([error localizedDescription] != NULL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Error Saving Photo"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}



@end