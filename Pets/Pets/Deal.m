//
//  Deal.m
//  Pets
//
//  Created by Admin on 11/5/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import "Deal.h"

@implementation Deal
@dynamic  offerId;
@dynamic wanterId;
@dynamic approved;
@dynamic deleted;

+(void) load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return @"Deals";
}
@end
