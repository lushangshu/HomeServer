//
//  POITableViewCell.h
//  CityGuide
//
//  Created by zhuzai on 16/9/1.
//  Copyright © 2016年 zhuzai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface POITableViewCell : UIView <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *collectionData;

- (void)setCollectionData:(NSArray *)collectionData;

@end
