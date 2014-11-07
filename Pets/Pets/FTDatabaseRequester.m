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

-(void)getApprovedBidsForUser: (PFObject*) userId
             andBlock: (void (^)(NSArray *bids, NSError *error)) block{
    [self getBidsForUser:userId andApproved:@YES andDeleted:@NO andBlock:block];
}

-(void)getPendingBidsForUser: (PFObject*) userId
                    andBlock: (void (^)(NSArray *bids, NSError *error)) block{
    [self getBidsForUser:userId andApproved:@NO andDeleted:@NO andBlock:block];
}
-(void)getRejectedBidsForUser: (PFObject*) userId
                     andBlock: (void (^)(NSArray *bids, NSError *error)) block{
    [self getBidsForUser:userId andApproved:@NO andDeleted:@YES andBlock:block];
}

-(void)getActiveOffersForUser:(PFObject*) user
                     andBlock:(void (^)(NSArray *offers, NSError *error)) block{
//    PFQuery *query = [PFQuery queryWithClassName:[Offer parseClassName]];
//    [query whereKey:@"userId" equalTo:user];
//    [query whereKey:@"active" equalTo:@YES];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *offers, NSError *error) {
//        block(offers, error);
//    }];
    [self getOffersForUser:user andActive:@YES andBlock:block];
}

-(void)getInactiveOffersForUser:(PFObject*) user
                     andBlock:(void (^)(NSArray *offers, NSError *error)) block{
    [self getOffersForUser:user andActive:@NO andBlock:block];
}

-(void)getOfferBidsForOffer: (PFObject*) offer
                     andBlock: (void (^)(NSArray *bids, NSError *error)) block{
    PFQuery *query = [PFQuery queryWithClassName:[Deal parseClassName]];
    [query whereKey:@"offerId" equalTo:offer];
    [query whereKey:@"deleted" equalTo:@NO];
    [query includeKey:@"wanterId"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *bids, NSError *error) {
        block(bids, error);
    }];

}

-(void)getOffersForUser:(PFObject*) user
              andActive: (id) active
               andBlock:(void (^)(NSArray *offers, NSError *error)) block{
    PFQuery *query = [PFQuery queryWithClassName:[Offer parseClassName]];
    [query whereKey:@"userId" equalTo:user];
    [query whereKey:@"active" equalTo:active];
    [query findObjectsInBackgroundWithBlock:^(NSArray *offers, NSError *error) {
        block(offers, error);
    }];
}


-(void)getBidsForUser: (PFObject*) userId
          andApproved: (id) approved
           andDeleted: (id) deleted
             andBlock: (void (^)(NSArray *bids, NSError *error)) block{
    PFQuery *query = [PFQuery queryWithClassName:[Deal parseClassName]];
    [query whereKey:@"wanterId" equalTo:userId];
    [query whereKey:@"approved" equalTo:approved];
    if([approved isEqualToValue:@NO]) {
        [query whereKey:@"deleted" equalTo:deleted];
    }
    
    [query includeKey:@"offerId"];
    [query includeKey:@"wanterId"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *bids, NSError *error) {
        block(bids, error);
    }];
}
@end
