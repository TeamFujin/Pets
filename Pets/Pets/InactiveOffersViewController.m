//
//  OffersHistoryViewController.m
//  Pets
//
//  Created by Gosho Goshev on 11/5/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import "InactiveOffersViewController.h"
#import "FTDatabaseRequester.h"

@interface InactiveOffersViewController ()

@end

@implementation InactiveOffersViewController{
    FTDatabaseRequester* db;
}

- (void)viewDidLoad {
    [self.tabBarController setTitle:@"Pets you gave"];
    self.tableView = self.tableViewInactiveOffers;
    [super viewDidLoad];
    db = [[FTDatabaseRequester alloc] init];
    [db getInactiveOffersForUser:[PFUser currentUser] andBlock:^(NSArray *offers, NSError *error) {
        [super afterGettingDataFromDbWithData:offers andError:error];
    }];
}

@end
