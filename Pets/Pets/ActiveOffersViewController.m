//
//  ActiveOffersViewController.m
//  Pets
//
//  Created by Gosho Goshev on 11/5/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import "ActiveOffersViewController.h"
#import "FTDatabaseRequester.h"
#import "FTUtils.h"
#import "Offer.h"

@interface ActiveOffersViewController ()

@end

@implementation ActiveOffersViewController{
    NSArray* recipes;
    FTDatabaseRequester* db;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    db = [[FTDatabaseRequester alloc] init];
    
    [db getActiveOffersForUser:[PFUser currentUser] andBlock:^(NSArray *offers, NSError *error) {
        if(!error) {
            recipes = [NSMutableArray arrayWithArray:offers];
              NSLog(@"%@", offers);
            [self.view setNeedsDisplay];
        } else {
            [FTUtils showAlert:@"Error" withMessage:@"Sorry, we couldn't retrieve your active offers."];
        }
    }];
//    recipes = [NSArray arrayWithObjects: @"Active offer", @"Active offer",@"Active offer",@"Active offer",@"Active offer",@"Active offer",@"Active offer",@"Active offer",@"Active offer",@"Active offer",@"Active offer",@"Active offer",@"Active offer",@"Active offer", nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [recipes count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    Offer *offer = [recipes objectAtIndex:indexPath.row];
    cell.textLabel.text = offer.title;
    NSLog(@"%@", offer.title);
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    //Get reference to receipt
//    Offer *offer = [data objectAtIndex:indexPath.row];
//    
//    OfferDetailsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"offerDetails"];
//    
//    // Pass data to controller
//    controller.offer = offer;
//    [self.navigationController pushViewController:controller animated:YES];
}
@end
