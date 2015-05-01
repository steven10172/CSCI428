//
//  MasterViewController.m
//  A4-WebService
//
//  Created by mobile06 on 4/30/15.
//  Copyright (c) 2015 Steven Brice. All rights reserved.
//

// Set the client URL
#define artistSearchURL @"http://ws.audioscrobbler.com/2.0/?method=artist.search&artist=%SEARCH_TERM%&api_key=9e740cfebf2019e84fbf957b3bd3528c&format=json"

#define albumSearchURL @"http://ws.audioscrobbler.com/2.0/?method=album.search&album=%SEARCH_TERM%&api_key=9e740cfebf2019e84fbf957b3bd3528c&format=json"


#define trackSearchURL @"http://ws.audioscrobbler.com/2.0/?method=track.search&track=%SEARCH_TERM%&api_key=9e740cfebf2019e84fbf957b3bd3528c&format=json"


#import "MasterViewController.h"
#import "DetailViewController.h"

@interface MasterViewController ()

@property NSMutableArray *objects;
@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self search];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)search {
    if(self.searchTerm && self.searchTerm.length) {
        // Clear the results
        self.apiResultsArray = [[NSArray alloc] init];
        
        [self searchArtists];
        [self searchAlbums];
        [self searchTrack];
    }
}

- (void)searchArtists {
    // Get Current Global Queue
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // Dispatch a thread to download the data
    dispatch_async(queue, ^{
        NSString *urlString = [artistSearchURL stringByReplacingOccurrencesOfString:@"%SEARCH_TERM%" withString:self.searchTerm];
        NSURL *url = [NSURL URLWithString:urlString];
        NSData* data = [NSData dataWithContentsOfURL:url];
        [self performSelectorOnMainThread:@selector(fetchedDataArtist:)
                               withObject:data waitUntilDone:YES];
    });

}

- (void)searchAlbums {
    // Get Current Global Queue
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // Dispatch a thread to download the data
    dispatch_async(queue, ^{
        NSString *urlString = [albumSearchURL stringByReplacingOccurrencesOfString:@"%SEARCH_TERM%" withString:self.searchTerm];
        NSURL *url = [NSURL URLWithString:urlString];
        NSData* data = [NSData dataWithContentsOfURL:url];
        [self performSelectorOnMainThread:@selector(fetchedDataAlbum:)
                               withObject:data waitUntilDone:YES];
    });
}


- (void)searchTrack {
    // Get Current Global Queue
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // Dispatch a thread to download the data
    dispatch_async(queue, ^{
        NSString *urlString = [trackSearchURL stringByReplacingOccurrencesOfString:@"%SEARCH_TERM%" withString:self.searchTerm];
        NSURL *url = [NSURL URLWithString:urlString];
        NSData* data = [NSData dataWithContentsOfURL:url];
        [self performSelectorOnMainThread:@selector(fetchedDataTrack:)
                               withObject:data waitUntilDone:YES];
    });
}

- (void)fetchedDataArtist:(NSData *)responseData {
    if(responseData != nil) {
        // Parse the JSON Data
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        
        // Set the clients from the json data
        NSString *numResults = [[json objectForKey:@"results"] objectForKey:@"opensearch:totalResults"];
        if([numResults isEqualToString:@"0"]) {
            [self.tableViewData removeAllObjects];
            [self.tableView reloadData];
            
            return;
        }
        NSArray *resultsArray = [[[json objectForKey:@"results"] objectForKey:@"artistmatches"] objectForKey:@"artist"];
        self.apiResultsArray = [self.apiResultsArray arrayByAddingObjectsFromArray:resultsArray];
        
        NSLog(@"%@", resultsArray[0][@"name"]);
        
        // Reload the Table data to show the downloaded client data
        [self.tableViewData removeAllObjects];
        self.tableViewData = [self.apiResultsArray mutableCopy]; // Reload all the data from the plist into the table
        [self sortResults];
        [self.tableView reloadData];
    } else {
        [self.tableViewData removeAllObjects];
        [self.tableView reloadData];
    }
}

