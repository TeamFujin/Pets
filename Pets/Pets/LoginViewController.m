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
#import <CoreData/CoreData.h>
@interface LoginViewController ()
@end

@implementation LoginViewController

- (void)viewDidLoad {
    self.title = @"Login";
    [super viewDidLoad];
    [self startAsyncTask];
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Create a new managed object
    NSManagedObject *joke = [NSEntityDescription insertNewObjectForEntityForName:@"Joke" inManagedObjectContext:context];
    [joke setValue:@"FUNNY JOKE HERE" forKey:@"body"];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Joke"];
    NSMutableArray *devices = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSManagedObject *device = [devices objectAtIndex:0];
    NSLog(@"%@", [device valueForKey:@"body"]);
    //NSLog(devices);

}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void) startAsyncTask{
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        while (true) {
            BOOL connectionAvailable = [FTUtils isConnectionAvailable];
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
    NSArray *permissionsArray = @[ @"user_about_me", @"email", @"user_birthday", @"user_location"];
   
    FTSpinner *spinner = [[FTSpinner alloc] initWithView:self.view andSize:70 andScale:2.5f];
    [spinner startSpinning];
    if ([PFUser currentUser] && // Check if user is cached
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [spinner stopSpinning];
        [FTUtils showAlert:@"Um.." withMessage:@"You are already logged in"];
    }
    else{
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        [spinner stopSpinning];
        
        if (!user) {
            NSString *errorMessage = nil;
            if (!error) {
                NSLog(@"The user cancelled the Facebook login.");
            } else {
                [FTUtils showAlert:@"Error" withMessage:@"Unable to log in with Facebook"];
                NSLog(@"An error occurred: %@", error);
                errorMessage = [error localizedDescription];
            }
        } else {
            if (user.isNew) {
                NSLog(@"User with facebook signed up and logged in!");
            } else {
                NSLog(@"User with facebook logged in!");
            }
        }
    }];
    }
}
- (IBAction)continueTaped:(id)sender {
    if ([PFUser currentUser] && // Check if user is cached
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        PFUser *currUser = [PFUser currentUser];
        if(currUser[@"contactEmail"] != nil && currUser[@"contactPhone"] != nil){
            [self performSegueWithIdentifier:@"ToProfile" sender:self];
        }
        else{
            [self performSegueWithIdentifier:@"ToAddContactInfo" sender:self];
        }
    }else{
        [FTUtils showAlert:@"Error" withMessage:@"You are not logged in !"];
    }
}
- (IBAction)helpTaped:(id)sender {
    [FTUtils showAlert:@"Hi!" withMessage:@"Show some basic info for the app, developers contact info, etc.."];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
