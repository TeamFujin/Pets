//
//  OfferUITableViewCell.h
//  Pets
//
//  Created by Gosho Goshev on 11/6/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfferUITableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *image;
@property (weak, nonatomic) IBOutlet UIView *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *authorNameLabel;
@property (weak, nonatomic) IBOutlet UIView *authorEmailLabel;
@property (weak, nonatomic) IBOutlet UIView *authorPhoneLabel;

@end
