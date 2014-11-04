//
//  LoginViewController.m
//  Pets
//
//  Created by Gosho Goshev on 10/30/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import "LoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UILabel *loginStatusLabel;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *permissions = @[@"email", @"user_likes"];
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        NSString *result;
        if (!user) {
            result = @"The user cancelled the Facebook login.";
        } else if (user.isNew) {
            result = @"User signed up and logged in through Facebook!";
        } else {
            result = @"User logged in through Facebook!";
        }
        self.loginStatusLabel.text = result;
    }];
    //FBLoginView *loginView = [[FBLoginView alloc] init];
    //loginView.center = self.view.center;
    //[self.view addSubview:loginView];
    
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
