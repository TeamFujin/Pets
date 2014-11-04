//
//  Offer.h
//  Pets
//
//  Created by Admin on 11/2/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import <Parse/Parse.h>

@interface Offer : PFObject<PFSubclassing>
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSString *picture;
@property BOOL active;

+(NSString *)parseClassName;
@end
