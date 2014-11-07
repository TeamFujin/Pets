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

@interface AddOfferViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleTextInput;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextInput;
@property (weak, nonatomic) IBOutlet UITextField *priceTextInput;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *sliderLabel;
@end

@implementation AddOfferViewController{
    float currentLatitude;
    float currentLongitude;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    NSString* adress;
}

- (void)viewDidLoad {
    self.title = @"Add Offer";
    [super viewDidLoad];
    [self loadHardcodedImage];
    [self initializeLocationManager];
    geocoder = [[CLGeocoder alloc] init];
    self.titleTextInput.delegate = self;
    self.descriptionTextInput.delegate = self;
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.ultimamusic.com.au/wp-content/uploads/2014/01/1562-cute-little-cat-200x200.jpg"]]];//@"http://i.imgur.com/4ciIEEe.jpg"]]];
    
    self.imageView.image = image;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)sliderChanged:(id)sender {
    NSString *price =[NSString stringWithFormat:@"%@ BGN", [[NSNumber numberWithInteger:(int)self.slider.value] stringValue]];
    self.sliderLabel.text = price;
}

- (IBAction)takePhoto:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [FTUtils showAlert:@"Error" withMessage:@"Device has no camera"];
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
        [FTUtils showAlert:@"Error" withMessage:@"Device has no camera"];
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
    [FTUtils showAlert:@"Error" withMessage:@"Failed to get your location"];
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
            //placemark.subThoroughfare, placemark.thoroughfare, placemark.postalCode, placemark.locality, placemark.administrativeArea, placemark.country
            adress = placemark.thoroughfare;
            NSLog(@"%@", placemark.thoroughfare);
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
    NSNumber *price = [NSNumber numberWithInteger:(int)self.slider.value];
    UIImage *image = self.imageView.image;
//    UIGraphicsBeginImageContext(CGSizeMake(200, 200));
//    [image drawInRect: CGRectMake(0, 0, 200, 200)];
//    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    NSString *imageBase64 = [FTUtils encodeToBase64String:image];
    Offer *offer = [[Offer alloc] init];
    offer.userId = [PFUser currentUser];
    offer.title = title;
    offer.desc = description;
    offer.price = price;
    offer.active = YES;
    offer.picture = imageBase64;
    offer.location.longitude = currentLongitude;
    offer.location.latitude = currentLatitude;
    offer.address = adress;
    
 //   NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 0.05f);
  //  PFFile *imageFile = [PFFile fileWithData:imageData];
  //  offer.picture = imageFile;
    FTDatabaseRequester *db = [[FTDatabaseRequester alloc] init];
    [db addOfferToDbWithOffer:offer andBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded) {
            [FTUtils showAlert:@"Success" withMessage:@"Your offer has been published!"];
        } else {
            [FTUtils showAlert:@"Success" withMessage:@"Sorry, your offer could not be published!"];
            NSLog(@"Errorr: %@", error);
        }
    }];
    }
}

-(void)loadHardcodedImage{
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://i.imgur.com/4ciIEEe.jpg"]]];
    self.imageView.image = image;
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

    if(title.length == 0){
        [FTUtils showAlert:@"Error" withMessage:@"Title is required"];
        return false;
    }
    if(price.length == 0 || ![self validatePrice:price]){
        [FTUtils showAlert:@"Error" withMessage:@"Price in invalid"];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
