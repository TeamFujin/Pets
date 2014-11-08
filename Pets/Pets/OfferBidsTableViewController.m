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
    NSMutableArray *bidsData;
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
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    
    db = [[FTDatabaseRequester alloc] init];
    //TODO: use static or weakSelf here
    [db getOfferBidsForOffer:self.offer andBlock:^(NSArray *bids, NSError *error) {
        if(!error) {
            bidsData = [NSMutableArray arrayWithArray:bids];
          //    NSLog(@"%@", bids);
            [self.tableView reloadData];
        } else {
            [FTUtils showAlert:@"We are sorry" withMessage:@"We can't show you who wants your pet right now."];
            NSLog(@"Error in offerBids: %@", error);
        }
    }];
    
   // NSLog(@"self.offer: %@", self.offer);
//    NSLog(@"before self.offer.active fromviewDidload: %d", self.offer.active);
//    self.offer.active = @NO;
//    NSLog(@"after self.offer.active fromviewDidload: %d", self.offer.active);
//    self.offer.active = 0;
//    NSLog(@"after self.offer.active fromviewDidload: %d", self.offer.active);
}

- (void)longPress:(UILongPressGestureRecognizer*)gesture
{
    if ( gesture.state == UIGestureRecognizerStateEnded ) {
        
        UICollectionViewCell *cellLongPressed = (UICollectionViewCell *) gesture.view;
        NSLog(@"Gesture: %@", cellLongPressed);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return bidsData.count;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return bidsData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OfferBidsUITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
   // NSLog(@"%@", cell);
    Deal *deal = bidsData[indexPath.row];
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
    Deal *deal = [bidsData objectAtIndex:indexPath.row];
    PFUser *user = deal[@"wanterId"];
    NSString *facebookId = user[@"facebookId"];
    //    NSLog(@"Password %@", user.password);
    //    NSLog(@"ObjectId %@", user.objectId);
    //    NSLog(@"Email %@", user[@"email"]);
    //    NSLog(@"authData %@", user[@"authData"]);
    //    NSLog(@"www.facebook.com/%@", facebookId);
    //    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.facebook.com/%@", facebookId]];
    //    [[UIApplication sharedApplication] openURL:url];
    
    WebFacebookViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"webFacebook"];
    
    // Pass data to controller
    controller.facebookId = facebookId;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)longpress:(UILongPressGestureRecognizer*)sender {
    NSLog(@"Long press");
        if (sender.state != UIGestureRecognizerStateEnded) {
            return;
        }
    CGPoint point = [sender locationInView:self.tableView];
    
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
        if (!(indexPath == nil)){
            indexPathForApprovedBid = indexPath;
            Deal *toBeApprovedDeal = bidsData[indexPath.row];
            if (toBeApprovedDeal.approved) {
                [FTUtils showAlert:@"Already done" withMessage:@"You have already approved this person"];
            } else if(self.offer.active) {
            [[[UIAlertView alloc] initWithTitle:@"Give your pet" message:@"Are you sure you want to give your pet to this person?" delegate:self cancelButtonTitle:@"Yes, seems legit!" otherButtonTitles:@"No, keep my pet!", nil] show];
        } else {
            //Offer is not active
            [FTUtils showAlert:@"This pet already has a new owner" withMessage:@"You can't give your pet to two people at once!"];
        }
            // get the cell at indexPath (the one you long pressed)
     //       OfferBidsUITableViewCell* cell =
      //     [self.tableView cellForRowAtIndexPath:indexPath];//cellForItemAtIndexPath:indexPath];
       //     NSLog(@"cell.labelName.text: %@", cell.labelName.text);
       //     NSLog(@"cell: %@", cell);
        } else {
            [FTUtils showAlert:@"We are sorry" withMessage:@"Something went wrong with your fingers"];
        }

}

//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    NSLog(@"Button index: %ld", buttonIndex);
//}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSLog(@"Button index: %ld", buttonIndex);
    Deal *approvedDeal = bidsData[indexPathForApprovedBid.row];
    approvedDeal.offerId = self.offer;
    if(buttonIndex == 0 && indexPathForApprovedBid){
            NSLog(@"self.offer.active: %d", self.offer.active);
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
        Deal *deal = bidsData[indexPath.row];
        if (!deal.approved) {
            deal[@"deleted"] = @YES;
            [deal saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(succeeded) {
                    [bidsData removeObjectAtIndex:indexPath.row];
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
