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
#import "FTSpinner.h"

@interface OfferDetailsViewController ()
@end

@implementation OfferDetailsViewController{
    FTDatabaseRequester *db;
}

- (void)viewDidLoad {
    self.title = @"Pet Details";
    [super viewDidLoad];
    db = [[FTDatabaseRequester alloc] init];
    [self configureView];
}

- (void)setOffer:(id)newOffer {
    if (_offer != newOffer) {
        _offer = newOffer;
        [self configureView];
    }
}

- (void)configureView {
    //  NSLog(@"configureView offer: %@", self.offer);
    if (self.offer) {
        FTSpinner *spinner = [[FTSpinner alloc] initWithView:self.view andSize:70 andScale:2.5f];
        [spinner startSpinning];
        [db getDetailsForOffer:self.offer andBlock:^(PFObject *object, NSError *error) {
            [spinner stopSpinning];
            if(!error) {
                self.offer = (Offer*) object;
                [self.offer.userId fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                    PFUser *author = (PFUser *)[self.offer.userId fetchIfNeeded];
                    self.labelAuthorName.text = author[@"displayName"];
                }];
                self.labelTitle.text = self.offer.title;
                self.labelDesc.text = self.offer.desc;
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"dd.MM.yyyy HH:MM:SS"];
                self.labelPublished.text = [formatter stringFromDate:self.offer.createdAt];
                if ([self.offer.price isEqual:@0]) {
                    self.labelPrice.text = @"FREE";
                }
                else{
                    self.labelPrice.text = [NSString stringWithFormat:@"%@BGN", self.offer.price];
                }
                
                if(self.offer.photo) {
                    NSData *data = [self.offer.photo getData];//[[NSData alloc]initWithBase64EncodedString:offer.picture options:NSDataBase64DecodingIgnoreUnknownCharacters];
                    self.imageViewPicture.image = [UIImage imageWithData:data ];
                } else {
                    self.imageViewPicture.image = nil;
                }

                
            } else {
                [FTUtils showAlert:@"We are sorry" withMessage:@"Unfortunatelly, we can't show you this pet's details right now"];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)actionWantPet:(id)sender {
    // NSLog(@"self.offer.userId : %@", self.offer.userId );
    // NSLog(@"[PFUser currentUser].objectId: %@", [PFUser currentUser].objectId );
    NSString *userId = self.offer.userId.objectId;
    NSString *offerId = self.offer.objectId;
    NSString *currUserId = [PFUser currentUser].objectId;
    //  NSLog(@"offerId: %@", offerId);
    // NSLog(@"userId: %@", userId);
    //
    //    NSLog(@"deals: %@", deals);
    //    if(!error) {
    //        if(deals.count > 0) {
    //            didApply = 1;
    //        }
    //    }
    if(!([currUserId isEqual:userId])) {
        [db checkIfAlreadyAppliedForOffer:offerId andUser:currUserId andBlock:^(NSArray *deals, NSError *error) {
            if(!error) {
                NSLog(@"deals: %@", deals);
                if(!(deals.count > 0)) {
                    Deal *deal = [[Deal alloc] init];
                    deal.wanterId = [PFUser currentUser];
                    deal.offerId = self.offer;
                    deal.approved = NO;
                    deal.deleted = NO;
                    
                    [db addDealToDbWithDeal:deal andBlock:^(BOOL succeeded, NSError *error) {
                        if(succeeded) {
                            [FTUtils showAlert:@"Success" withMessage:@"You can start checking for approval"];
                        } else {
                            [FTUtils showAlert:@"We are sorry" withMessage:@"Unfortunatelly, you couldn't get this pet..."];
                            NSLog(@"Error: %@", error);
                        }
                    }];
                } else {
                    [FTUtils showAlert:@"Already applied" withMessage:@"You can go check if you're approved"];
                }
            } else {
                [FTUtils showAlert:@"We are sorry" withMessage:@"Something went wrong. Check your internet connection."];
            }
        }];
    } else {
        [FTUtils showAlert:@"This is your pet...for now" withMessage:@"You published this pet offer, remember?"];
    }
}
@end
