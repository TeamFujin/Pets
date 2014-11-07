//
//  ProfileViewController.m
//  Pets
//
//  Created by Gosho Goshev on 10/30/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import "ProfileViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FTUtils.h"
#import <Parse/Parse.h>
#import "FTSpinner.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    self.title = @"Profile";
    [super viewDidLoad];
    [self getPersonalInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)logoutClicked:(id)sender {
    [FBSession.activeSession closeAndClearTokenInformation];
    [PFUser logOut];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)getPersonalInfo{
    FTSpinner *spinner = [[FTSpinner alloc] initWithView:self.view andSize:70 andScale:2.5f];
    [spinner startSpinning];
    [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *FBuser, NSError *error) {
        if (error) {
            [FTUtils showAlert:@"Error" withMessage:@"Couldn't fetch your Facebook profile"];
        }
        else {
            NSString *userName = [FBuser name];
            self.nameLabel.text = userName;
            
            NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [FBuser objectID]];
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:userImageURL]];
            self.profilePic.image = [UIImage imageWithData:imageData];
            [spinner stopSpinning];
        }
    }];
    PFUser *currUser = [PFUser currentUser];
    self.emailLabel.text =  currUser.email;
    self.phoneLabel.text =  currUser[@"phone"];
}

@end
