//
//  POITableViewCell.m
//  CityGuide
//
//  Created by zhuzai on 16/9/1.
//  Copyright © 2016年 zhuzai. All rights reserved.
//

#import "POITableViewCell.h"
#import "POICollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation POITableViewCell

- (void)awakeFromNib {
    self.collectionView.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(130.0, 170.0);
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    // Register the colleciton cell
    [_collectionView registerNib:[UINib nibWithNibName:@"POICollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"POICollectionViewCell"];
}

#pragma mark - Getter/Setter overrides
- (void)setCollectionData:(NSArray *)collectionData {
    _collectionData = collectionData;
    [_collectionView setContentOffset:CGPointZero animated:NO];
    [_collectionView reloadData];
}


#pragma mark - UICollectionViewDataSource methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.collectionData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    POICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"POICollectionViewCell" forIndexPath:indexPath];
    NSDictionary *cellData = [self.collectionData objectAtIndex:[indexPath row]];
    cell.POILabel.text = [cellData objectForKey:@"title"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *cellData = [self.collectionData objectAtIndex:[indexPath row]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectItemFromCollectionView" object:cellData];
}


@end
