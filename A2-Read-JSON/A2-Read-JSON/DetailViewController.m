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

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Set the client to the passed item
        self.client = _detailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.client) {
        
        // Set the labels about the client
        self.detailTitle.title = [NSString stringWithFormat:@"%@", [self.client objectForKey:@"name"]];
        self.profession.text = [NSString stringWithFormat:@"%@", [self.client objectForKey:@"profession"]];
        self.dob.text = [NSString stringWithFormat:@"%@", [self.client objectForKey:@"dob"]];

        NSArray* childrenNames = [self.client objectForKey:@"children"];
        
        // Check if there are no children
        if([childrenNames count] == 0) {
            self.children.text = @"None";
        } else {
            // The client has children
            self.children.text = [childrenNames componentsJoinedByString:@", "];
        }
        
    }
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
