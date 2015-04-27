//
//  MasterViewController.h
//  A2-Read-JSON
//
//  Created by Steven Brice  on 2/22/15.
//  Copyright (c) 2015 Steven Brice. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property NSArray *clients; // Array of Clients to display in the table


@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) IBOutlet UITableView *tbl_clients;


@end

