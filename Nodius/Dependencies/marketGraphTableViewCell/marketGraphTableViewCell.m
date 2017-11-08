//
//  marketGraphTableViewCell.m
//  Nodius
//
//  Created by Benjamin de Bos on 15-10-17.
//  Copyright © 2017 ITS-VIsion. All rights reserved.
//

#import "marketGraphTableViewCell.h"

@implementation marketGraphTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andType:(NSUInteger)cellType {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGFloat screenwidth = [[UIScreen mainScreen] bounds].size.width;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0);
        
        
        if (cellType == GraphCellTypeHeader) {
            self.valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, screenwidth, 30)];
            self.valueLabel.textAlignment = NSTextAlignmentCenter;
            self.valueLabel.font = [UIFont fontWithName:FONT size:26];
            self.valueLabel.textColor = neoGreenColor;
            [self.contentView addSubview:self.valueLabel];
            
            self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, screenwidth, 30)];
            self.dateLabel.textAlignment = NSTextAlignmentCenter;
            self.dateLabel.font = [UIFont fontWithName:FONT_LIGHT size:16];
            [self.contentView addSubview:self.dateLabel];

        } else if (cellType == GraphCellTypeGraph) {
            //set frame
            self.graphView = [[BEMSimpleLineGraphView alloc] initWithFrame: CGRectMake(0, 0, screenwidth, 300)];
            
            //anmiating:
            self.graphView.animationGraphEntranceTime = 1.5;
            self.graphView.animationGraphStyle = BEMLineAnimationFade;
            self.graphView.enableBezierCurve = YES;
            
            //color setup
            self.graphView.backgroundColor = [UIColor whiteColor];
            self.graphView.colorLine = neoGreenColor;
            self.graphView.colorPoint = neoGreenColor;
            
            // Enable and disable various graph properties and axis displays
            self.graphView.enableTouchReport = YES;
            self.graphView.enablePopUpReport = YES;
            self.graphView.enableYAxisLabel = NO;
            self.graphView.enableXAxisLabel = NO;
            self.graphView.autoScaleYAxis = YES;
            self.graphView.alwaysDisplayDots = NO;
            self.graphView.enableReferenceXAxisLines = YES;
            self.graphView.enableReferenceYAxisLines = YES;
            self.graphView.enableReferenceAxisFrame = YES;
            self.graphView.tintColor = [UIColor blackColor];
            self.graphView.colorBackgroundPopUplabel = neoGreenColor;
            self.graphView.colorTextPopUplabel = [UIColor whiteColor];
            //self.graphView.colo
            
            //avg line
            self.graphView.animationGraphStyle = BEMLineAnimationDraw;
            
            // Show the y axis values with this format string
            self.graphView.formatStringForValues = @"%.8f";
            self.graphView.colorTop = [UIColor clearColor];
            self.graphView.colorBottom = neoGreenColor;
            self.graphView.alphaBottom = .1;
            self.graphView.labelFont = [UIFont fontWithName:FONT_LIGHT size:14];
            self.graphView.lineDashPatternForReferenceYAxisLines = @[@(2),@(2)];
            
            [self.contentView addSubview:self.graphView];
            
        } else if (cellType == GraphCellTypePicker) {
            CGFloat width = 300;
            self.intervalPicker = [[UISegmentedControl alloc] initWithFrame:CGRectMake((screenwidth - width) / 2, 1, width, 30)];
            UIFont *font = [UIFont fontWithName:FONT_LIGHT size:14];
            NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                                   forKey:NSFontAttributeName];
            [self.intervalPicker setTitleTextAttributes:attributes
                             forState:UIControlStateNormal];
            self.intervalPicker.tintColor = neoGreenColor;
            
            [self.contentView addSubview:self.intervalPicker];

        }
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
