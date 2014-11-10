//
//  ApprovedBidsViewController.m
//  Pets
//
//  Created by Gosho Goshev on 11/7/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import "ApprovedBidsViewController.h"
#import "FTDatabaseRequester.h"
#import "OfferDetailsViewController.h"

@interface ApprovedBidsViewController ()

@end

@implementation ApprovedBidsViewController{
    FTDatabaseRequester* db;
}

- (void)viewDidLoad {
    [self.tabBarController setTitle:@"Approved Pets"];
    self.tableView = self.tableViewApprovedBids;
    [super viewDidLoad];
    db = [[FTDatabaseRequester alloc] init];
    [db getApprovedBidsForUser:[PFUser currentUser] andBlock:^(NSArray *offers, NSError *error) {
        [super afterGettingDataFromDbWithData:offers andError:error];
    }];
}

@end
