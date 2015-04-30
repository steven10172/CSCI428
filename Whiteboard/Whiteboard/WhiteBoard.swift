//
//  WhiteBoard.swift
//  Whiteboard
//
//  Created by Steven Brice  on 4/28/15.
//  Copyright (c) 2015 Steven Brice. All rights reserved.
//

import Foundation
import UIKit


class WhiteBoard: UIView {
    
    var hue: CGFloat
    var cacheBitmap: UnsafeMutablePointer<Void>?
    var cacheContext: CGContextRef?
    let socket = SocketIOClient(socketURL: "whiteboard.thecontrollershop.com:5000")
    

    override init(frame: CGRect) {
        self.hue = 0.0;
        
        // Create a UIView with the size of the parent view
        super.init(frame: frame);
        
        // Initialize the Cache Context of the bitmap
        self.initContext(frame);
        
        // Set the background color of the view to be White
        self.backgroundColor = UIColor.whiteColor();
        
        // Add a Save Button to the bottom right corner of the screen
        let buttonFrame = CGRectMake(frame.size.width - 50, frame.size.height - 30, 40, 25);
        let button = UIButton();
        button.frame = buttonFrame;
        button.setTitle("Save", forState: .Normal);
        button.setTitleColor(UIColor.blueColor(), forState: .Normal);
        button.addTarget(self, action: "downloadImage", forControlEvents: .TouchUpInside);
        
        // Add the button to the view
        self.addSubview(button);
        
        self.addHandlers()
        self.socket.connect()
    }
    
    func addHandlers() {
        self.socket.on("d") {[weak self] data, ack in
            if(let jData = data?[0] as? String) {
                let drawData = NSJSONSerialization.JSONObjectWithData(jData, options: nil, error: &error) as NSDictionary
                NSLog("%@", drawData);
                //self?.drawLine(name, coord: (x, y));
            }
        }
        
        self.socket.onAny {println("Got event: \($0.event), with items: \($0.items)")}
    }

    required init(coder aDecoder: NSCoder) {
        self.hue = 0.0;
        
        super.init(coder: aDecoder)
    }
    
    func initContext(frame: CGRect)-> Bool {
        let size = frame.size; // Get the size of the UIView
        var bitmapByteCount: UInt!
        var bitmapBytesPerRow: UInt!
        
        // Calculate the number of bytes per row. 4 bytes per pixel: red, green, blue, alpha
        bitmapBytesPerRow = UInt(size.width * 4);
        
        // Total Bytes in the bitmap
        bitmapByteCount = UInt(CGFloat(bitmapBytesPerRow) * size.height);
        
        // Allocate memory for image data. This is the destination in memory where any
        // drawing to the bitmap context will be rendered
        self.cacheBitmap = malloc(bitmapByteCount);
        
        
        // Create the Cache Context from the Bitmap
        self.cacheContext = CGBitmapContextCreate(self.cacheBitmap!, UInt(size.width), UInt(size.height), 8, bitmapBytesPerRow, CGColorSpaceCreateDeviceRGB(), CGBitmapInfo(CGImageAlphaInfo.NoneSkipFirst.rawValue));
        
        // Set the background as white
        CGContextSetRGBFillColor(self.cacheContext, 1.0, 1.0, 1.0, 1.0);
        CGContextFillRect(self.cacheContext, frame);
        CGContextSaveGState(self.cacheContext);
        
        return true;
    }
    
    // Fired everytime a touch event is dragged
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch;
        
        //self.socket.emit("d", nil);
        
        self.drawToCache(touch);
    }
    
    // Draw the new touch event to the cached Bitmap
    func drawToCache(touch: UITouch) {
        self.hue += 0.005;
        if(self.hue > 1.0) {
            self.hue = 0.0;
        }
        
        // Create a color object of the line color
        let color = UIColor(hue: CGFloat(self.hue), saturation: CGFloat(0.7), brightness: CGFloat(1.0), alpha: CGFloat(1.0));
        
        // Set the line size, type, and color
        CGContextSetStrokeColorWithColor(self.cacheContext, color.CGColor);
        CGContextSetLineCap(self.cacheContext, kCGLineCapRound);
        CGContextSetLineWidth(self.cacheContext, CGFloat(15));
        
        // Get the current and last touch point
        let lastPoint = touch.previousLocationInView(self) as CGPoint;
        let newPoint = touch.locationInView(self) as CGPoint;
        
        // Draw the line
        CGContextMoveToPoint(self.cacheContext, lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(self.cacheContext, newPoint.x, newPoint.y);
        CGContextStrokePath(self.cacheContext);
        
        // Calculate the dirty pixels that needs to be updated
        let dirtyPoint1 = CGRectMake(lastPoint.x-10, lastPoint.y-10, 20, 20);
        let dirtyPoint2 = CGRectMake(newPoint.x-10, newPoint.y-10, 20, 20);
        
        self.setNeedsDisplay();
        
        // Only update the dirty pixels to improve performance
        //self.setNeedsDisplayInRect(dirtyPoint1);
        //self.setNeedsDisplayInRect(dirtyPoint2);
    }
    
    // Draw the cachedBitmap to the UIView
    override func drawRect(rect: CGRect) {
        // Get the current Graphics Context
        let context = UIGraphicsGetCurrentContext();
        
        // Get the Image to draw
        let cacheImage = CGBitmapContextCreateImage(self.cacheContext);
        
        // Draw the ImageContext to the screen
        CGContextDrawImage(context, self.bounds, cacheImage);
    }
    
    // Download the image to the camera roll
    func downloadImage() {
        // Get the Image from the CGContext
        let image = UIImage(CGImage: CGBitmapContextCreateImage(self.cacheContext), scale: 1.0, orientation: UIImageOrientation.DownMirrored);
        
        // Save the Image to their Camera Roll
        UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil);
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError, contextInfo: UnsafeMutablePointer<Void>) {
        if(error == 0) {
            UIAlertView(title: "Error", message: "Error Saving Photo", delegate: nil, cancelButtonTitle: "Ok").show();
        } else {
            UIAlertView(title: "Complete", message: "Image Saved", delegate: nil, cancelButtonTitle: "Ok").show();
        }
    }
    
}