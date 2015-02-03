//
//  ViewController.h
//  A1-Multithreading
//
//  Created by Samantha Yonan on 2/1/15.
//  Copyright (c) 2015 Steven Brice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tbl_results; // Create reference to result table
@property (weak, nonatomic) IBOutlet UISlider *slider_numThreads; // Create reference to slider of number of threads
@property (weak, nonatomic) IBOutlet UISlider *slider_maxInt; // Create reference to slider of Max Int to check


@property NSInteger largestNumberToCheck; // Largest Number to check if it's prime
@property NSInteger numThreads; // Number of threads the user has picked
@property NSInteger threadsDone; // Number of threads that the Slider specifies
@property BOOL isRunning; // Tells if the prime check is currently running
@property NSMutableDictionary *primesFound; // List of Prime numbers and the thread that found it
@property NSArray *primeNumbers; // Array of Prime numbers to display in the table


// Reference to all the labels on the page
@property (weak, nonatomic) IBOutlet UILabel *lbl_numThreads;
@property (weak, nonatomic) IBOutlet UILabel *lbl_currentTestStatus;
@property (weak, nonatomic) IBOutlet UILabel *lbl_runTime;
@property (weak, nonatomic) IBOutlet UILabel *lbl_maxInt;
@property (weak, nonatomic) IBOutlet UILabel *lbl_currentTime;

// Reference to the Run and Stop button on the bottom of the page
@property (weak, nonatomic) IBOutlet UIButton *btn_runTest;

// Reference to the clear results button
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btn_clear;


// Custom Methods
- (void)showTime; // Puts the current time into the appropriate field every second
- (void)stopSearch; // Stop the current search
- (void)runSearch; // Start a new prime search
- (void)reloadTable; // Reload the table with the new data
- (BOOL)isPrime:(long)number; // Check to see if the number is prime


- (IBAction)findPrimes:(id)sender;
- (IBAction)clearResults:(id)sender;
- (IBAction)threadSliderValueChanged:(id)sender;
- (IBAction)maxIntSliderValueChanged:(id)sender;

@end

