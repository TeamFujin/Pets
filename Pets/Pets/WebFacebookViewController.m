//
//  WebFacebookViewController.m
//  Pets
//
//  Created by Admin on 11/7/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import "WebFacebookViewController.h"

@interface WebFacebookViewController ()

@end

@implementation WebFacebookViewController

- (void)viewDidLoad {
    self.title = @"Facebook profile";
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.facebook.com/%@", self.facebookId]];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webViewFacebook loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
