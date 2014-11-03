//
//  DatabaseRequester.h
//  Pets
//
//  Created by Admin on 11/3/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Offer.h"

@interface DatabaseRequester : NSObject
-(void)addOfferToDbWithOffer: (Offer *) offer
                    andBlock: (void (^)(BOOL succeeded, NSError *error)) block;
-(void)getAllActiveOffersWithBlock: (void (^)(NSArray *objects, NSError *error)) block;
@end
