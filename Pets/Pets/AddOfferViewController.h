//
//  AddOfferViewController.h
//  Pets
//
//  Created by Gosho Goshev on 10/30/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import <UIKit/UIKit.h>
<<<<<<< Updated upstream
#import <CoreLocation/CoreLocation.h>
@interface AddOfferViewController : UIViewController<CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property CLLocationManager *locationManager;
=======

@interface AddOfferViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate,
    UITextFieldDelegate>

>>>>>>> Stashed changes
@end
