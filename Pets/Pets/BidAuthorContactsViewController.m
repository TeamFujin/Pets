//
//  BidAuthorContactsViewController.m
//  Pets
//
//  Created by Gosho Goshev on 11/8/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import "BidAuthorContactsViewController.h"

@interface BidAuthorContactsViewController ()

@end

@implementation BidAuthorContactsViewController

- (void)viewDidLoad {
    self.title = @"Contact info";
    [super viewDidLoad];
    self.nameLabel.text = self.author[@"displayName"];
    self.emaiLabel.text = self.author[@"contactEmail"];
    self.phoneLabel.text = self.author[@"contactPhone"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
