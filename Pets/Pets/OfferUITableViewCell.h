//
//  OfferUITableViewCell.h
//  Pets
//
//  Created by Gosho Goshev on 11/6/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfferUITableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *labelTItle;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@end
