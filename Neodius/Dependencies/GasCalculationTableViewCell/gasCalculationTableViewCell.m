//
//  gasCalculationTableViewCell.m
//  Neodius
//
//  Created by Benjamin de Bos on 27-09-17.
//  Copyright © 2017 ITS-VIsion. All rights reserved.
//

#import "gasCalculationTableViewCell.h"

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
    label.adjustsFontSizeToFitWidth = YES;
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
    NSString *visualFormat = [NSString stringWithFormat:@"H:|-%d-[_divider1]-%d-[_label1]-%d-[_divider2]-%d-[_label2(==_label1)]-%d-[_divider3]-%d-[_label3(==_label1)]-%d-[_divider4]-%d-|",
                              SIDE_MARGIN,
                              DIVIDER_MARGIN,
                              DIVIDER_MARGIN,
                              DIVIDER_MARGIN,
                              DIVIDER_MARGIN,
                              DIVIDER_MARGIN,
                              DIVIDER_MARGIN,
                              SIDE_MARGIN];
    
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:NSLayoutFormatAlignAllCenterY metrics:nil views:views];
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
    self.label1.font = [UIFont fontWithName:@"HelveticaNeue" size:self.label1.font.pointSize];
    self.label2.textColor = [UIColor whiteColor];
    self.label2.font = [UIFont fontWithName:@"HelveticaNeue" size:self.label2.font.pointSize];
    self.label3.textColor = [UIColor whiteColor];
    self.label3.font = [UIFont fontWithName:@"HelveticaNeue" size:self.label3.font.pointSize];
}

-(void)isFooterCell {
    self.label1.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    self.label2.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    self.label3.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
