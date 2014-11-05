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

@interface AddOfferViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleTextInput;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextInput;
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
        [self showAlert:@"Error" withMessage:@"Device has no camera"];
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
        [self showAlert:@"Error" withMessage:@"Device has no camera"];
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
    [self.locationManager requestWhenInUseAuthorization]; // Add this Line
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        currentLongitude = currentLocation.coordinate.longitude;//[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        currentLatitude = currentLocation.coordinate.latitude;//[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        
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
    NSString *title = self.titleTextInput.text;
    NSString *description = self.descriptionTextInput.text;
    NSNumber *price = [NSNumber numberWithInteger:(int)self.slider.value];
    UIImage *image = self.imageView.image;
//    UIGraphicsBeginImageContext(CGSizeMake(200, 200));
//    [image drawInRect: CGRectMake(0, 0, 200, 200)];
//    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    NSString *imageBase64 = [self encodeToBase64String:image];
    Offer *offer = [[Offer alloc] init];
    offer.userId = [PFUser currentUser];
    offer.title = title;
    offer.desc = description;
    offer.price = price;
    offer.active = YES;
#warning do something about the stupid size
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
            [self showAlert:@"Success" withMessage:@"Your offer has been published!"];
        } else {
            [self showAlert:@"Success" withMessage:@"Sorry, your offer could not be published!"];
            NSLog(@"Errorr: %@", error);
        }
    }];
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

- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

//TODO: add this to a seperate class
- (void) showAlert: (NSString *) title withMessage: (NSString*) message{
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:title
                                                          message:message
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles: nil];
    
    [myAlertView show];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
