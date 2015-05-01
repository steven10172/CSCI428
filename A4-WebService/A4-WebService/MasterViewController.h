//
//  MasterViewController.h
//  A4-WebService
//
//  Created by mobile06 on 4/30/15.
//  Copyright (c) 2015 Steven Brice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterViewController : UITableViewController
<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIAlertViewDelegate>

//@property (nonatomic, strong) NSMutableArray *searchDict;
@property (nonatomic, strong) NSMutableArray *tableViewData; // Data the table views
@property (nonatomic, retain) NSArray *apiResultsArray; // Data from the API
@property (nonatomic, retain) NSString *searchTerm;

@property (nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) IBOutlet UISearchBar *searchBar;

@end

