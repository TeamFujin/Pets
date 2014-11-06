//
//  ActiveOffersViewController.m
//  Pets
//
//  Created by Gosho Goshev on 11/5/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import "ActiveOffersViewController.h"
#import "HomeUITableViewCell.h"
#import "FTDatabaseRequester.h"
#import "FTUtils.h"
#import "Offer.h"

@interface ActiveOffersViewController ()

@end

@implementation ActiveOffersViewController{
    NSArray* recipes;
    FTDatabaseRequester* db;
}

static NSString *cellIdentifier = @"HomeUITableViewCell";
static NSInteger rowHeight = 100;

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    db = [[FTDatabaseRequester alloc] init];
    
    [db getActiveOffersForUser:[PFUser currentUser] andBlock:^(NSArray *offers, NSError *error) {
        if(!error) {
            recipes = [NSMutableArray arrayWithArray:offers];
              NSLog(@"%@", offers);
            [self.tableView reloadData];
        } else {
            [FTUtils showAlert:@"Error" withMessage:@"Sorry, we couldn't retrieve your active offers."];
        }
    }];
//    recipes = [NSArray arrayWithObjects: @"Active offer", @"Active offer",@"Active offer",@"Active offer",@"Active offer",@"Active offer",@"Active offer",@"Active offer",@"Active offer",@"Active offer",@"Active offer",@"Active offer",@"Active offer",@"Active offer", nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [recipes count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeUITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    Offer *offer = recipes[indexPath.row];
    NSLog(@"%@", offer.title);
    cell.labelTitle.text = offer.title;
    NSLog(@"%@", offer.price);
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    //Get reference to receipt
//    Offer *offer = [data objectAtIndex:indexPath.row];
//    
//    OfferDetailsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"offerDetails"];
//    
//    // Pass data to controller
//    controller.offer = offer;
//    [self.navigationController pushViewController:controller animated:YES];
}
@end
