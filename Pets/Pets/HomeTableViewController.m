//
//  HomeTableViewController.m
//  Pets
//
//  Created by Gosho Goshev on 10/30/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import "HomeTableViewController.h"
#import "HomeUITableViewCell.h"
#import "DatabaseRequester.h"
#import "Offer.h"

@interface HomeTableViewController ()

@end

@implementation HomeTableViewController

static NSInteger count = 0;
static NSMutableArray *data;
static NSInteger rowHeight = 100;
static NSString *cellIdentifier = @"HomeUITableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    DatabaseRequester *db = [[DatabaseRequester alloc] init];
//TODO: put the spinner in a seperate class
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0,0,100,100)];
    CGAffineTransform transform = CGAffineTransformMakeScale(3.5f, 3.5f);
    spinner.transform = transform;
    spinner.color = [UIColor blueColor];
    spinner.center = self.view.center;
    [spinner startAnimating];
    [self.tableView addSubview:spinner];
    
    [db getAllActiveOffersWithBlock:^(NSArray *objects, NSError *error) {
        [spinner removeFromSuperview];
        if(!error) {
            count = objects.count;
            data = [NSMutableArray arrayWithArray:objects];
            NSLog(@"%@", objects);
            [self.tableView reloadData];
        } else {
              [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry, but we could not retrieve the offers!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
    }];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeUITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    Offer *offer = data[indexPath.row];
    cell.labelTitle.text = offer.title;
    cell.labelPrice.text = [NSString stringWithFormat:@"Price: #%@BGN", offer.price];
    if(offer.picture) {
        NSData *data = [[NSData alloc]initWithBase64EncodedString:offer.picture options:NSDataBase64DecodingIgnoreUnknownCharacters];
        cell.imageViewPicture.image = [UIImage imageWithData:data];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return rowHeight;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
