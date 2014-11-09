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
#import "FTDatabaseRequester.h"

@interface LoginViewController ()
@end

@implementation LoginViewController{
    UIDynamicAnimator *animator;
}

- (void)viewDidLoad {
    self.title = @"Login";
    [super viewDidLoad];
  //  [self saveJokesToCoreData];
  //  FTJokeDispenser *dispenser = [[FTJokeDispenser alloc] init];
   // [dispenser showJoke];
    [self startAsyncTask];
}

- (void) saveJokesToCoreData{
    NSManagedObjectContext *context = [self managedObjectContext];
    FTDatabaseRequester *db = [[FTDatabaseRequester alloc] init];
    [db getJokesWithBlock:^(NSArray *objects, NSError *error) {
        for (NSDictionary *obj in objects) {
            NSString *jokeBody = [obj objectForKey:@"Joke"];
            NSManagedObject *joke = [NSEntityDescription insertNewObjectForEntityForName:@"Joke" inManagedObjectContext:context];
            [joke setValue:jokeBody forKey:@"body"];
        }
        FTJokeDispenser *dispenser = [[FTJokeDispenser alloc] init];
        [dispenser showJoke];
        [context save:&error];
    }];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
    
    animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[self.imageViewCat]];
    gravity.magnitude = 0.01;
    gravity.angle = -M_E;
    [animator addBehavior:gravity];
    
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[self.imageViewCat]];
    [collision setTranslatesReferenceBoundsIntoBoundary:YES];
    [animator addBehavior:collision];
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
            FTJokeDispenser *dispenser = [[FTJokeDispenser alloc] init];
            [dispenser showJoke];
            [self startAsyncTask];
        });
    });
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
    NSString *message = @"This is Pets, a native iOS app developed for the Mobile Apps track of Telerik Academy 2014. \n If you have any suggestions/bug reports, you can contact us at: \n https://github.com/martin-dzhonov \n https://github.com/ssnaky";
    [FTUtils showAlert:@"Hi!" withMessage:message];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
