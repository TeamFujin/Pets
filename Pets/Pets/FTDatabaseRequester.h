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
@end
