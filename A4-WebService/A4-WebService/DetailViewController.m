//
//  DetailViewController.m
//  A4-WebService
//
//  Created by mobile06 on 4/30/15.
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
        
        NSDictionary *details = newDetailItem;
        self.urlAddr = [details objectForKey:@"url"];
        self.name = [details objectForKey:@"name"];

        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    
    self.navigationItem.title = self.name;
    
    NSURL *url = [NSURL URLWithString:self.urlAddr];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
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
