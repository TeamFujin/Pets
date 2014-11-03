//
//  HomewUITableViewCell.h
//  Pets
//
//  Created by Admin on 11/3/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeUITableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPicture;
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
