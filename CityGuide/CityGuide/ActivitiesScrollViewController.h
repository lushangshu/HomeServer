//
//  ActivitiesScrollViewController.h
//  CityGuide
//
//  Created by zhuzai on 16/7/14.
//  Copyright © 2016年 zhuzai. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "LightDataSource.h"
#import "LightDelegate.h"
#import "wbTableView.h"

@interface ActivitiesScrollViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

{
    AppDelegate *myDelegate;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UITableViewCell *tableViewCell;
@property (nonatomic,strong) UITableView *dbTableView;
@property (nonatomic,strong) LightDelegate *delegate;
@property (nonatomic,strong) LightDataSource *dataSource;

@property (strong,nonatomic) NSArray * listData;
@end
