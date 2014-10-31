//
//  ProfileViewController.m
//  Pets
//
//  Created by Gosho Goshev on 10/30/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import "ProfileViewController.h"
#import <FacebookSDK/FacebookSDK.h>
@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getPersonalInfo];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)logoutClicked:(id)sender {
    [FBSession.activeSession closeAndClearTokenInformation];
}

-(void)getPersonalInfo{
    [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *FBuser, NSError *error) {
        if (error) {
            // Handle error
        }

        else {
            NSString *userName = [FBuser name];
            NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [FBuser objectID]];
            NSString *email = [FBuser objectForKey:@"email"];
            NSString *fbUserID =[FBuser objectID];
            
            NSLog(@"%@", fbUserID);
            
            self.nameLabel.text = userName;
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:userImageURL]];
            self.profilePic.image = [UIImage imageWithData:imageData];
        }
    }];
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
