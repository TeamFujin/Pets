//
//  ActiveOffersViewController.h
//  Pets
//
//  Created by Gosho Goshev on 11/5/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OffersHistoryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *data;
-(void)afterGettingDataFromDbWithData:(NSArray*) data
                             andError: (NSError*) error;
@end
