//
//  RejectedBidsViewController.m
//  Pets
//
//  Created by Gosho Goshev on 11/7/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import "RejectedBidsViewController.h"
#import "FTDatabaseRequester.h"
@interface RejectedBidsViewController ()

@end

@implementation RejectedBidsViewController{
    FTDatabaseRequester* db;
}

- (void)viewDidLoad {
    [self.tabBarController setTitle:@"Rejected Pets"];
    self.tableView = self.tableViewRejectedBids;
    [super viewDidLoad];
    db = [[FTDatabaseRequester alloc] init];
    [db getRejectedBidsForUser:[PFUser currentUser] andBlock:^(NSArray *offers, NSError *error) {
        [super afterGettingDataFromDbWithData:offers andError:error];
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.tabBarController setTitle:@"Rejected Pets"];
}

@end