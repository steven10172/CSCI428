//
//  DetailViewController.m
//  A2-Read-JSON
//
//  Created by Steven Brice  on 2/22/15.
//  Copyright (c) 2015 Steven Brice. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController


#pragma mark - Managing the detail item

- (void)setURL:(NSString*)url {
    self.url = url;
    
    // Get the full image by removing the s at the end
    self.url = [self.url stringByReplacingOccurrencesOfString:@"s.jpg" withString:@".jpg"];
    
    // Update the view.
    [self configureView];
}

- (void)configureView {
    // Change the image on the screen
    self.image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.url]]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
