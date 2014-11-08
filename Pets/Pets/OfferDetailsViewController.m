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
#import "FTUtils.h"

@interface OfferDetailsViewController ()
@end

@implementation OfferDetailsViewController{
    FTDatabaseRequester *db;
}

- (void)viewDidLoad {
    self.title = @"Details";
    [super viewDidLoad];
    db = [[FTDatabaseRequester alloc] init];
    NSLog(@"viewDidLoad before calling configureView");
    [self configureView];
    NSLog(@"viewDidLoad after calling configureView");
}

- (void)setOffer:(id)newOffer {
    if (_offer != newOffer) {
        _offer = newOffer;
        // Update the view.
        NSLog(@"setOffer before calling configureView");
        [self configureView];
        NSLog(@"setOffer after calling configureView");
    }
}

- (void)configureView {
  //  NSLog(@"configureView offer: %@", self.offer);
    if (self.offer) {
        NSLog(@"in if before query");
        [db getDetailsForOffer:self.offer andBlock:^(PFObject *object, NSError *error) {
            if(!error) {
            self.offer = (Offer*) object;
            self.labelTitle.text = self.offer.title;
            self.labelDesc.text = self.offer.desc;
            self.labelPrice.text = [NSString stringWithFormat:@"%@BGN", self.offer.price];
            //TODO: make a class for decoding too
            NSData *data = [[NSData alloc]initWithBase64EncodedString:self.offer.picture options:NSDataBase64DecodingIgnoreUnknownCharacters];
            self.imageViewPicture.image = [UIImage imageWithData:data];
            
            NSLog(@"Offer name: %@", self.offer.title);
            } else {
                [FTUtils showAlert:@"We are sorry" withMessage:@"Unfortunatelly, we can't show you this pet's details right now"];
            }
        }];
        NSLog(@"in if after query");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)actionWantPet:(id)sender {
    Deal *deal = [[Deal alloc] init];
    deal.wanterId = [PFUser currentUser];
    deal.offerId = [PFObject objectWithoutDataWithClassName:[Offer parseClassName] objectId:self.offer.objectId];
    deal.approved = NO;
    deal.deleted = NO;
    //TODO: check if you are not the owner of this offer

    //TODO: check if user already pressed the button
    [db addDealToDbWithDeal:deal andBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded) {
            [FTUtils showAlert:@"Success" withMessage:@"You can start checking for approval"];
        } else {
            [FTUtils showAlert:@"We are sorry" withMessage:@"Unfortunatelly, you couldn't get this pet..."];
            NSLog(@"Error: %@", error);
        }
    }];
}
@end
