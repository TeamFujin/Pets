//
//  AddOfferViewController.m
//  Pets
//
//  Created by Gosho Goshev on 10/30/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import "AddOfferViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <CoreLocation/CoreLocation.h>

@interface AddOfferViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleTextInput;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextInput;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *sliderLabel;
@end

@implementation AddOfferViewController{
    NSString *currentLatitude;
    NSString *currentLongitude;
<<<<<<< HEAD
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    NSString* adress;
=======
>>>>>>> FETCH_HEAD
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadHardcodedImage];
    [self initializeLocationManager];
<<<<<<< HEAD
    geocoder = [[CLGeocoder alloc] init];
=======
>>>>>>> FETCH_HEAD
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
<<<<<<< HEAD
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

=======
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

>>>>>>> FETCH_HEAD
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        currentLongitude =[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        currentLatitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
<<<<<<< HEAD
    }
    NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            //NSString* adress = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                                 //placemark.subThoroughfare, placemark.thoroughfare,
                                // placemark.postalCode, placemark.locality,
                                /// placemark.administrativeArea,
                                // placemark.country];
            adress = placemark.subThoroughfare;
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
=======
        
    }
>>>>>>> FETCH_HEAD
    [self.locationManager stopUpdatingLocation];
}
- (IBAction)saveClicked:(id)sender {
    NSString *title = self.titleTextInput.text;
    NSString *description = self.descriptionTextInput.text;
    NSNumber *price = [NSNumber numberWithInteger:(int)self.slider.value];
    NSString *imageBase64 = [self encodeToBase64String:self.imageView.image];
    NSDictionary *offerDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                        title, @"title",
                        description, @"description",
                        price, @"price",
                        nil];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:offerDictionary
                                                       options:NSJSONWritingPrettyPrinted // pass 0 for non-formatted
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Error parsing JSON: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", jsonString);
        NSLog(@"%@", currentLongitude);
        NSLog(@"%@", currentLatitude);
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

- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}
- (void) showAlert: (NSString *) title withMessage: (NSString*) message{
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:title
                                                          message:message
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles: nil];
    
    [myAlertView show];
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
