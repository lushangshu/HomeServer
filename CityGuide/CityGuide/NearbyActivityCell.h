//
//  NearbyActivityCell.h
//  CityGuide
//
//  Created by zhuzai on 16/8/18.
//  Copyright © 2016年 zhuzai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Activity.h"

#define kActivityCellHeight 280

@interface NearbyActivityCell : UITableViewCell
@property (nonatomic,retain) Activity *activity;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *locate;
@property (strong, nonatomic) IBOutlet UILabel *type;
@property (strong, nonatomic) IBOutlet UILabel *interestNum;
@property (strong, nonatomic) IBOutlet UILabel *takeinNum;
@property (strong, nonatomic) IBOutlet UIView *conView;
@property (strong, nonatomic) IBOutlet UIView *detailsView;
@property (strong, nonatomic) IBOutlet UIImageView *image;

@end
