//
//  WhiteBoard.h
//  Whiteboard
//
//  Created by Steven Brice  on 4/27/15.
//  Copyright (c) 2015 Steven Brice. All rights reserved.
//

#ifndef Whiteboard_WhiteBoard_h
#define Whiteboard_WhiteBoard_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface WhiteBoard : UIView

@property double hue;
@property UITouch* touch;
@property void* cacheBitmap;
@property CGContextRef cacheContext;

@end

#endif
