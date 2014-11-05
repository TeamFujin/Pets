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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString *email = self.emailTextField.text;
    NSString *phone = self.phoneTextField.text;
    if([segue.identifier isEqualToString:@"AddInfoToProfile"]){
        ProfileViewController *toProfile = segue.destinationViewController;
        toProfile.email = email;
        toProfile.phone = phone;
    }
    
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
        [self showAlert:@"Error" withMessage:@"Invalid email"];
    }
    else if(! [self phoneIsValid:phone]){
        [self showAlert:@"Error" withMessage:@"Invalid phone number"];
    }
    else{
        PFUser *currUser = [PFUser currentUser];
        currUser.email = email;
        currUser[@"phone"] = phone;
        [currUser saveInBackground];
        [self performSegueWithIdentifier:@"AddInfoToProfile" sender:self];
    }
}

- (void) showAlert: (NSString *) title withMessage: (NSString*) message{
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:title
                                                          message:message
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles: nil];
    
    [myAlertView show];
}

@end
