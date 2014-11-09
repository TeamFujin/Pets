//
//  BidsViewController.m
//  Pets
//
//  Created by Gosho Goshev on 11/7/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import "BidsViewController.h"
#import "OfferUITableViewCell.h"
#import "HomeUITableViewCell.h"
#import "FTUtils.h"
#import "Deal.h"
#import "Offer.h"
#import "FTSpinner.h"
#import "BidAuthorContactsViewController.h"

@interface BidsViewController ()

@end

@implementation BidsViewController{
    FTSpinner *spinner;
    PFUser *currAuthor;
}

static NSString *cellIdentifier = @"OfferUITableViewCell";
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
    
    OfferUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UIButton *yourBtn = (UIButton *) [cell viewWithTag:1];
    [yourBtn setHidden:YES];
    Deal *bid = self.data[indexPath.row];
    Offer *offer = (Offer *)bid.offerId;
    if(bid.approved == YES){
        [yourBtn setHidden:NO];
        [yourBtn addTarget:self
                    action:@selector(showOfferAuthorContacts)
          forControlEvents:UIControlEventTouchUpInside];
    }
    cell.labelTItle.text = offer.title;
    NSNumber *price = offer.price;
    if ([price isEqual:@0]) {
        cell.labelPrice.text = @"FREE";
    }
    else{
        cell.labelPrice.text = [NSString stringWithFormat:@"%@ BGN", price];
    }    if(offer.photo) {
        NSData *data = [offer.photo getData];//[[NSData alloc]initWithBase64EncodedString:offer.picture options:NSDataBase64DecodingIgnoreUnknownCharacters];
        cell.image.image = [UIImage imageWithData:data];
    }
    else {
        cell.image.image = nil;
    }
    
    return cell;
}
-(void) showOfferAuthorContacts{
    NSLog(@"Show autor contacts");
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return rowHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Deal *bid = self.data[indexPath.row];
    
    if(bid.approved == YES){
        BidAuthorContactsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"BidAuthorContactsViewController"];
        Offer *offer = (Offer *)bid.offerId;
        [offer.userId fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            PFUser* author = (PFUser *) object;
            controller.author = author;
            [self.navigationController pushViewController:controller animated:YES];
        }];
        
    }
}
/*
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
@end
