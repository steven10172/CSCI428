//
//  DataViewController.h
//  A1-Multithreading
//
//  Created by Samantha Yonan on 1/29/15.
//  Copyright (c) 2015 Steven Brice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *dataLabel;
@property (strong, nonatomic) id dataObject;

@end

