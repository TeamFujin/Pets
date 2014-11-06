//
//  OffersViewController.h
//  Pets
//
//  Created by Gosho Goshev on 10/30/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OffersHistoryViewController.h"

@interface ActiveOffersViewController : OffersHistoryViewController
@property (weak, nonatomic) IBOutlet UITableView *tableViewActiveOffers;
@end
