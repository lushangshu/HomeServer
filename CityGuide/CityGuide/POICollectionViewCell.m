//
//  POICollectionViewCell.m
//  CityGuide
//
//  Created by zhuzai on 16/8/26.
//  Copyright © 2016年 zhuzai. All rights reserved.
//

#import "POICollectionViewCell.h"

@implementation POICollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    self.layer.borderColor = [[UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:1.0] CGColor];
    self.layer.borderWidth = 1.0;
    self.backgroundColor = [UIColor greenColor];
}


@end
