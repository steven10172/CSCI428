//
//  MasterViewController.h
//  A3-Read-XML
//
//  Created by Steven Brice  on 4/27/15.
//  Copyright (c) 2015 Steven Brice. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController <NSXMLParserDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;

@property NSMutableArray *clients; // Array of Clients to display in the table
@property NSMutableArray *current_client; // Array of Current Client data
@property NSMutableDictionary *current_client_data; // Dict of Current Client data

@property (strong, nonatomic) IBOutlet UITableView *tbl_clients;

@end

