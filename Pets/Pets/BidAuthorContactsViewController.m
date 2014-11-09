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
    [super viewDidLoad];
    self.nameLabel.text = self.author[@"displayName"];
    self.emaiLabel.text = self.author[@"contactEmail"];
    self.phoneLabel.text = self.author[@"contactPhone"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
