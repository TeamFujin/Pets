//
//  AddOfferViewController.m
//  Pets
//
//  Created by Gosho Goshev on 10/30/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import "AddOfferViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import "Offer.h"
#import "FTDatabaseRequester.h"
#import "FTUtils.h"
#import "AddOfferViewController.h"

@interface AddOfferViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleTextInput;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextInput;
@property (weak, nonatomic) IBOutlet UITextField *priceTextInput;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation AddOfferViewController{
    float currentLatitude;
    float currentLongitude;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    NSString* adress;
}

- (void)viewDidLoad {
    self.title = @"Add New Pet";
    [super viewDidLoad];
    [self initializeLocationManager];
    geocoder = [[CLGeocoder alloc] init];
    self.titleTextInput.delegate = self;
    self.descriptionTextInput.delegate = self;
    
    //UIImage *image = self.imageView.image;
    int r = arc4random() % 6;
    NSString *index = [NSString stringWithFormat:@"%d", r];
    NSString *imgName = [NSString stringWithFormat:@"%@%@%@", @"pet", index, @".jpg"];
    UIImage *image = [UIImage imageNamed:imgName];
    UIGraphicsBeginImageContext(CGSizeMake(200, 200));
    [image drawInRect: CGRectMake(0, 0, 200, 200)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.imageView.image = smallImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)takePhoto:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [FTUtils showAlert:@"We are sorry" withMessage:@"Your device has no camera"];
    } else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

- (IBAction)selectPhoto:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [FTUtils showAlert:@"We are sorry" withMessage:@"Your source isn't available"];
    } else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)addLocationTaped:(id)sender {
    [self.locationManager startUpdatingLocation];
    [self.locationManager requestWhenInUseAuthorization];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    [FTUtils showAlert:@"We are sorry" withMessage:@"Failed to get your location"];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    //get coordinates
    if (currentLocation != nil) {
        currentLongitude = currentLocation.coordinate.longitude;
        currentLatitude = currentLocation.coordinate.latitude;
    }
    //get adress
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            adress = placemark.thoroughfare;
            [FTUtils showAlert:@"Location included." withMessage:adress];
        } else {
            NSLog(@"didUpdateToLocation%@", error.debugDescription);
        }
    } ];
    [self.locationManager stopUpdatingLocation];
}
- (IBAction)saveClicked:(id)sender {
    if ([self validateOffer]) {
        NSString *title = self.titleTextInput.text;
        NSString *description = self.descriptionTextInput.text;
        NSNumber *price = [NSNumber numberWithInt: [self.priceTextInput.text intValue]];
        UIImage *image = self.imageView.image;
        
        Offer *offer = [[Offer alloc] init];
        offer.userId = [PFUser currentUser];
        offer.title = title;
        offer.desc = description;
        offer.price = price;
        offer.active = YES;
        offer.location.longitude = currentLongitude;
        offer.location.latitude = currentLatitude;
        offer.address = adress;
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.05f);
        PFFile *imageFile = [PFFile fileWithData:imageData];
        offer.photo = imageFile;
        if([FTUtils isConnectionAvailable]){
            
            
            FTDatabaseRequester *db = [[FTDatabaseRequester alloc] init];
            [db addOfferToDbWithOffer:offer andBlock:^(BOOL succeeded, NSError *error) {
                if(succeeded) {
                    [FTUtils showAlert:@"Success" withMessage:@"Your offer has been published!"];
                    AddOfferViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeTableViewController"];
                    
                    [self.navigationController pushViewController:controller animated:YES];
                } else {
                    [FTUtils showAlert:@"We are sorry" withMessage:@"Your offer could not be published!"];
                    NSLog(@"Errorr: %@", error);
                }
            }];
        }
        else{
            [FTUtils showAlert:@"Error" withMessage:@"No internet connection"];
        }
    }
}

-(void)initializeLocationManager
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    
}
-(bool) validateOffer{
    NSString *title = self.titleTextInput.text;
    NSString *price = self.priceTextInput.text;
    NSString *desc = self.descriptionTextInput.text;
    
    if(title.length == 0){
        [FTUtils showAlert:@"Wrong input" withMessage:@"Title is required"];
        return false;
    }
    if(desc.length > 100){
        [FTUtils showAlert:@"Wrong input" withMessage:@"Description too long"];
        return  false;
    }
    if(price.length == 0 || ![self validatePrice:price]){
        [FTUtils showAlert:@"Wrong input" withMessage:@"Price in invalid"];
        return false;
    }
    return true;
}
-(BOOL) validatePrice: (NSString *) number{
    NSString *regex = @"[0-9]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL match = [predicate evaluateWithObject:number];
    return match;
}

@end
