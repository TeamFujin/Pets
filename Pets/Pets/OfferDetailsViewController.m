//
//  OfferDetailsViewController.m
//  Pets
//
//  Created by Gosho Goshev on 10/30/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import "OfferDetailsViewController.h"
#import "FTDatabaseRequester.h"
#import "Deal.h"

@interface OfferDetailsViewController ()
@property (strong, nonatomic) FTDatabaseRequester *databaseRequester;
@end

@implementation OfferDetailsViewController

- (void)setOffer:(id)newOffer {
    if (_offer != newOffer) {
        _offer = newOffer;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.offer) {
        
        [self.databaseRequester getDetailsForOffer:self.offer andBlock:^(PFObject *object, NSError *error) {
            self.offer = (Offer*) object;
            self.labelTitle.text = self.offer.title;
            self.labelDesc.text = self.offer.desc;
            self.labelPrice.text = [NSString stringWithFormat:@"%@BGN", self.offer.price];
            //TODO: make a class for decoding too
            NSData *data = [[NSData alloc]initWithBase64EncodedString:self.offer.picture options:NSDataBase64DecodingIgnoreUnknownCharacters];
            self.imageViewPicture.image = [UIImage imageWithData:data];
            
            NSLog(@"Offer name: %@", self.offer.title);
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.databaseRequester = [[FTDatabaseRequester alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
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

- (IBAction)actionWantPet:(id)sender {
    Deal *deal = [[Deal alloc] init];
    deal.wanterId = @"testId";
    deal.offerId = self.offer.objectId;
    deal.approved = NO;
    deal.deleted = NO;
    //TODO: check if user already pressed the button
    [self.databaseRequester addDealToDbWithDeal:deal andBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded) {
            //TODO use the future class for alert making!!!
            [self showAlert:@"Success" withMessage:@"You can start checking for approval"];
        } else {
            [self showAlert:@"We are sorry" withMessage:@"Unfortunatelly, you couldn't get this pet..."];
            NSLog(@"Errorr: %@", error);
        }
    }];
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
