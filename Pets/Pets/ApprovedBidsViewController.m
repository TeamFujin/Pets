//
//  ApprovedBidsViewController.m
//  Pets
//
//  Created by Gosho Goshev on 11/7/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import "ApprovedBidsViewController.h"
#import "FTDatabaseRequester.h"
#import "Offer.h"
@interface ApprovedBidsViewController ()

@end

@implementation ApprovedBidsViewController{
    FTDatabaseRequester* db;
}

- (void)viewDidLoad {
    self.tableView = self.tableViewApprovedBids;
    [super viewDidLoad];
    db = [[FTDatabaseRequester alloc] init];
    [db getActiveOffersForUser:[PFUser currentUser] andBlock:^(NSArray *offers, NSError *error) {
        [super afterGettingDataFromDbWithData:offers andError:error];
    }];
    // Do any additional setup after loading the view.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
