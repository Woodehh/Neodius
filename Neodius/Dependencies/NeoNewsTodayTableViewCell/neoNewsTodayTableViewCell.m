//
//  neoNewsTodayTableViewCell.m
//  Neodius
//
//  Created by Benjamin de Bos on 05-10-17.
//  Copyright © 2017 ITS-VIsion. All rights reserved.
//

#import "neoNewsTodayTableViewCell.h"

@implementation neoNewsTodayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _headerImage = [[AsyncImageView alloc] init];
        _headerImage.translatesAutoresizingMaskIntoConstraints = NO;
        _headerImage.contentMode = UIViewContentModeScaleAspectFill;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedImage)];
        [_headerImage addGestureRecognizer:tapGestureRecognizer];
        _headerImage.userInteractionEnabled = YES;

        
        [_headerImage setClipsToBounds:YES];
        [self.contentView addSubview:_headerImage];        
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont fontWithName:FONT_LIGHT size:18];
        _titleLabel.highlightedTextColor = [UIColor whiteColor];
        [self.contentView addSubview:_titleLabel];
        
        _categoryLabel = [[UILabel alloc] init];
        _categoryLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _categoryLabel.highlightedTextColor = [UIColor whiteColor];
        _categoryLabel.numberOfLines = 0;
        _categoryLabel.font = [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:14];
        [self.contentView addSubview:_categoryLabel];
        
        UIView *divider = [[UIView alloc] init];
        divider.backgroundColor = neoGreenColor;
        divider.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:divider];

        _descriptionLabel = [[UILabel alloc] initWithFrame:self.frame];
        _descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _descriptionLabel.highlightedTextColor = [UIColor whiteColor];
        _descriptionLabel.font = [UIFont fontWithName:FONT_LIGHT size:14];
        _descriptionLabel.numberOfLines = 0;
        [self.contentView addSubview:_descriptionLabel];
        
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_headerImage, _titleLabel, _categoryLabel, divider, _descriptionLabel);
        
        NSArray *constraints;

        if (IS_IPAD) {
            constraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%d-[_headerImage]-%d-|",SIDE_MARGIN,SIDE_MARGIN]
                                                                  options: 0
                                                                  metrics:nil
                                                                    views:views];
        } else {
            constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_headerImage]-0-|"
                                                                  options: 0
                                                                  metrics:nil
                                                                    views:views];
        }
        
        
        [self.contentView addConstraints:constraints];

        
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%d-[_titleLabel]-%d-|",SIDE_MARGIN,SIDE_MARGIN]
                                                                       options: 0
                                                                       metrics:nil
                                                                         views:views];
        [self.contentView addConstraints:constraints];

        
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%d-[_categoryLabel]-%d-|",SIDE_MARGIN,SIDE_MARGIN]
                                                              options: 0
                                                              metrics:nil
                                                                views:views];
        [self.contentView addConstraints:constraints];

        constraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%d-[divider]-%d-|",SIDE_MARGIN,SIDE_MARGIN]
                                                              options: 0
                                                              metrics:nil
                                                                views:views];
        [self.contentView addConstraints:constraints];


        constraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%d-[_descriptionLabel]-%d-|",SIDE_MARGIN,SIDE_MARGIN]
                                                                       options: 0
                                                                       metrics:nil
                                                                         views:views];
        [self.contentView addConstraints:constraints];

        
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_headerImage(==210)]-25-[_titleLabel]-10-[_categoryLabel]-10-[divider(==1)]-10-[_descriptionLabel]-0-|"
                                                              options: 0
                                                              metrics:nil
                                                                views:views];
        [self.contentView addConstraints:constraints];
        
        UIView *bgColor = [[UIView alloc] init];
        [bgColor setBackgroundColor:neoGreenColor];
        self.selectedBackgroundView = bgColor;
        
    }
    return self;
}

-(void)tappedImage {
    NSLog(@"tapped");
    [EXPhotoViewer showImageFrom:self.headerImage];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
