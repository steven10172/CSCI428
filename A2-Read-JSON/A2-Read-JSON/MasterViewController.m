//
//  MasterViewController.m
//  A2-Read-JSON
//
//  Created by Steven Brice  on 2/22/15.
//  Copyright (c) 2015 Steven Brice. All rights reserved.
//

// Set the client URL
#define clientListURL [NSURL URLWithString:@"http://www.seasite.niu.edu/cs680Android/JSON/Client_list_json.txt"]

#import "MasterViewController.h"
#import "DetailViewController.h"

@interface MasterViewController ()

@property NSMutableArray *objects;
@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    // Get Current Global Queue
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // Dispatch a thread to download the data
    dispatch_async(queue, ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        clientListURL];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        // Get the client that was clicked
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *client = self.clients[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        
        // Send the client data to the detailview
        [controller setDetailItem:client];

        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.clients count]; // Return the number of clients in the array
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Get the client
    NSDictionary* client = [self.clients objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Client" forIndexPath:indexPath];
    
    // Put the client Name and Profession into the table
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [client objectForKey:@"name"]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [client objectForKey:@"profession"]];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


- (void)fetchedData:(NSData *)responseData {
    // Parse the JSON Data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    // Set the clients from the json data
    self.clients = [json objectForKey:@"clients"];
    
    // Reload the Table data to show the downloaded client data
    [self.tbl_clients reloadData];
}

@end
