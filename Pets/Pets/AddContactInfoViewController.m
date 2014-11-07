//
//  AddContactInfoViewController.m
//  Pets
//
//  Created by Gosho Goshev on 11/1/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import "AddContactInfoViewController.h"
#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import "FTUtils.h"
#import <FacebookSDK/FacebookSDK.h>
@interface AddContactInfoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@end

@implementation AddContactInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) emailIsValid: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}
-(BOOL) phoneIsValid: (NSString*) candidate{
    NSString *phoneRegex = @"[0123456789][0-9]{6}([0-9]{3})?";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:candidate];
}

- (IBAction)continueClicked:(id)sender {
    NSString *email = self.emailTextField.text;
    NSString *phone = self.phoneTextField.text;
    if(![self emailIsValid:email]){
        [FTUtils showAlert:@"Error" withMessage:@"Invalid email"];
    }
    else if(! [self phoneIsValid:phone]){
        [FTUtils showAlert:@"Error" withMessage:@"Invalid phone number"];
    }
    else{
        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *FBuser, NSError *error) {
            if (error) {
            }
            else {
                NSString *userName = [FBuser name];
                PFUser *currUser = [PFUser currentUser];
                currUser[@"displayName"] = userName;
                currUser[@"facebookId"] = FBuser.objectID;
                [currUser saveInBackground];
            }
        }];
        PFUser *currUser = [PFUser currentUser];
        currUser.email = email;
        currUser[@"phone"] = phone;
         //currUser[@"displayName"] = fbName;
        [currUser saveInBackground];
        [self performSegueWithIdentifier:@"ContactInfoToProfile" sender:self];
    }
}

@end
