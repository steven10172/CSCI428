//
//  DetailViewController.h
//  A2-Read-JSON
//
//  Created by Steven Brice  on 2/22/15.
//  Copyright (c) 2015 Steven Brice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem; // Passed object of Client Data
@property (strong, nonatomic) NSDictionary* client; // Client Data

@property (weak, nonatomic) IBOutlet UINavigationItem *detailTitle;
@property (weak, nonatomic) IBOutlet UILabel *profession;
@property (weak, nonatomic) IBOutlet UILabel *dob;
@property (weak, nonatomic) IBOutlet UITextView *children;

@end

