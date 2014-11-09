//
//  Offer.m
//  Pets
//
//  Created by Admin on 11/2/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import "Offer.h"

@implementation Offer
@dynamic userId;
@dynamic title;
@dynamic desc;
@dynamic price;
@dynamic picture;
@dynamic active;
@dynamic address;
@dynamic location;
@dynamic photo;

+(void) load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return @"Offers";
}
@end
