//
//  DestinationSetViewController.m
//  CityGuide
//
//  Created by zhuzai on 16/9/5.
//  Copyright © 2016年 zhuzai. All rights reserved.
//

#import "DestinationSetViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BaseMapViewController.h"


#define self_Width CGRectGetWidth([UIScreen mainScreen].bounds)
#define self_Height CGRectGetHeight([UIScreen mainScreen].bounds)



@interface DestinationSetViewController ()

@end

@implementation DestinationSetViewController
@synthesize tableView = _tableView;
@synthesize tableViewCell =_tableViewCell;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, self_Width, self_Height-100) style:UITableViewStylePlain];

    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self initMapViews];
    [self.view addSubview:self.tableView];[NSTimer scheduledTimerWithTimeInterval:.2 target:self selector:@selector(reloadTableview:) userInfo:nil repeats:NO];
}



-(IBAction)reloadTableview:(id)sender{
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)initMapViews{
    CGRect defaultMapFrame = CGRectMake(0, 30, self_Width, self_Height*0.2);
    self.mapView_1 = [[MAMapView alloc] initWithFrame:defaultMapFrame];

    self.mapView_1.mapType = MAMapTypeStandard;
    self.mapView_1.zoomLevel = 13;
    //self.mapView_1.cameraDegree = 55.f;
    
    self.mapView_1.showsUserLocation = YES;
    self.mapView_1.userTrackingMode = MAUserTrackingModeFollow;
    
    self.mapView_1.scrollEnabled       = YES;
    self.mapView_1.zoomEnabled         = YES;
    self.mapView_1.rotateEnabled      = YES;
    self.mapView_1.rotateCameraEnabled = YES;
    
    //CGRect defaultMapFrame = CGRectMake(0, 10, self_Width, self_Height*0.35);
    self.mapView_2 = [[MAMapView alloc] initWithFrame:defaultMapFrame];
    
    self.mapView_2.mapType = MAMapTypeStandard;
    self.mapView_2.zoomLevel = 17.5;
    self.mapView_2.cameraDegree = 55.f;
    
    self.mapView_2.showsUserLocation = YES;
    self.mapView_2.userTrackingMode = MAUserTrackingModeFollow;
    
    self.mapView_2.scrollEnabled       = YES;
    self.mapView_2.zoomEnabled         = YES;
    self.mapView_2.rotateEnabled      = YES;
    self.mapView_2.rotateCameraEnabled = YES;
    
}


#pragma mark - IBActions
-(IBAction)createDestinations:(id)sender{
    
}

#pragma mark - tableview delegates
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TableSampleIdentifier];
    }
    
    else {
        while ([cell.contentView.subviews lastObject ]!=nil) {
            [(UIView*)[cell.contentView.subviews lastObject]removeFromSuperview];
        }
    }
    [cell setBackgroundColor:[UIColor colorWithRed:0.73 green:0.96 blue:0.811 alpha:1]];
    
    if(indexPath.section==0){
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 150, 60)];
        [button setTitle:@"开始导航" forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        self.mapView_1.frame = CGRectMake(0, self_Height/2-self_Height*0.3, self_Width, self_Height*0.3);
        [cell addSubview:button];
        [cell addSubview:self.mapView_1];
        
    }
    else{
        NSUInteger row = [indexPath row];
        
        self.mapView_2.frame = CGRectMake(0,self_Height/2-self_Height*0.3, self_Width, self_Height*0.3);
        [cell addSubview:self.mapView_2];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:40.0f];
        
    }
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (self_Height-100)/2;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    首先是用indexPath获取当前行的内容
    NSInteger row = [indexPath row];
    //    从数组中取出当前行内容
}

@end
