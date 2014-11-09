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

@property (weak, nonatomic) IBOutlet UIImageView *imageViewPicture;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelDesc;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelAuthorName;
@property (weak, nonatomic) IBOutlet UILabel *labelPublished;
@property (strong, nonatomic) Offer *offer;
- (IBAction)actionWantPet:(id)sender;

@end
