//
//  DetailViewController.h
//  A2-Read-JSON
//
//  Created by Steven Brice  on 2/22/15.
//  Copyright (c) 2015 Steven Brice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) NSString *url; // URL of the image
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end

