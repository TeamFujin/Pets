//
//  AddContactInfoViewController.m
//  Pets
//
//  Created by Gosho Goshev on 11/1/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import "AddContactInfoViewController.h"
#import "ProfileViewController.h"
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

@end
