//
//  OfferBidsViewControllerTableViewController.h
//  Pets
//
//  Created by Admin on 11/6/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Offer.h"

@interface OfferBidsTableViewController : UITableViewController<UIGestureRecognizerDelegate, UIAlertViewDelegate>
- (IBAction)longpress:(UILongPressGestureRecognizer*)sender;
- (IBAction)swipe:(UISwipeGestureRecognizer *)sender;
@property (strong, nonatomic) Offer *offer;
@property (strong, nonatomic) NSMutableArray *bidsData;
@end
