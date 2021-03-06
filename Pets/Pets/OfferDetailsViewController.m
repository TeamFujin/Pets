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
        __weak OfferDetailsViewController *weakSelf = self;
        [db getDetailsForOffer:self.offer andBlock:^(PFObject *object, NSError *error) {
            [spinner stopSpinning];
            if(!error) {
                weakSelf.offer = (Offer*) object;
                [weakSelf.offer.userId fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                    [self.offer.userId fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                        weakSelf.labelAuthorName.text = object[@"displayName"];
                    }];
                }];
                weakSelf.labelTitle.text = self.offer.title;
                weakSelf.labelDesc.text = self.offer.desc;
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"dd.MM.yyyy HH:MM:SS"];
                weakSelf.labelPublished.text = [formatter stringFromDate:self.offer.createdAt];
                if ([weakSelf.offer.price isEqual:@0]) {
                    weakSelf.labelPrice.text = @"FREE";
                }
                else{
                    weakSelf.labelPrice.text = [NSString stringWithFormat:@"%@BGN", self.offer.price];
                }
                
                if(weakSelf.offer.photo) {
                    [weakSelf.offer.photo getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                        weakSelf.imageViewPicture.image = [UIImage imageWithData:data ];
                    }];
                } else {
                    weakSelf.imageViewPicture.image = nil;
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
    NSString *userId = self.offer.userId.objectId;
    NSString *offerId = self.offer.objectId;
    NSString *currUserId = [PFUser currentUser].objectId;

    if(!([currUserId isEqual:userId])) {
        [db checkIfAlreadyAppliedForOffer:offerId andUser:currUserId andBlock:^(NSArray *deals, NSError *error) {
            if(!error) {
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
