//
//  OfferBidsViewControllerTableViewController.m
//  Pets
//
//  Created by Admin on 11/6/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import "OfferBidsTableViewController.h"
#import "FTDatabaseRequester.h"
#import "FTUtils.h"
#import "OfferBidsUITableViewCell.h"
#import "Deal.h"
#import "WebFacebookViewController.h"

@interface OfferBidsTableViewController ()

@end

@implementation OfferBidsTableViewController{
    FTDatabaseRequester *db;
    NSIndexPath *indexPathForApprovedBid;
}
static NSString *cellIdentifier = @"OfferBidsUITableViewCell";
static NSString *labelTextApproved;

- (void)setOffer:(id)newOffer {
    if (_offer != newOffer) {
        _offer = newOffer;
    }
}

- (void)viewDidLoad {
    self.title = @"Potential owners";
    self.tableView.rowHeight = 44;
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    
    db = [[FTDatabaseRequester alloc] init];
    __weak OfferBidsTableViewController *weakSelf = self;
    [db getOfferBidsForOffer:self.offer andBlock:^(NSArray *bids, NSError *error) {
        if(!error) {
            weakSelf.bidsData = [NSMutableArray arrayWithArray:bids];
            [weakSelf.tableView reloadData];
        } else {
            [FTUtils showAlert:@"We are sorry" withMessage:@"We can't show you who wants your pet right now."];
        }
    }];
}

- (void)longPress:(UILongPressGestureRecognizer*)gesture
{
    if ( gesture.state == UIGestureRecognizerStateEnded ) {
        
        UICollectionViewCell *cellLongPressed = (UICollectionViewCell *) gesture.view;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bidsData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OfferBidsUITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    Deal *deal = self.bidsData[indexPath.row];
    PFUser *user = deal[@"wanterId"];
    cell.labelName.text = [NSString stringWithFormat:@"%@", user[@"displayName"]];
    cell.labelApproved.tag = indexPath.row;
    labelTextApproved = cell.labelApproved.text;
    if (!deal.approved) {
        cell.labelApproved.text = @"";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Get reference to receipt
    Deal *deal = [self.bidsData objectAtIndex:indexPath.row];
    PFUser *user = deal[@"wanterId"];
    NSString *facebookId = user[@"facebookId"];
    
    WebFacebookViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"webFacebook"];
    
    // Pass data to controller
    controller.facebookId = facebookId;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)longpress:(UILongPressGestureRecognizer*)sender {
    if (sender.state != UIGestureRecognizerStateEnded) {
        return;
    }
    CGPoint point = [sender locationInView:self.tableView];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    if (!(indexPath == nil)){
        indexPathForApprovedBid = indexPath;
        Deal *toBeApprovedDeal = self.bidsData[indexPath.row];
        if (toBeApprovedDeal.approved) {
            [FTUtils showAlert:@"Already done" withMessage:@"You have already approved this person"];
        } else if(self.offer.active) {
            [[[UIAlertView alloc] initWithTitle:@"Give your pet" message:@"Are you sure you want to give your pet to this person?" delegate:self cancelButtonTitle:@"Yes, seems legit!" otherButtonTitles:@"No, keep my pet!", nil] show];
        } else {
            [FTUtils showAlert:@"This pet already has a new owner" withMessage:@"You can't give your pet to two people at once!"];
        }
    } else {
        [FTUtils showAlert:@"We are sorry" withMessage:@"Something went wrong with your fingers"];
    }
    
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    Deal *approvedDeal = self.bidsData[indexPathForApprovedBid.row];
    approvedDeal.offerId = self.offer;
    if(buttonIndex == 0 && indexPathForApprovedBid){
        __weak OfferBidsTableViewController *weakSelf = self;
        [db updateDealForApprovalWithDeal:approvedDeal andBlock:^(BOOL succeeded, NSError *error) {
            if(succeeded) {
                [FTUtils showAlert:@"Congratulations" withMessage:@"Your pet has a new family!"];
                approvedDeal.approved = @YES;
                weakSelf.offer.active = 0;
                OfferBidsUITableViewCell* cell = (OfferBidsUITableViewCell*)
                [weakSelf.tableView cellForRowAtIndexPath:indexPathForApprovedBid];
                cell.labelApproved.text = labelTextApproved;
            } else {
                [FTUtils showAlert:@"We are sorry" withMessage:@"You can't approve this person right now"];
            }
        }];
    }
}
- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self.tableView];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    if (!(indexPath == nil)){
        Deal *deal = self.bidsData[indexPath.row];
        if (!deal.approved) {
            deal[@"deleted"] = @YES;
            __weak OfferBidsTableViewController *weakSelf = self;
            [deal saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(succeeded) {
                    [weakSelf.bidsData removeObjectAtIndex:indexPath.row];
                    [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                } else {
                    [FTUtils showAlert:@"We are sorry" withMessage:@"Something went wrong and we couldn't delete this"];
                }
            }];
        } else {
            [FTUtils showAlert:@"Better keep it" withMessage:@"It would be better to have info about your pet's new owner"];
        }
    } else {
        [FTUtils showAlert:@"We are sorry" withMessage:@"Something went wrong with your fingers"];
    }
}
@end
