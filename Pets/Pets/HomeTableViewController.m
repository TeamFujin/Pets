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

static NSInteger count = 0;
static NSInteger rowHeight = 100;
static NSMutableArray *data;
static NSString *cellIdentifier = @"HomeUITableViewCell";

- (void)viewDidLoad {
    self.title = @"All Offers";
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    FTDatabaseRequester *db = [[FTDatabaseRequester alloc] init];
    FTSpinner *spinner = [[FTSpinner alloc] initWithView:self.tableView andSize:70 andScale:2.5f];
    [spinner startSpinning];
    
    [db getAllActiveOffersWithBlock:^(NSArray *objects, NSError *error) {
        [spinner stopSpinning];
        if(!error) {
            count = objects.count;
            data = [NSMutableArray arrayWithArray:objects];
            [self.tableView reloadData];
        } else {
            [FTUtils showAlert:@"Error" withMessage:@"Sorry, we couldn't retrieve the offers."];
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

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeUITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    Offer *offer = data[indexPath.row];
    cell.labelTitle.text = offer.title;
    NSNumber *price = offer.price;
    if ([price isEqual:@0]) {
        cell.labelPrice.text = @"FREE";
    }
    else{
        cell.labelPrice.text = [NSString stringWithFormat:@"%@ BGN", price];
    }
    if(offer.picture) {
        NSData *data = [[NSData alloc]initWithBase64EncodedString:offer.picture options:NSDataBase64DecodingIgnoreUnknownCharacters];
        cell.imageViewPicture.image = [UIImage imageWithData:data];
    }
    else {
        cell.imageViewPicture.image = nil;
    }
    
    return cell;
}


 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Offer *offer = data[indexPath.row];
        offer.active = 0;
        [offer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(succeeded) {
                [data removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            } else {
                [FTUtils showAlert:@"We are sorry" withMessage:@"Unfortunatelly, you can't delete your pet offer right now"];
            }
        }];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //Get reference to receipt
    Offer *offer = [data objectAtIndex:indexPath.row];
    
    OfferDetailsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"offerDetails"];
    
    // Pass data to controller
    controller.offer = offer;
    [self.navigationController pushViewController:controller animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return rowHeight;
}

-(void)viewWillAppear:(BOOL)animated{
    FTDatabaseRequester *db = [[FTDatabaseRequester alloc] init];
    FTSpinner *spinner = [[FTSpinner alloc] initWithView:self.tableView andSize:70 andScale:2.5f];
    [spinner startSpinning];
    [db getAllActiveOffersWithBlock:^(NSArray *objects, NSError *error) {
        [spinner stopSpinning];
        if(!error) {
            count = objects.count;
            data = [NSMutableArray arrayWithArray:objects];
            [self.tableView reloadData];
        } else {
            [FTUtils showAlert:@"Error" withMessage:@"Sorry, we couldn't retrieve the offers."];
        }
    }];
}
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    NSLog(@"in prepareForSegue");
//    if ([[segue identifier] isEqualToString:@"showOfferDetails"]) {
//         NSLog(@"in prepareForSegue");
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        Offer *offer = data[indexPath.row];
//        OfferDetailsViewController *controller = (OfferDetailsViewController *)[[segue destinationViewController] topViewController];
//        [controller setOffer:offer];
//      //  controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
//        //controller.navigationItem.leftItemsSupplementBackButton = YES;
//    }
//}

@end
