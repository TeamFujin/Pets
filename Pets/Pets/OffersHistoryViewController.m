//
//  ActiveOffersViewController.m
//  Pets
//
//  Created by Gosho Goshev on 11/5/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import "OffersHistoryViewController.h"
#import "HomeUITableViewCell.h"
#import "FTDatabaseRequester.h"
#import "FTUtils.h"
#import "Offer.h"
#import "OfferBidsTableViewController.h"


@interface OffersHistoryViewController ()

@end

@implementation OffersHistoryViewController{
    NSArray* recipes;
    FTDatabaseRequester* db;
}

static NSString *cellIdentifier = @"HomeUITableViewCell";
static NSInteger rowHeight = 100;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"in here");
    UINib *nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    db = [[FTDatabaseRequester alloc] init];
    id active = @NO;
    NSLog(@"%d", (int)self.tabBarController.selectedIndex );
//    if((int) self.tabBarController.selectedIndex == -1){
//        active = @YES;
//         NSLog(@"in if");
//    }
    [db getOffersForUser:[PFUser currentUser] andActive:active andBlock:^(NSArray *offers, NSError *error) {
       
    }];
//    recipes = [NSArray arrayWithObjects: @"Active offer", @"Active offer",@"Active offer",@"Active offer",@"Active offer",@"Active offer",@"Active offer",@"Active offer",@"Active offer",@"Active offer",@"Active offer",@"Active offer",@"Active offer",@"Active offer", nil];
}
-(void)afterGettingDataFromDbWithData:(NSArray*) data
                             andError: (NSError*) error {
    if(!error) {
        recipes = [NSMutableArray arrayWithArray:data];
        //    NSLog(@"%@", offers);
        NSLog(@"in success");
        [self.tableView reloadData];
    } else {
        [FTUtils showAlert:@"Error" withMessage:@"Sorry, we couldn't retrieve your active offers."];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [recipes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeUITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    Offer *offer = recipes[indexPath.row];
    cell.labelTitle.text = offer.title;
    cell.labelPrice.text = [NSString stringWithFormat:@"Price: #%@BGN", offer.price];
    if(offer.picture) {
        NSData *data = [[NSData alloc]initWithBase64EncodedString:offer.picture options:NSDataBase64DecodingIgnoreUnknownCharacters];
        cell.imageViewPicture.image = [UIImage imageWithData:data];
    }
    else {
        cell.imageViewPicture.image = nil;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return rowHeight;
}
/*
<<<<<<< Updated upstream
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"In touch - %d", (int)self.tabBarController.selectedIndex == -1);//self.tabBarController.
    if(self.tabBarController.selectedIndex == -1){
        Offer *offer = [recipes objectAtIndex:indexPath.row];
    
        OfferBidsTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"OfferBidsController"];
    
        [controller setOffer:offer];
        [self.navigationController pushViewController:controller animated:YES];
    }
}
@end
