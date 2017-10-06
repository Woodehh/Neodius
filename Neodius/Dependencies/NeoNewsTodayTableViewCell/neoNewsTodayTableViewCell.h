//
//  neoNewsTodayTableViewCell.h
//  Neodius
//
//  Created by Benjamin de Bos on 05-10-17.
//  Copyright © 2017 ITS-VIsion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "neodiusDataSource.h"
#import "neodiusUIComponents.h"
#import <UIImageViewAligned/UIImageViewAligned.h>
#import "EXPhotoViewer.h"


@interface neoNewsTodayTableViewCell : UITableViewCell
@property (nonatomic,retain) UILabel *titleLabel,*categoryLabel,*descriptionLabel;
@property (nonatomic,retain) UIImageViewAligned *headerImage;

@end
