//
//  marketGraphTableViewCell.h
//  Neodius
//
//  Created by Benjamin de Bos on 15-10-17.
//  Copyright © 2017 ITS-VIsion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMSimpleLineGraphView.h"
#import "neodiusUIComponents.h"

@interface marketGraphTableViewCell : UITableViewCell

@property (readwrite, assign) NSUInteger graphCellType;
@property (nonatomic,retain) BEMSimpleLineGraphView* graphView;
@property (nonatomic,retain) UISegmentedControl *intervalPicker;
@property (nonatomic,retain) UILabel *dateLabel, *valueLabel;


typedef enum {
    GraphCellTypeHeader,
    GraphCellTypeGraph,
    GraphCellTypePicker
} GraphCellType;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andType:(NSUInteger)cellType;

@end
