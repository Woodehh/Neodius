//
//  neoNewsTodayTableViewCell.h
//  Nodius
//
//  Created by Benjamin de Bos on 05-10-17.
//  Copyright © 2017 ITS-VIsion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AsyncImageView/AsyncImageView.h>
#import "nodiusDataSource.h"
#import "nodiusUIComponents.h"
#import "EXPhotoViewer.h"


@interface neoNewsTodayTableViewCell : UITableViewCell
@property (nonatomic,retain) UILabel *titleLabel,*categoryLabel,*descriptionLabel;
@property (nonatomic,retain) AsyncImageView *headerImage;

@end
