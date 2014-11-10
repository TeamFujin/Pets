//
//  ActiveOffersViewController.m
//  Pets
//
//  Created by Gosho Goshev on 11/5/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import "OffersHistoryViewController.h"
#import "HomeUITableViewCell.h"
#import "FTUtils.h"
#import "Offer.h"
#import "OfferBidsTableViewController.h"
#import "FTSpinner.h"

@interface OffersHistoryViewController ()

@end

@implementation OffersHistoryViewController{
    FTSpinner *spinner;
}

static NSString *cellIdentifier = @"HomeUITableViewCell";
static NSInteger rowHeight = 100;
- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    
    spinner = [[FTSpinner alloc] initWithView:self.view andSize:70 andScale:2.5f];
    [spinner startSpinning];
}
-(void)afterGettingDataFromDbWithData:(NSArray*) data
                             andError: (NSError*) error {
    [spinner stopSpinning];
    if(!error) {
        self.data = [NSMutableArray arrayWithArray:data];
        [self.tableView reloadData];
    } else {
        [FTUtils showAlert:@"Error" withMessage:@"Sorry, we couldn't retrieve the offers."];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    Offer *offer = self.data[indexPath.row];
    cell.labelTitle.text = offer.title;
    NSNumber *price = offer.price;
    if ([price isEqual:@0]) {
        cell.labelPrice.text = @"FREE";
    }
    else{
        cell.labelPrice.text = [NSString stringWithFormat:@"%@ BGN", price];
    }
    if(offer.photo) {
        [offer.photo getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            cell.imageViewPicture.image = [UIImage imageWithData:data ];
        }];
    } else {
        cell.imageViewPicture.image = nil;
    }
    
    [cell setClipsToBounds:YES];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Offer *offer = [self.data objectAtIndex:indexPath.row];
    
    OfferBidsTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"OfferBidsController"];
    
    [controller setOffer:offer];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
