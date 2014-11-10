//
//  PendingBidsViewController.m
//  Pets
//
//  Created by Gosho Goshev on 11/7/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import "PendingBidsViewController.h"
#import "FTDatabaseRequester.h"

@interface PendingBidsViewController ()

@end

@implementation PendingBidsViewController{
    FTDatabaseRequester* db;
}

- (void)viewDidLoad {
    [self.tabBarController setTitle:@"Pendings Pets"];
    self.tableView = self.tableViewPendingBids;
    [super viewDidLoad];
    db = [[FTDatabaseRequester alloc] init];
    [db getPendingBidsForUser:[PFUser currentUser] andBlock:^(NSArray *offers, NSError *error) {
        [super afterGettingDataFromDbWithData:offers andError:error];
    }];
}

@end
