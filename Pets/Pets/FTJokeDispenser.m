//
//  FTJokeDispenser.m
//  Pets
//
//  Created by Gosho Goshev on 11/6/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import "FTJokeDispenser.h"
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "FTDatabaseRequester.h"
@implementation FTJokeDispenser

- (void) showJoke{
    NSString *title = @"Looks like you lost internet connection, here's a joke:";
    NSString *joke = [self getRandomJoke];
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:title
                                                          message:joke
                                                         delegate:self
                                                cancelButtonTitle:@"Haha, good one !"
                                                otherButtonTitles: nil];
    [myAlertView show];
}

- (void) saveJokesToCoreData{
    NSManagedObjectContext *context = [self managedObjectContext];
    FTDatabaseRequester *db = [[FTDatabaseRequester alloc] init];
    
    [db getJokesWithBlock:^(NSArray *objects, NSError *error) {
        for (NSDictionary *obj in objects) {
            NSString *jokeBody = [obj objectForKey:@"Joke"];
            NSManagedObject *joke = [NSEntityDescription insertNewObjectForEntityForName:@"Joke" inManagedObjectContext:context];
            [joke setValue:jokeBody forKey:@"body"];
        }
    }];
}

- (NSString *) getRandomJoke{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Joke"];
    NSMutableArray *jokes = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    int r = arc4random() % jokes.count;
    NSManagedObject *loadedJoke = [jokes objectAtIndex:r];
    return [loadedJoke valueForKey:@"body"];
}
- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
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
- (NSString *) getRandomJoke2{
    NSArray* jokes = [NSArray arrayWithObjects: @"I didn't know my dad was a construction site thief, but when I got home all the signs were there" , @"My grandfather had the heart of a Lion and a lifetime ban from the Central Park Zoo", nil];
    int r = arc4random() % jokes.count;
    return [jokes objectAtIndex:r];
}

@end
