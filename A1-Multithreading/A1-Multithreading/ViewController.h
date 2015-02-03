//
//  ViewController.h
//  A1-Multithreading
//
//  Created by Samantha Yonan on 2/1/15.
//  Copyright (c) 2015 Steven Brice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property NSInteger numThreads;
@property BOOL isRunning;
@property NSArray* results;

@property (weak, nonatomic) IBOutlet UILabel *lbl_numThreads;
@property (weak, nonatomic) IBOutlet UILabel *lbl_currentTestStatus;
@property (weak, nonatomic) IBOutlet UILabel *lbl_runTime;


@property (weak, nonatomic) IBOutlet UIButton *btn_runTest;

- (void)stopSearch;
- (void)runSearch;


- (IBAction)findPrimes:(id)sender;
- (IBAction)clearResults:(id)sender;
- (IBAction)sliderValueChanged:(id)sender;

@end

