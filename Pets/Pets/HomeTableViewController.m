//
//  HomeTableViewController.m
//  Pets
//
//  Created by Gosho Goshev on 10/30/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import "HomeTableViewController.h"
#import "HomeUITableViewCell.h"
#import "FTDatabaseRequester.h"
#import "Offer.h"
#import "FTSpinner.h"
#import "FTUtils.h"

@interface HomeTableViewController ()

@end

@implementation HomeTableViewController

static NSInteger rowHeight = 105;
static NSString *cellIdentifier = @"HomeUITableViewCell";

- (void)viewDidLoad {
    self.title = @"All Pets";
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    FTDatabaseRequester *db = [[FTDatabaseRequester alloc] init];
    FTSpinner *spinner = [[FTSpinner alloc] initWithView:self.tableView andSize:70 andScale:2.5f];
    [spinner startSpinning];
    
    __weak HomeTableViewController *weakSelf = self;
    [db getAllActiveOffersWithBlock:^(NSArray *objects, NSError *error) {
        [spinner stopSpinning];
        if(!error) {
            weakSelf.data = [NSMutableArray arrayWithArray:objects];
            [weakSelf.tableView reloadData];
        } else {
            [FTUtils showAlert:@"We are sorry" withMessage:@"We couldn't retrieve the offers."];
        }
    }];
}

-(void)goToAddOffer{
    [self performSegueWithIdentifier:@"ToAddOffer" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeUITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[HomeUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    Offer *offer = self.data[indexPath.row];
    cell.labelTitle.text = offer.title;
    NSNumber *price = offer.price;
    if ([price isEqual:@0]) {
        cell.labelPrice.text = @"FREE";
    } else{
        cell.labelPrice.text = [NSString stringWithFormat:@"%@ BGN", price];
    }
    if(offer.photo) {
        [offer.photo getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            cell.imageViewPicture.image = [UIImage imageWithData:data];
        }];
    } else {
        cell.imageViewPicture.image = nil;
    }
    
    [cell setClipsToBounds:YES];
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    Offer *offer = self.data[indexPath.row];
    if ([offer.userId.objectId isEqual:[PFUser currentUser].objectId]) {
        return YES;
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Offer *offer = self.data[indexPath.row];
        offer.active = 0;
        __weak HomeTableViewController *weakSelf = self;
        [offer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(succeeded) {
                [weakSelf.data removeObjectAtIndex:indexPath.row];
                [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            } else {
                [FTUtils showAlert:@"We are sorry" withMessage:@"Unfortunatelly, you can't delete your pet offer right now"];
            }
        }];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Get reference to receipt
    Offer *offer = [self.data objectAtIndex:indexPath.row];
    
    OfferDetailsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"offerDetails"];
    
    // Pass data to controller
    controller.offer = offer;
    [self.navigationController pushViewController:controller animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return rowHeight;
}
@end
