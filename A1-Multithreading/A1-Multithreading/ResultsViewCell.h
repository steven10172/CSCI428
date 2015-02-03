//
//  ResultsViewCell.h
//  A1-Multithreading
//
//  Created by Samantha Yonan on 2/1/15.
//  Copyright (c) 2015 Steven Brice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultsViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbl_threadNumber; // Create a reference to the Thread Number
@property (weak, nonatomic) IBOutlet UILabel *lbl_primeNumber; // Create a reference to the Prime Number

@end
