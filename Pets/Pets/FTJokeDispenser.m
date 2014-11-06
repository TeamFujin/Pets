//
//  FTJokeDispenser.m
//  Pets
//
//  Created by Gosho Goshev on 11/6/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import "FTJokeDispenser.h"
#import <UIKit/UIKit.h>
@implementation FTJokeDispenser

+ (void) showJoke{
    NSString *title = @"Looks like you lost internet connection, here's a joke:";
    NSString *joke = [self getRandomJoke];
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:title
                                                          message:joke
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:@"asdf", nil];
    [myAlertView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"asdf"])
    {
        NSLog(@"Button 1 was selected.");
    }
    else if([title isEqualToString:@"Button 2"])
    {
        NSLog(@"Button 2 was selected.");
    }
    else if([title isEqualToString:@"Button 3"])
    {
        NSLog(@"Button 3 was selected.");
    }
}
+ (NSString *) getRandomJoke{
    NSArray* jokes = [NSArray arrayWithObjects: @"I didn't know my dad was a construction site thief, but when I got home all the signs were there" , @"My grandfather had the heart of a Lion and a lifetime ban from the Central Park Zoo", nil];
    int r = arc4random() % jokes.count;
    return [jokes objectAtIndex:r];
}

@end
