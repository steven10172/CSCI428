//
//  ViewController.m
//  A5-Download-Images
//
//  Created by mobile06 on 4/30/15.
//  Copyright (c) 2015 Steven Brice. All rights reserved.
//


// Set the client URL
#define imageListURL [NSURL URLWithString:@"http://www.seasite.niu.edu/csci628/picuris.txt"]

#import "ViewController.h"
#import "DetailViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup the collection View cell
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    // Get Current Global Queue
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // Dispatch a thread to download the data
    dispatch_async(queue, ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        imageListURL];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
    });
}

// Parse the data from the .txt file
- (void)fetchedData:(NSData *)responseData {
    // Turn the data to a string
    NSString *data = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    // Get an array of each line in the data file
    self.imageArray = [data componentsSeparatedByString:@"\r\n"];

    // Reload the Table data to show the downloaded client data
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    // Return the number of Images
    return [self.imageArray count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // Get the Cell
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Get the URL string from the array
    NSString *url = self.imageArray[indexPath.row];
    
    // Set the background view to a UIImageView
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]]];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Item was selected. prepare the Segue with the clicked index
    [self performSegueWithIdentifier:@"viewImage" sender:indexPath];
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // Deselect item
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"viewImage"]) {
        NSIndexPath *indexPath = sender;
        [[segue destinationViewController] setURL:self.imageArray[indexPath.row]];
    }
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize retval = CGSizeMake(self.collectionView.frame.size.width / 3 - 35, self.collectionView.frame.size.width / 3 - 35);
    return retval;
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 20, 20, 20);
}
@end
