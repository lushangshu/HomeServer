//
//  ActivitiesScrollViewController.h
//  CityGuide
//
//  Created by zhuzai on 16/7/14.
//  Copyright © 2016年 zhuzai. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "wbTableView.h"
#import "weatherView.h"

@interface ActivitiesScrollViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

{
    AppDelegate *myDelegate;
}

@property (nonatomic,strong) weatherView *weatherView;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UITableViewCell *tableViewCell;

@property (nonatomic,strong) UITableView *dbTableView;
@property (nonatomic,strong) UITableViewCell *dbTableViewCell;

@property (nonatomic,strong) UITableView *weaTableView;
@property (nonatomic,strong) UITableViewCell *weaTableViewCell;

@property (strong,nonatomic) NSArray * listData;
@property (strong,nonatomic) NSArray * dbListData;
@property (strong,nonatomic) NSMutableArray *weatherData;
@end
