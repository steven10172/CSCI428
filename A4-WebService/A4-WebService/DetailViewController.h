//
//  DetailViewController.h
//  A4-WebService
//
//  Created by mobile06 on 4/30/15.
//  Copyright (c) 2015 Steven Brice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property NSString *urlAddr;
@property NSString *name;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

