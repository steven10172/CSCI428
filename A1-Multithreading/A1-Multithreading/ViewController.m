//
//  ViewController.m
//  A1-Multithreading
//
//  Created by Samantha Yonan on 2/1/15.
//  Copyright (c) 2015 Steven Brice. All rights reserved.
//

#import "ViewController.h"
#import "ResultsViewCell.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isRunning = false;
    
    // Init to current value of the slider
    self.numThreads = [self.slider_numThreads value];
    
    // Init to current value of the slider
    self.largestNumberToCheck = [self.slider_maxInt value];
    
    // Init the Dict of results
    self.primesFound = [[NSMutableDictionary alloc] init];
    
    // Display the table with the data
    [self reloadTable];
    
    [self showTime];
}

- (void)showTime {
    // Get Current Global Queue
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // Get Current UI Queue
    dispatch_queue_t main_queue = dispatch_get_main_queue();
    
    // Dispatch a thread to keep updating the time
    dispatch_async(queue, ^{
        // Wait for all threads to finish
        while (true) {
            [NSThread sleepForTimeInterval:1.0];
            dispatch_async(main_queue, ^{
                // Update UI with time
                NSDate *currentTime = [NSDate date];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"hh:mm:ss a"];
                
                NSString *stringFromDate = [formatter stringFromDate:currentTime];
                
                // Display Time elapsed
                self.lbl_currentTime.text = stringFromDate;
            });
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadTable {
    // Build an array of the prime numbers
    self.primeNumbers = [self.primesFound allKeys];
    
    
    // Determine if there were prime numbers found
    if([self.primeNumbers count] > 0) {
        // Display the table and enable clear button
        self.tbl_results.hidden = NO;
        self.btn_clear.enabled = YES;
    } else {
        // Hide the table and disable clear button
        self.tbl_results.hidden = YES;
        self.btn_clear.enabled = NO;
    }
    
    // Reload the table data
    [self.tbl_results reloadData];
}

- (void)stopSearch {
    // Set the current status of the search as not running
    self.isRunning = false;

    // Change the run button back to the default color and text
    [self.btn_runTest setTitle:@"Find Primes" forState:UIControlStateNormal];
    
    // Set the button background color to Blue (Hex: 0x3366FF)
    [self.btn_runTest setBackgroundColor:[UIColor colorWithRed:(51/255.0f) green:(102/255.0f) blue:(255/255.0f) alpha:1.0f]];
    
    // Set the Status label
    self.lbl_currentTestStatus.text = @"No Tests Run";
}

- (void)runSearch {
    // Clear the results
    // Set the status label
    self.lbl_currentTestStatus.text = @"No Tests Run";
    
    // Clear the primes found
    [self.primesFound removeAllObjects];
    
    // Reload the Table data to show empty
    [self reloadTable];
    
    
    
    // Set the current status of the search as running
    self.isRunning = true;
    
    NSDate *startTime = [NSDate date];

    // Change the run button to Stop and Red
    [self.btn_runTest setTitle:@"Stop" forState:UIControlStateNormal];
    
    // Set the background color to Red
    [self.btn_runTest setBackgroundColor:[UIColor redColor]];
    
    // Set the Status label
    self.lbl_currentTestStatus.text = @"Finding Primes";
    
    // Clear the primes found
    [self.primesFound removeAllObjects];
    
    // Set threads done to 0
    self.threadsDone = 0;
    
    // Number of Threads
    NSInteger numThreads = self.numThreads;
    
    
    // Run the MultiThreaded Search to find all the primes
    
    
    // Get Current Global Queue
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // Get Current UI Queue
    dispatch_queue_t main_queue = dispatch_get_main_queue();

    
    int numChecksPerThread = (int)self.largestNumberToCheck/numThreads;
    
    // Dispatch the number of required jobs based on the users slider
    for(int i=1; i<=numThreads; i++) {

        // Dispatch a Job to check if the numbers are prime
        dispatch_async(queue, ^{
            
            // Set the starting and ending number
            int startingNumber = (i-1) * numChecksPerThread;
            int endingNumber = (startingNumber + numChecksPerThread) - 1;
            
            // Check to see if the current spawned thread is the limit of threads allowed
            if(i == numThreads) {
                endingNumber = (int)self.largestNumberToCheck; // Give extra checks to the last thread
            }
            
            NSMutableDictionary *primeNumbers = [[NSMutableDictionary alloc] init];
            
            // Loop through all the numbers the thread needs to check
            // and store the primes in an array
            for(int num = startingNumber; num<=endingNumber; num++) {
                if(!self.isRunning) { // Check if the prime finding was canceled
                    break;
                }
                if(num > 1) { // Make sure the number is greater than 1
                    // Check to see if the number is prime
                    if([self isPrime:num]) {
                        [primeNumbers setValue:[NSString stringWithFormat:@"%d",i] forKey:[NSString stringWithFormat:@"%d",num]];
                    }
                }
            }
            
            // Update the main thread
            dispatch_async(main_queue, ^{
                // Add primes found to the main results dict
                if(self.isRunning) { // Check if the prime finding was canceled
                    [self.primesFound addEntriesFromDictionary:primeNumbers];
                }
                
                // Signify the threads are done
                self.threadsDone++;
            });
        });
    }
    
    // Dispatch a Job to check to see if all the threads have completed
    dispatch_async(queue, ^{
        // Wait for all threads to finish
        while (self.threadsDone < numThreads) {
            [NSThread sleepForTimeInterval:0.001];
            dispatch_async(main_queue, ^{
                // Update UI with current Run Time
                // Get Ending Time
                NSDate *endTime = [NSDate date];
                
                // Get time elapsed
                NSTimeInterval executionTime = [endTime timeIntervalSinceDate:startTime];
                
                // Display Time elapsed
                self.lbl_runTime.text = [NSString stringWithFormat:@"%d",(int)(executionTime*1000)];
            });
        }
        
        // Update the main thread
        dispatch_async(main_queue, ^{
            // Change the run button back to the default color and text
            [self.btn_runTest setTitle:@"Find Primes" forState:UIControlStateNormal];
            
            // Set the button background color to Blue (Hex: 0x3366FF)
            [self.btn_runTest setBackgroundColor:[UIColor colorWithRed:(51/255.0f) green:(102/255.0f) blue:(255/255.0f) alpha:1.0f]];
            
            // Get Ending Time
            NSDate *endTime = [NSDate date];
            
            // Get time elapsed
            NSTimeInterval executionTime = [endTime timeIntervalSinceDate:startTime];

            // Display Time elapsed
            self.lbl_runTime.text = [NSString stringWithFormat:@"%d",(int)(executionTime*1000)];

            // Show the results table
            [self reloadTable];
            
            self.isRunning = false;
        });
    });
}

// Check to see if the number is a prime
// Take the number and divide it by all numbers
// equal or less than the square root of the number
- (BOOL)isPrime:(long)number {
    for(int i=sqrt(number); i>1; i--) { // loop through all numbers equal or less than the sqrt of the number
        if((int)number/i == (double)number/i) {
            // Number was divisible without a remainder
            // Not a prime number
            return FALSE;
        }
    }
    // No dividens
    // Number is Prime
    return TRUE;
}


// Called when button on the bottom of the page is clicked
- (IBAction)findPrimes:(id)sender {
    // Check to see if a search is currently running
    if(self.isRunning) {
        // A test is running which this press is to cancel the search
        [self stopSearch];
    } else {
        [self runSearch];
    }
}

// Clear the table from the page
- (IBAction)clearResults:(id)sender {
    // Set the status label
    self.lbl_currentTestStatus.text = @"No Tests Run";
    
    // Clear the primes found
    [self.primesFound removeAllObjects];

    // Reload the Table data to show empty
    [self reloadTable];
}

// Called when the thread slider value changes
- (IBAction)threadSliderValueChanged:(id)sender {
    // Get an instance of the slider
    UISlider *slider = (UISlider *)sender;
    
    // Get the value of the current slider
    self.numThreads = (NSInteger)lround(slider.value);
    
    // Set the label to the current value
    self.lbl_numThreads.text = [NSString stringWithFormat:@"%ld",(long)self.numThreads];
}


// Called when the thread slider value changes
- (IBAction)maxIntSliderValueChanged:(id)sender {
    // Get an instance of the slider
    UISlider *slider = (UISlider *)sender;
    
    // Get the value of the current slider
    self.largestNumberToCheck = (NSInteger)lround(slider.value);
    
    // Set the label to the current value
    self.lbl_maxInt.text = [NSString stringWithFormat:@"%ld",(long)self.largestNumberToCheck];
}




#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.primeNumbers count]; // Return the number of Primes Found
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get the Cell to populate with data
    ResultsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultsCell" forIndexPath:indexPath];
    
    // Get the prime number from the sorted array
    cell.lbl_primeNumber.text = [self.primeNumbers objectAtIndex:indexPath.row];
    
    
    // Get the thread the data was from
    //cell.lbl_threadNumber.text = [self.primesFound objectForKey:primeNumber];
    cell.lbl_threadNumber.text = [self.primesFound objectForKey:[self.primeNumbers objectAtIndex:indexPath.row]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO; // Don't allow the item to be editable
}




@end
