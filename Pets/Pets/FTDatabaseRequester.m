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
    //TODO sort them by date
    PFQuery *query = [PFQuery queryWithClassName:Offer.parseClassName];
    [query selectKeys:@[@"title", @"price", @"picture", @"userId", @"photo"]];
   // [query includeKey:@"photo"];
    [query whereKey:@"active" equalTo:@YES];
    [query orderByDescending:@"createdAt"];
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

-(void)getJokesWithBlock: (void (^)(NSArray *jokes, NSError *error)) block{
    PFQuery *query = [PFQuery queryWithClassName:@"Jokes"];
    [query selectKeys:@[@"Joke"]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *jokes, NSError *error) {
        block(jokes, error);
    }];
}

-(void)updateDealForApprovalWithDeal: (Deal*) deal
          andBlock: (void (^)(BOOL succeeded, NSError *error)) block{
    deal.approved = @YES;
    deal.offerId.active = 0;
    [deal saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        block(succeeded, error);
    }];
}

-(void)checkIfAlreadyAppliedForOffer: (NSString*) offerId
                             andUser: (NSString*) userId
                            andBlock: (void (^)(NSArray *deals, NSError *error)) block{
    PFQuery *query = [PFQuery queryWithClassName:[Deal parseClassName]];
    [query whereKey:@"offerId" equalTo:[PFObject objectWithoutDataWithClassName:[Offer parseClassName] objectId:offerId]];
    [query whereKey:@"wanterId" equalTo:[PFObject objectWithoutDataWithClassName:[PFUser parseClassName] objectId:userId]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *deals, NSError *error) {
        block(deals, error);
    }];
}

//Private methods
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
