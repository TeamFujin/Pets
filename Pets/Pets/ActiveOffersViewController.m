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
    self.tableView = self.tableViewActiveOffers;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 //   NSLog(@"In touch - %d", (int)self.tabBarController.selectedIndex == -1);//self.tabBarController.
        Offer *offer = [self.data objectAtIndex:indexPath.row];
        
        OfferBidsTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"OfferBidsController"];
        
        [controller setOffer:offer];
        [self.navigationController pushViewController:controller animated:YES];
}
@end
