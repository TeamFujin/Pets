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
    [super viewDidLoad];
    db = [[FTDatabaseRequester alloc] init];
    [db getInactiveOffersForUser:[PFUser currentUser] andBlock:^(NSArray *offers, NSError *error) {
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
