//
//  Offer.h
//  Pets
//
//  Created by Admin on 11/2/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import <Parse/Parse.h>

@interface Offer : PFObject<PFSubclassing>
@property (nonatomic, strong) PFObject *userId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSString *picture;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) PFGeoPoint *location;
@property (nonatomic, strong) PFFile *photo;
@property BOOL active;

+(NSString *)parseClassName;
@end
