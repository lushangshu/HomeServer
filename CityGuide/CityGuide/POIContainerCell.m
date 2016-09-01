//
//  POIContainerCell.m
//  CityGuide
//
//  Created by zhuzai on 16/9/1.
//  Copyright © 2016年 zhuzai. All rights reserved.
//

#import "POIContainerCell.h"
#import "POITableViewCell.h"

@implementation POIContainerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _collectionView = [[NSBundle mainBundle] loadNibNamed:@"POITableViewCell" owner:self options:nil][0];
        _collectionView.frame = self.bounds;
        [self.contentView addSubview:_collectionView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setCollectionData:(NSArray *)collectionData {
    [_collectionView setCollectionData:collectionData];
}

@end
