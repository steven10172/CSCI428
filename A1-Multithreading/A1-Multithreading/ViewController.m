//
//  ViewController.m
//  A1-Multithreading
//
//  Created by Samantha Yonan on 2/1/15.
//  Copyright (c) 2015 Steven Brice. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.isRunning = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)stopSearch {
    // Set the current status of the search as not running
    self.isRunning = false;

    // Change the run button back to the default color and text
    [self.btn_runTest setTitle:@"Find Primes" forState:UIControlStateNormal];
    // Set the button background color to Red
    [self.btn_runTest setBackgroundColor:[UIColor colorWithRed:(51/255.0f) green:(102/255.0f) blue:(255/255.0f) alpha:1.0f]];
}

- (void)runSearch {
    // Set the current status of the search as running
    self.isRunning = true;

    // Change the run button to Stop and Red
    [self.btn_runTest setTitle:@"Stop" forState:UIControlStateNormal];
    [self.btn_runTest setBackgroundColor:[UIColor redColor]];
    
    // Set the Status label
    self.lbl_currentTestStatus.text = @"Finding Primes";

}

- (IBAction)findPrimes:(id)sender {
    // Check to see if a search is currently running
    if(self.isRunning) {
        // A test is running which this press is to cancel the search
        [self stopSearch];
    } else {
        [self runSearch];
    }
}

- (IBAction)clearResults:(id)sender {
    // Set the status label
    self.lbl_currentTestStatus.text = @"No Tests Run";
}

- (IBAction)sliderValueChanged:(id)sender {
    // Get an instance of the slider
    UISlider *slider = (UISlider *)sender;
    
    // Get the value of the current slider
    self.numThreads = (NSInteger)lround(slider.value);
    
    // Set the label to the current value
    self.lbl_numThreads.text = [NSString stringWithFormat:@"%ld",(long)self.numThreads];
}



#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2; // Return the number of Primes Found
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableView *cell = [tableView dequeueReusableCellWithIdentifier:@"resultsCell" forIndexPath:indexPath];
    
    // Create a pointer to the specific attraction in the AttractionCellRow
    Attraction *attraction = [self.attractionDataController attractionAtIndex:indexPath.row];
    
    cell.attractionNameLabel.text = attraction.name; // Set the name of the attraction in the cell
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO; // Don't allow the item to be editable
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


@end
