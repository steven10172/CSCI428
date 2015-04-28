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
    
    WhiteBoard *board = [[WhiteBoard alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:board];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
