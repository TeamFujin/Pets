//
//  DatabaseRequester.h
//  Pets
//
//  Created by Admin on 11/3/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Offer.h"
#import "Deal.h"

@interface FTDatabaseRequester : NSObject

-(void)addOfferToDbWithOffer: (Offer *) offer
                    andBlock: (void (^)(BOOL succeeded, NSError *error)) block;
-(void)getAllActiveOffersWithBlock: (void (^)(NSArray *objects, NSError *error)) block;
-(void)getDetailsForOffer: (Offer*) offer
                 andBlock: (void (^)(PFObject *object, NSError *error)) block;
-(void)addDealToDbWithDeal: (Deal *) deal
                  andBlock: (void (^)(BOOL succeeded, NSError *error)) block;
-(void)getApprovedBidsForUser: (PFObject*) userId
             andBlock: (void (^)(NSArray *bids, NSError *error)) block;
-(void)getPendingBidsForUser: (PFObject*) userId
                     andBlock: (void (^)(NSArray *bids, NSError *error)) block;
-(void)getRejectedBidsForUser: (PFObject*) userId
                     andBlock: (void (^)(NSArray *bids, NSError *error)) block;
-(void)getActiveOffersForUser:(PFObject*) user
                     andBlock:(void (^)(NSArray *offers, NSError *error)) block;
-(void)getInactiveOffersForUser:(PFObject*) user
                       andBlock:(void (^)(NSArray *offers, NSError *error)) block;
-(void)getOfferBidsForOffer: (PFObject*) offer
                   andBlock: (void (^)(NSArray *bids, NSError *error)) block;
-(void)getJokesWithBlock: (void (^)(NSArray *jokes, NSError *error)) block;
-(void)updateDealForApprovalWithDeal: (Deal*) deal
                   andBlock: (void (^)(BOOL succeeded, NSError *error)) block;
-(void)checkIfAlreadyAppliedForOffer: (NSString*) offerId
                             andUser: (NSString*) userId
                            andBlock: (void (^)(NSArray *deals, NSError *error)) block;
@end
