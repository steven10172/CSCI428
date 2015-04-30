//
//  DrawingEvent.swift
//  Whiteboard
//
//  Created by Steven Brice  on 4/29/15.
//  Copyright (c) 2015 Steven Brice. All rights reserved.
//

import Foundation
import UIKit

// Drawing Class used for sending events to the Node.js Server
class DrawingEvent {
    var size: Int
    var color: String
    var type: String
    var start: CGPoint
    var end: CGPoint
    var drawingMultiplierX: Double
    var drawingMultiplierY: Double
    
    init(size: Int, color: String, type: String, start: CGPoint, end: CGPoint, drawingMultiplierX: Double, drawingMultiplierY: Double) {
        self.size = size;
        self.color = color;
        self.type = type;
        self.start = start;
        self.end = end;
        self.drawingMultiplierX = drawingMultiplierX
        self.drawingMultiplierY = drawingMultiplierY
    }
    
    func getDictionary() -> NSDictionary {
        // Get the corrected X and Y coordinate (Account for different screen sizes)
        let startX = Double(start.x) / drawingMultiplierX
        let startY = Double(start.y) / drawingMultiplierY

        // Get the corrected X and Y coordinate (Account for different screen sizes)
        let endX = Double(end.x) / drawingMultiplierX
        let endY = Double(end.y) / drawingMultiplierY
        
        // Create a NSDictionary of the data to be sent off to the server
        var dict: NSDictionary = ["size": self.size, "color": self.color, "type": self.type, "start": ["x": startX, "y": startY], "end": ["x": endX, "y": endY]];
        
        return dict;
    }
}