- (void)fetchedDataAlbum:(NSData *)responseData {
    if(responseData != nil) {
        // Parse the JSON Data
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        
        // Set the clients from the json data
        NSString *numResults = [[json objectForKey:@"results"] objectForKey:@"opensearch:totalResults"];
        if([numResults isEqualToString:@"0"]) {
            [self.tableViewData removeAllObjects];
            [self.tableView reloadData];
            
            return;
        }
        NSArray *resultsArray = [[[json objectForKey:@"results"] objectForKey:@"albummatches"] objectForKey:@"album"];
        self.apiResultsArray = [self.apiResultsArray arrayByAddingObjectsFromArray:resultsArray];
        
        NSLog(@"%@", resultsArray[0][@"name"]);
        
        // Reload the Table data to show the downloaded client data
        [self.tableViewData removeAllObjects];
        self.tableViewData = [self.apiResultsArray mutableCopy]; // Reload all the data from the plist into the table
        [self sortResults];
        [self.tableView reloadData];
    } else {
        [self.tableViewData removeAllObjects];
        [self.tableView reloadData];
    }
}

- (void)fetchedDataTrack:(NSData *)responseData {
    if(responseData != nil) {
        // Parse the JSON Data
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        
        // Set the clients from the json data
        NSString *numResults = [[json objectForKey:@"results"] objectForKey:@"opensearch:totalResults"];
        if([numResults isEqualToString:@"0"]) {
            [self.tableViewData removeAllObjects];
            [self.tableView reloadData];
            
            return;
        }
        NSArray *resultsArray = [[[json objectForKey:@"results"] objectForKey:@"trackmatches"] objectForKey:@"track"];
        self.apiResultsArray = [self.apiResultsArray arrayByAddingObjectsFromArray:resultsArray];
        
        NSLog(@"%@", resultsArray[0][@"name"]);
        
        // Reload the Table data to show the downloaded client data
        [self.tableViewData removeAllObjects];
        self.tableViewData = [self.apiResultsArray mutableCopy]; // Reload all the data from the plist into the table
        [self sortResults];
        [self.tableView reloadData];
    } else {
        [self.tableViewData removeAllObjects];
        [self.tableView reloadData];
    }
}


- (void)sortResults {
    if([self.apiResultsArray count] > 0) {
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        self.apiResultsArray = [self.apiResultsArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
        self.tableViewData = [self.apiResultsArray mutableCopy];
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.tableViewData[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - Table View

// Only display 1 section in the UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Get the number of rows in a section in the UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableViewData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Custom Table Cell that is used to show the county information
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSDictionary *results = [self.tableViewData objectAtIndex:indexPath.row];
    //attractionsList = [tableViewData objectAtIndex:indexPath.row]; // Create a reference to the attraction data in the table data
    
    NSString *title;
    if([results objectForKey:@"artist"] != nil) {
        title = [NSString stringWithFormat:@"%@ - %@", [results objectForKey:@"name"], [results objectForKey:@"artist"]];
    } else {
        title = [NSString stringWithFormat:@"%@", [results objectForKey:@"name"]];
    }

    cell.textLabel.text = title;
    
    return cell;
}

#pragma mark - SearchBar Delegate Methods
// Monitor when the text changes in the searchbar
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.searchTerm = [searchText stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    [self search];
}

#pragma mark - ScrollView delegate methods

// Allow the user to scroll the table view without the keyboard being in the way
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder]; // Remove focus from the search bar and remove the kayboard
    
    // Re-enable the cancel button on the search bar
    [self enableCancelButton:self.searchBar];
}

// Keep the cancel button enabled when there is a search term
-(void)enableCancelButton:(UISearchBar *)aSearchBar {
    if(self.searchBar.text.length) { // Check to see if the search bar is empty
        
        // Look though all the subview on the search bar and enable the buttons
        for(id subview in aSearchBar.subviews) {
            if([subview isKindOfClass:[UIControl class]]) { // Check to see if subview is a UIControl button
                [subview setEnabled:YES]; // Enable the button
            }
            [self enableCancelButton:subview];
        }
    }
}

@end
