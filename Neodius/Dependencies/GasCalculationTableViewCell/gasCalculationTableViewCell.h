//
//  gasCalculationTableViewCell.h
//  Neodius
//
//  Created by Benjamin de Bos on 27-09-17.
//  Copyright © 2017 ITS-VIsion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "neodiusDataSource.h"

@interface gasCalculationTableViewCell : UITableViewCell
@property (strong, nonatomic) UILabel *label1;
@property (strong, nonatomic) UILabel *label2;
@property (strong, nonatomic) UILabel *label3;
-(void)isHeaderCell;
@end
