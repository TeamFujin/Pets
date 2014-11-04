//
//  OfferDetailsViewController.h
//  Pets
//
//  Created by Gosho Goshev on 10/30/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Offer.h"

@interface OfferDetailsViewController : UIViewController
- (IBAction)actionWantPet:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (strong, nonatomic) Offer *offer;
@end
