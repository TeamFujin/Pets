//
//  FTUtils.h
//  Pets
//
//  Created by Gosho Goshev on 11/5/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FTUtils : NSObject
+(void) showAlert: (NSString*) title
      withMessage: (NSString*) message;
+(NSString *)encodeToBase64String:(UIImage *)image;
+(UIImage *)decodeBase64ToImage:(NSString *)strEncodeData;
@end
