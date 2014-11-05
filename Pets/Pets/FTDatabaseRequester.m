//
//  DatabaseRequester.m
//  Pets
//
//  Created by Admin on 11/3/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import "FTDatabaseRequester.h"

@implementation FTDatabaseRequester
-(void)addOfferToDbWithOffer: (Offer *) offer
                    andBlock: (void (^)(BOOL succeeded, NSError *error)) block{
    [offer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        block(succeeded, error);
    }];
}

-(void)getAllActiveOffersWithBlock: (void (^)(NSArray *objects, NSError *error)) block{
    PFQuery *query = [PFQuery queryWithClassName:Offer.parseClassName];
    [query selectKeys:@[@"title", @"price", @"picture"]];
    [query whereKey:@"active" equalTo:@YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        block(objects, error);
    }];
}

-(void)getDetailsForOffer: (Offer*) offer
                 andBlock: (void (^)(PFObject *object, NSError *error)) block{
    [offer fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        block(object, error);
    }];
}

-(void)addDealToDbWithDeal: (Deal *) deal
                    andBlock: (void (^)(BOOL succeeded, NSError *error)) block{
    [deal saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        block(succeeded, error);
    }];
}

@end
