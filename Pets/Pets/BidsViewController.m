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
        yourBtn.tag = indexPath.row;
        [yourBtn addTarget:self
                    action:@selector(yourButtonClicked:)
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
        [offer.photo getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            cell.image.image = [UIImage imageWithData:data];
        }];
    }
    else {
        cell.image.image = nil;
    }
    
    [cell setClipsToBounds:YES];
    return cell;
}

-(void)yourButtonClicked:(UIButton*)sender
{
    Deal *bid = self.data[sender.tag];
    
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

-(void) showOfferAuthorContacts{
    NSLog(@"Show author contacts");
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return rowHeight;
}
@end
