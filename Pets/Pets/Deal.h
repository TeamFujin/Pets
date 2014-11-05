//
//  Deal.h
//  Pets
//
//  Created by Admin on 11/5/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import <Parse/Parse.h>

@interface Deal : PFObject<PFSubclassing>
@property (strong, nonatomic) PFObject *offerId;
@property (strong, nonatomic) PFObject *wanterId;
@property BOOL approved;
@property BOOL deleted;
+(NSString *)parseClassName;
@end
