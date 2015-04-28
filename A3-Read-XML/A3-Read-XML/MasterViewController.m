//
//  MasterViewController.m
//  A3-Read-XML
//
//  Created by Steven Brice  on 4/27/15.
//  Copyright (c) 2015 Steven Brice. All rights reserved.
//

// Set the client URL
#define clientListURL [NSURL URLWithString:@"http://www.seasite.niu.edu/cs680Android/XML/Client_list_xml.txt"]

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
    
    // Init the array
    self.clients = [[NSMutableArray alloc] init];
    
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
    // Create an XML parser with the server data
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:responseData];
    
    // Set the delegate to be this Class
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities: YES];
    
    // Parse the data
    BOOL result = [parser parse];
    if(!result) {
        // There was an error parsing the XML. Alert the user
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Cannot Parse XML Data"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    // Reload the Table data to show the downloaded client data
    [self.tbl_clients reloadData];
}

#pragma mark - XML Delegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    // Check if the element is the person
    if([elementName isEqual:@"person"]) {
        //NSMutableArray* current_client = [[NSMutableArray alloc] init];
        NSMutableDictionary* client_data = [[NSMutableDictionary alloc] initWithDictionary:attributeDict];
        [client_data setObject:[[NSMutableArray alloc] init] forKey:@"children"];
        //[current_client addObject:client_data];

        // Add the client data to the array
        [self.clients addObject:client_data];
        
    // Check if the element is a child of a person
    } else if([elementName isEqual:@"child"]) {
        // Get the client _data
        NSMutableDictionary* client_data = [self.clients objectAtIndex:[self.clients count] - 1];
        
        // Get the Children Array
        NSMutableArray* children = [client_data objectForKey:@"children"];
        
        // Add the name to the array
        [children addObject:[NSString stringWithFormat:@"%@", [attributeDict objectForKey:@"name"]]];
    }
}

@end

