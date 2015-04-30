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
    
    // Current color used by this app when drawing
    var hue: CGFloat
    
    // Memory pointer to a cached bitmap
    var cacheBitmap: UnsafeMutablePointer<Void>?
    
    // Cache Context Reference
    var cacheContext: CGContextRef?
    
    // Socket.io connection to the whiteboard server
    let socket = SocketIOClient(socketURL: "http://whiteboard.thecontrollershop.com:80")
    
    // Drawing Offset Multipliers to durrect for different screen sizes
    var drawingMultiplierX: Double = 1.0
    var drawingMultiplierY: Double = 1.0
    
    
    required init(coder aDecoder: NSCoder) {
        self.hue = 0.0;
        
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        self.hue = 0.0;
        
        // calculate the drawing multiplier
        self.drawingMultiplierX = Double(frame.size.width) / 1920.0; // 1920 is width of web canvas
        self.drawingMultiplierY = Double(frame.size.height) / 1080.0; // 1080 is height of web canvas
        
        // Create a UIView with the size of the parent view
        super.init(frame: frame);
        
        // Initialize the Cache Context of the bitmap
        self.initContext(frame);
        
        // Set the background color of the view to be White
        self.backgroundColor = UIColor.whiteColor();
        

        // Add the buttons to the view
        self.addButtons()
        
        // Add the Socket.io event handlers
        self.addHandlers()
        
        // Connect to the Socket.io server
        self.socket.connect()
    }
    
    // Add buttons to the view
    func addButtons() {
        // Add a Save Button to the bottom right corner of the screen
        let saveButtonFrame = CGRectMake(frame.size.width - 50, frame.size.height - 30, 40, 25);
        let saveButton = UIButton();
        saveButton.frame = saveButtonFrame;
        saveButton.setTitle("Save", forState: .Normal);
        saveButton.setTitleColor(UIColor.blueColor(), forState: .Normal);
        saveButton.addTarget(self, action: "downloadImage", forControlEvents: .TouchUpInside);
        
        // Add the saveButton to the view
        self.addSubview(saveButton);

        // Add a Clear Button to the bottom right corner of the screen
        let clearButtonFrame = CGRectMake(10, frame.size.height - 30, 45, 25);
        let clearButton = UIButton();
        clearButton.frame = clearButtonFrame;
        clearButton.setTitle("Clear", forState: .Normal);
        clearButton.setTitleColor(UIColor.blueColor(), forState: .Normal);
        clearButton.addTarget(self, action: "clearScreen", forControlEvents: .TouchUpInside);
        
        // Add the clearButton to the view
        self.addSubview(clearButton);

    
        // Add a New Color Button to the bottom middle of the screen
        let newColorButtonFrame = CGRectMake(frame.size.width/2 - 50, frame.size.height - 30, 85, 25);
        let newColorButton = UIButton();
        newColorButton.frame = newColorButtonFrame;
        newColorButton.setTitle("New Color", forState: .Normal);
        newColorButton.setTitleColor(UIColor.blueColor(), forState: .Normal);
        newColorButton.addTarget(self, action: "newColor", forControlEvents: .TouchUpInside);
        
        // Add the clearButton to the view
        self.addSubview(newColorButton);
}
    
    
    // Initialize the cached bitmap and context (speed up rendering)
    func initContext(frame: CGRect)-> Bool {
        let size = frame.size; // Get the size of the UIView
        var bitmapByteCount: Int!
        var bitmapBytesPerRow: Int!
        
        // Calculate the number of bytes per row. 4 bytes per pixel: red, green, blue, alpha
        bitmapBytesPerRow = Int(size.width * 4);
        
        // Total Bytes in the bitmap
        bitmapByteCount = Int(CGFloat(bitmapBytesPerRow) * size.height);
        
        // Allocate memory for image data. This is the destination in memory where any
        // drawing to the bitmap context will be rendered
        self.cacheBitmap = malloc(bitmapByteCount);
        
        
        // Create the Cache Context from the Bitmap
        self.cacheContext = CGBitmapContextCreate(self.cacheBitmap!, Int(size.width), Int(size.height), 8, bitmapBytesPerRow, CGColorSpaceCreateDeviceRGB(), CGBitmapInfo(CGImageAlphaInfo.NoneSkipFirst.rawValue));
        
        // Clear the screen
        self.clearScreen()
        
        return true;
    }
    
    // Clear the Drawing Area
    func clearScreen() {
        // Set the background as white
        CGContextSetRGBFillColor(self.cacheContext, 1.0, 1.0, 1.0, 1.0);
        CGContextFillRect(self.cacheContext, frame);
        CGContextSaveGState(self.cacheContext);
        
        // Update the entire view
        self.setNeedsDisplay();
    }
    
    // Randomly pick a new color
    func newColor() {
        // Increase the Hue
        self.hue += CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        
        // Make sure the Hue isn't greater than 1
        self.hue = self.hue % 1;
    }

    
    // Set Handlers for the Socket.io Events
    func addHandlers() {
        
        // Listen for the 'd' event (DrawingEvent)
        self.socket.on("d") {[weak self] data, ack in
            if let drawData = data?[0] as? NSDictionary { // Check if the data is a NSDictionary

                // Get the Start Drawing point corrected for the screen size
                let startX: Double = (drawData["start"]?["x"] as! Double) * self!.drawingMultiplierX;
                let startY: Double = (drawData["start"]?["y"] as! Double) * self!.drawingMultiplierY;
                
                // Get the End Drawing point corrected for the screen size
                let endX: Double = (drawData["end"]?["x"] as! Double) * self!.drawingMultiplierX;
                let endY: Double = (drawData["end"]?["y"] as! Double) * self!.drawingMultiplierY;

                // Create the CGPoints to pass around
                let startPoint = CGPoint(x: startX, y: startY)
                let endPoint = CGPoint(x: endX, y: endY)
                
                // Get the Drawing Color from the passed Hex value
                let drawingColor = UIColor(rgba: drawData["color"] as! String);
                
                // Draw the Line
                self?.drawLine(startPoint, endPoint: endPoint, type: drawData["type"] as! String, size: drawData["size"] as! Int, color: drawingColor);
            }
        }
        
        // Debug: All data coming from socket
        //self.socket.onAny {println("Got event: \($0.event), with items: \($0.items)")}
    }
    
    // Draw the line to the screen
    func drawLine(startPoint: CGPoint, endPoint: CGPoint, type: String, size: Int, color: UIColor) {
        // Set the line size, type, and color
        CGContextSetStrokeColorWithColor(self.cacheContext, color.CGColor);
        CGContextSetLineCap(self.cacheContext, kCGLineCapRound);
        CGContextSetLineWidth(self.cacheContext, CGFloat(size));
        
        // Draw the line
        CGContextMoveToPoint(self.cacheContext, startPoint.x, startPoint.y);
        CGContextAddLineToPoint(self.cacheContext, endPoint.x, endPoint.y);
        CGContextStrokePath(self.cacheContext);
        
        // Calculate the dirty pixels that needs to be updated
        // HAVING ISSUES AFTER CONVERSION TO SWIFT FROM OBJ-C
        //let dirtyPoint1 = CGRectMake(startPoint.x-10, startPoint.y-10, 20, 20);
        //let dirtyPoint2 = CGRectMake(endPoint.x-10, endPoint.y-10, 20, 20);
        
        // Only update the dirty pixels to improve performance
        //self.setNeedsDisplayInRect(dirtyPoint1);
        //self.setNeedsDisplayInRect(dirtyPoint2);

        // Update the entire view
        self.setNeedsDisplay();
    }

    
    // Fired everytime a touch event is dragged
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        // Get the touch point (First Only if there are multiple)
        let touch = touches.first as? UITouch;
        
        // Get the current and last touch point
        let startPoint = touch!.previousLocationInView(self) as CGPoint;
        let endPoint = touch!.locationInView(self) as CGPoint;
        
        // Create a color object of the line color
        let color = UIColor(hue: CGFloat(self.hue), saturation: CGFloat(0.7), brightness: CGFloat(1.0), alpha: CGFloat(1.0));

        // Create a drawing Event
        var dEvent = DrawingEvent(size: 5, color: color.htmlRGBColor, type: "line", start: startPoint, end: endPoint, drawingMultiplierX: drawingMultiplierX, drawingMultiplierY: drawingMultiplierY);
        
        // Get the Drawing Event JSON Data
        let jData = JSONStringify(dEvent.getDictionary()) as String;
        
        
        // Send the Drawing Event to the server
        self.socket.emit("d", dEvent.getDictionary());
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
    
    // UIImageWriteToSavedPhotosAlbum has completed
    func image(image: UIImage, didFinishSavingWithError error: NSError, contextInfo: UnsafeMutablePointer<Void>) {
        if(error == 0) {
            UIAlertView(title: "Error", message: "Error Saving Photo", delegate: nil, cancelButtonTitle: "Ok").show();
        } else {
            UIAlertView(title: "Complete", message: "Image Saved", delegate: nil, cancelButtonTitle: "Ok").show();
        }
    }
    
    // Turn the Object to a JSON String
    func JSONStringify(value: AnyObject, prettyPrinted: Bool = false) -> String {
        var options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : nil
        if NSJSONSerialization.isValidJSONObject(value) {
            if let data = NSJSONSerialization.dataWithJSONObject(value, options: options, error: nil) {
                if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    return string as String
                }
            }
        }
        return ""
    }
    
}