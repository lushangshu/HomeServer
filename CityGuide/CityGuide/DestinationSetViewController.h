//
//  DestinationSetViewController.h
//  CityGuide
//
//  Created by zhuzai on 16/9/5.
//  Copyright © 2016年 zhuzai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>

@interface DestinationSetViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)UITableViewCell *tableViewCell;

@property (nonatomic, strong) MAMapView *mapView_1;
@property (nonatomic, strong) MAMapView *mapView_2;
@end
