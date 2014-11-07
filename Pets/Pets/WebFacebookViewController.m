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
    [super viewDidLoad];
       NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.facebook.com/%@", self.facebookId]];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webViewFacebook loadRequest:requestObj];
    //    [[UIApplication sharedApplication] openURL:url];
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