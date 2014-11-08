//
//  WebFacebookViewController.h
//  Pets
//
//  Created by Admin on 11/8/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebFacebookViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webViewFacebook;
@property (strong, nonatomic) NSString *facebookId;
@end
