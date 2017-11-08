//
//  customTableViewCell.m
//  Nodius
//
//  Created by Benjamin de Bos on 25-09-17.
//  Copyright © 2017 ITS-VIsion. All rights reserved.
//

#import "marketViewCustomTableViewCell.h"

@implementation marketViewCustomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = CGRectMake(self.textLabel.frame.origin.x,
                              self.textLabel.frame.origin.y,
                              self.textLabel.frame.size.width,
                              self.frame.size.height-22);
    self.textLabel.frame = frame;
}   

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
