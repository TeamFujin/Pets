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
#import "FTSpinner.h"
#import "FTUtils.h"
#import "ProfileViewController.h"
#import "FTJokeDispenser.h"
@interface LoginViewController ()
@end

@implementation LoginViewController

- (void)viewDidLoad {
    self.title = @"Login";
    [super viewDidLoad];
    [self startAsyncTask];
    //UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithTitle:@"Profile" style:UIBarButtonItemStylePlain target:self action:@selector(doneClicked:)];
    //self.navigationItem.rightBarButtonItems = @[rightBarButton, doneButton];
    
}

- (void) startAsyncTask{
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        while (true) {
            BOOL connectionAvailable = [FTUtils isConnectionAvailable];
            //NSLog(@"%d", connectionAvailable);
            if (connectionAvailable != 1) {
              break;
            }
            [NSThread sleepForTimeInterval:2.0];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [FTJokeDispenser showJoke];
            [self startAsyncTask];
        });
    });
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}
- (IBAction)fbLoginButtonTaped:(id)sender {
    FTSpinner *spinner = [[FTSpinner alloc] initWithView:self.view andSize:100 andScale:3.5f];
    [spinner startSpinning];
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        [spinner stopSpinning];
        if (!user) {
            NSString *errorMessage = nil;
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                errorMessage = @"Uh oh. The user cancelled the Facebook login.";
            } else {
                NSLog(@"An error occurred: %@", error);
                errorMessage = [error localizedDescription];
            }
            [FTUtils showAlert:@"Error" withMessage:@"Unable to log in with Facebook"];
        } else {
            if (user.isNew) {
                NSLog(@"User with facebook signed up and logged in!");
            } else {
                NSLog(@"User with facebook logged in!");
            }
        }
    }];
    
    
}
- (IBAction)continueTaped:(id)sender {
    PFUser *currUser = [PFUser currentUser];
    if(currUser.email != nil){
        [self performSegueWithIdentifier:@"ToProfile" sender:self];
    }
    else{
        [self performSegueWithIdentifier:@"ToAddContactInfo" sender:self];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    //if ([PFUser currentUser] && // Check if user is cached
      //  [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
       // NSLog(@"User is already logged in !");
        //[self performSegueWithIdentifier:@"ToAddContactInfo" sender:self];
    //}
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
