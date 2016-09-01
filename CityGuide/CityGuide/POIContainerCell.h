//
//  POIContainerCell.h
//  CityGuide
//
//  Created by zhuzai on 16/9/1.
//  Copyright © 2016年 zhuzai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POITableViewCell.h"

@interface POIContainerCell : UITableViewCell

@property (strong, nonatomic) POITableViewCell *collectionView;

- (void)setCollectionData:(NSArray *)collectionData;

@end
