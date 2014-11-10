//
//  OffersViewController.m
//  Pets
//
//  Created by Gosho Goshev on 10/30/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import "ActiveOffersViewController.h"
#import "FTDatabaseRequester.h"
#import "Offer.h"
#import "OfferBidsTableViewController.h"

@interface ActiveOffersViewController ()

@end

@implementation ActiveOffersViewController{
    FTDatabaseRequester* db;
}

- (void)viewDidLoad {
    [self.tabBarController setTitle:@"Pets you give"];
    self.tableView = self.tableViewActiveOffers;
    [super viewDidLoad];
    db = [[FTDatabaseRequester alloc] init];
    [db getActiveOffersForUser:[PFUser currentUser] andBlock:^(NSArray *offers, NSError *error) {
        [super afterGettingDataFromDbWithData:offers andError:error];
    }];
}

@end
