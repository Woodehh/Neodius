//
//  gasCalculationTableViewCell.m
//  Neodius
//
//  Created by Benjamin de Bos on 27-09-17.
//  Copyright © 2017 ITS-VIsion. All rights reserved.
//

#import "gasCalculationTableViewCell.h"

#define SIDE_MARGIN @"20"
#define DIVIDER_MARGIN @"5"


@interface gasCalculationTableViewCell ()
@property (strong, nonatomic) UIView *divider1;
@property (strong, nonatomic) UIView *divider2;
@property (strong, nonatomic) UIView *divider3;
@property (strong, nonatomic) UIView *divider4;
@end

@implementation gasCalculationTableViewCell

- (UILabel *)label {
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    label.textAlignment = NSTextAlignmentLeft;
    label.adjustsFontSizeToFitWidth = YES;
    //label.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:label];
    return label;
}

- (UIView *)divider {
    UIView *view = [[UIView alloc] init];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:1.0/[[UIScreen mainScreen] scale]]];
    view.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:view];
    return view;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.separatorInset = UIEdgeInsetsZero;
    self.layoutMargins = UIEdgeInsetsZero;
    self.preservesSuperviewLayoutMargins = NO;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.divider1 = [self divider];
    self.divider2 = [self divider];
    self.divider3 = [self divider];
    self.divider4 = [self divider];
    
    self.label1 = [self label];
    self.label2 = [self label];
    self.label3 = [self label];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_label1, _label2, _label3, _divider1, _divider2,_divider3,_divider4);
    
    
    
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-"SIDE_MARGIN"-[_divider1]-"DIVIDER_MARGIN"-[_label1]-"DIVIDER_MARGIN"-[_divider2]-"DIVIDER_MARGIN"-[_label2(==_label1)]-"DIVIDER_MARGIN"-[_divider3]-"DIVIDER_MARGIN"-[_label3(==_label1)]-"SIDE_MARGIN"-[_divider4]-"SIDE_MARGIN"-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views];
    [self.contentView addConstraints:constraints];
    
    NSArray *horizontalConstraints1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_divider1]|" options:0 metrics:nil views:views];
    [self.contentView addConstraints:horizontalConstraints1];
    NSArray *horizontalConstraints2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_divider2]|" options:0 metrics:nil views:views];
    [self.contentView addConstraints:horizontalConstraints2];
    NSArray *horizontalConstraints3 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_divider3]|" options:0 metrics:nil views:views];
    [self.contentView addConstraints:horizontalConstraints3];
    NSArray *horizontalConstraints4 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_divider4]|" options:0 metrics:nil views:views];
    [self.contentView addConstraints:horizontalConstraints4];

    return self;
}

-(void)isHeaderCell {
    self.backgroundColor = neoGreenColor;
    self.label1.textColor = [UIColor whiteColor];
    self.label2.textColor = [UIColor whiteColor];
    self.label3.textColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
