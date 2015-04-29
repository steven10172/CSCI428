//
//  ViewController.m
//  Whiteboard
//
//  Created by Steven Brice  on 4/27/15.
//  Copyright (c) 2015 Steven Brice. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create a new instance of the WhiteBoard with the bounces of the current view
    self.board = [[WhiteBoard alloc] initWithFrame:self.view.bounds];
    
    // Add the WhiteBoard as a subview of the current view
    [self.view addSubview:self.board];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome"
                                                    message:@"Touch anywhere to draw"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
