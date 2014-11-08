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

@interface OfferBidsTableViewController ()

@end

@implementation OfferBidsTableViewController{
    NSMutableArray *bidsData;
    FTDatabaseRequester *db;
}
static NSString *cellIdentifier = @"OfferBidsUITableViewCell";

- (void)setOffer:(id)newOffer {
    if (_offer != newOffer) {
        _offer = newOffer;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    
//    UILongPressGestureRecognizer *lpgr
//    = [[UILongPressGestureRecognizer alloc]
//       initWithTarget:self action:@selector(handleLongPress:)];
//    lpgr.minimumPressDuration = .5; //seconds
//    lpgr.delegate = self;
//    [self.tableView addGestureRecognizer:lpgr];
    
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
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

//-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
//{
//    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
//        return;
//    }
//    CGPoint p = [gestureRecognizer locationInView:self.tableView];
//    
//    NSIndexPath *indexPath = [self.tableView indexPathForItemAtPoint:p];
//    if (indexPath == nil){
//        NSLog(@"couldn't find index path");
//    } else {
//        // get the cell at indexPath (the one you long pressed)
//        UICollectionViewCell* cell =
//        [self.tableView cellForItemAtIndexPath:indexPath];
//        // do stuff with the cell
//    }
//    //lpgr.delaysTouchesBegan = YES;
//}

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
    NSLog(@"%@", cell);
    Deal *deal = bidsData[indexPath.row];
    PFUser *user = deal[@"wanterId"];
    NSLog(@"PFUser: %@", user);
    cell.labelName.text = [NSString stringWithFormat:@"Name: %@", user[@"displayName"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Get reference to receipt
    Deal *deal = [bidsData objectAtIndex:indexPath.row];
    PFUser *user = deal[@"wanterId"];
    NSString *facebookId = user[@"facebookId"];
    NSLog(@"Password %@", user.password);
    NSLog(@"ObjectId %@", user.objectId);
    NSLog(@"Email %@", user[@"email"]);
    NSLog(@"authData %@", user[@"authData"]);
    NSLog(@"www.facebook.com/%@", facebookId);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.facebook.com/%@", facebookId]];
    [[UIApplication sharedApplication] openURL:url];
}


// Override to support conditional editing of the table view.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}



// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
//}


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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)longpress:(UILongPressGestureRecognizer*)sender {
    NSLog(@"Long press");
    CGPoint point = [sender locationInView:self.tableView];
    
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
        if (indexPath == nil){
            NSLog(@"couldn't find index path");
        } else {
            // get the cell at indexPath (the one you long pressed)
            OfferBidsUITableViewCell* cell =
            [self.tableView cellForRowAtIndexPath:indexPath];//cellForItemAtIndexPath:indexPath];
            NSLog(@"cell.labelName.text: %@", cell.labelName.text);
            NSLog(@"cell: %@", cell);
        }

}

- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self.tableView];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    if (!(indexPath == nil)){
        OfferBidsUITableViewCell* cell =
        [self.tableView cellForRowAtIndexPath:indexPath];
        Deal *deal = bidsData[indexPath.row];
        deal[@"deleted"] = @YES;
        [deal saveInBackground];
    } else {
        [FTUtils showAlert:@"We are sorry" withMessage:@"Something went wrong with your fingures"];
    }

}
@end
