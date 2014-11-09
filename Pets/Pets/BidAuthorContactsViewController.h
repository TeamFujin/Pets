//
//  BidAuthorContactsViewController.h
//  Pets
//
//  Created by Gosho Goshev on 11/8/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface BidAuthorContactsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emaiLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) PFUser *author;
@end
