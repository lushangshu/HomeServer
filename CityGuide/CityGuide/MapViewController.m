//
//  MapViewController.m
//  CityGuide
//
//  Created by zhuzai on 16/7/4.
//  Copyright © 2016年 zhuzai. All rights reserved.
//

#import "MapViewController.h"
#import "POICollectionViewCell.h"
#import "POIContainerCell.h"
#import "POITableViewCell.h"
#import "POIDetailViewController.h"
#import "WeiboDetailViewController.h"
#import "DestinationSetViewController.h"
#import "POIAnnotation.h"
#import <AMapSearchKit/AMapSearchKit.h>


#define self_Width CGRectGetWidth([UIScreen mainScreen].bounds)
#define self_Height CGRectGetHeight([UIScreen mainScreen].bounds)


@interface MapViewController ()

@end

@implementation MapViewController

@synthesize mapView     = _mapView;
@synthesize search      = _search;
//@synthesize POIcollectionView = _collectionView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.MaptableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, self_Width, self_Height) style: UITableViewStylePlain];
    
    self.MaptableView.dataSource = self;
    self.MaptableView.delegate = self;
    
    self.MaptableView.backgroundColor = [UIColor whiteColor];
    //self.MaptableView.contentInset = UIEdgeInsetsMake(-1.0f, 0.0f, 0.0f, 0.0);
    [self.view addSubview:self.MaptableView];
    
    [self initCollectionView];
    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
    [self initMapView];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(reloadTableview:) userInfo:nil repeats:NO];
}



-(IBAction)reloadTableview:(id)sender{
    [self.MaptableView reloadData];
    [self searchPoiByCenterCoordinate];
    [self.MaptableView reloadData];
    
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//this view is setup for the AMAP SDK
- (void)initMapView
{
    CGRect defaultMapFrame = CGRectMake(0, 0, self_Width, self_Height*0.75);
    self.mapView = [[MAMapView alloc] initWithFrame:defaultMapFrame];
    
    self.manager = [[CLLocationManager alloc]init];
    self.manager.delegate = self;
    [self.manager startUpdatingLocation];
    self.manager.desiredAccuracy = kCLLocationAccuracyBest;
    
    self.mapView.mapType = MAMapTypeStandard;
    self.mapView.zoomLevel = 17.5;
    self.mapView.cameraDegree = 55.f;
    
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    
    self.mapView.scrollEnabled       = YES;
    self.mapView.zoomEnabled         = YES;
    self.mapView.rotateEnabled      = YES;
    self.mapView.rotateCameraEnabled = YES;
    
    self.mapView.delegate = nil;
    //self.mapView.clipsToBounds = NO;
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10, self_Height*0.75-70, 50, 35)];
    [button setTitle:@"定位" forState:UIControlStateNormal];
    button.tintColor = [UIColor darkGrayColor];
    [button addTarget:self action:@selector(trackUserLocation:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.mapView addSubview:button];
    
    
}

/* 根据中心点坐标来搜周边的POI. */
- (void)searchPoiByCenterCoordinate
{
    CLLocationManager *manager = [[CLLocationManager alloc]init];
    [manager startUpdatingLocation];
    
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    
    request.location            = [AMapGeoPoint locationWithLatitude:self.userLocation.coordinate.latitude longitude:self.userLocation.coordinate.longitude];
    request.keywords            = @"餐饮";
    /* 按照距离排序. */
    request.sortrule            = 0;
    request.requireExtension    = YES;
    request.radius = 300;
    
    [self.search AMapPOIAroundSearch:request];
}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        return;
    }
    
    NSMutableArray *poiAnnotations = [NSMutableArray arrayWithCapacity:response.pois.count];
    
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        
        [poiAnnotations addObject:[[POIAnnotation alloc] initWithPOI:obj]];
        
    }];
    
    /* 将结果以annotation的形式加载到地图上. */
    [self.mapView addAnnotations:poiAnnotations];
    
    /* 如果只有一个结果，设置其为中心点. */
    if (poiAnnotations.count == 1)
    {
        [self.mapView setCenterCoordinate:[poiAnnotations[0] coordinate]];
        self.mapView.zoomLevel = 17.5;
        self.mapView.cameraDegree = 55.f;
    }
    /* 如果有多个结果, 设置地图使所有的annotation都可见. */
    else
    {
        [self.mapView showAnnotations:poiAnnotations animated:NO];
        self.mapView.zoomLevel = 17.5;
        self.mapView.cameraDegree = 55.f;
    }
}


//Nearby POI Collectionview setup
-(void)initCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(130, 157);
    self.POIcollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self_Width, 160) collectionViewLayout:layout];
    self.POIcollectionView.backgroundColor = [UIColor whiteColor];
    self.POIcollectionView.delegate = self;
    self.POIcollectionView.dataSource = self;
    //self.POIcollectionView.backgroundColor = [UIColor lightGrayColor];
    
    [self.POIcollectionView registerNib:[UINib nibWithNibName:@"POICollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"POICollectionViewCell"];
    
}

#pragma functions ---- especially buttons
-(IBAction)trackUserLocation:(id)sender{
    self.mapView.userTrackingMode = 1;
}


#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    //return [self.loginList count];
    if(section == 0){
        return 1;
    }
    else if(section == 1){
        return 3;
    }
    else if(section ==2){
        return 1;
    }
    else return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section==2){
        return @"信息";
        
    }
    else if(section ==1){
        return @"附近POI";
    }
    else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section:(NSInteger)section{
    if(section == 0){
        return 0.0f;
    }else
        return 3.0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *TableSampleIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TableSampleIdentifier];
        
    }
    else {
        while ([cell.contentView.subviews lastObject ]!=nil) {
            [(UIView*)[cell.contentView.subviews lastObject]removeFromSuperview];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    if(indexPath.section ==0){
        self.mapView.frame = CGRectMake(0, 0, self_Width, self_Height*0.75);
        [cell addSubview:self.mapView];
    }
    else if(indexPath.section == 1){
        
        switch (indexPath.row) {
            case 0:
               
                //[cell.contentView addSubview:_collectionView];
                //[cell addSubview:_collectionView];
                cell.backgroundColor = [UIColor whiteColor];
                [cell addSubview:self.POIcollectionView];
                 break;
            case 1:
                cell.detailTextLabel.text = @"";
                cell.textLabel.text = @"设定常用目的地";
                [cell.textLabel setFont: [UIFont boldSystemFontOfSize:40.0f]];
                cell.textLabel.textColor = [UIColor darkGrayColor];
                break;
            case 2:
                cell.detailTextLabel.text = @"开发中……";
                cell.textLabel.text = @"开发中……";
                cell.textLabel.textColor = [UIColor darkGrayColor];
                [cell.textLabel setFont: [UIFont boldSystemFontOfSize:60.0f]];
                break;
            default:
                break;
        }
    }
    else if(indexPath.section==2){
        cell.detailTextLabel.text = @"管理离线地图等";
        cell.textLabel.text = @"设置";
        cell.imageView.image = nil;
        cell.textLabel.textColor = [UIColor grayColor];
        [cell.textLabel setFont: [UIFont boldSystemFontOfSize:40.0f]];
    }
    
    //cell.textLabel.font = [UIFont boldSystemFontOfSize:60.0f];
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return self_Height*0.75;
    }
    else{
        return 160;
    }
    
}
-(NSInteger) tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    首先是用indexPath获取当前行的内容
    NSInteger row = [indexPath row];
    if(row == 0){
        
    }else if(row ==1){
        if(indexPath.section == 1){
            DestinationSetViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"DestinationSet"];
            [self.navigationController pushViewController:vc animated:YES];
            [[self navigationController] setNavigationBarHidden:NO animated:YES];
        }else{
            
        }
        
    }else if(row ==2){
        
        
    }
    //    从数组中取出当前行内容
    //    NSString *rowValue = [self.listData objectAtIndex:row];
    //    NSString *message = [[NSString alloc]initWithFormat:@"You selected%@",rowValue];
    //    //    弹出警告信息
    //    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
    //                                                   message:message
    //                                                  delegate:self
    //                                         cancelButtonTitle:@"OK"
    //                                         otherButtonTitles: nil];
    //    [alert show];
}

#pragma mark - UICollecitonViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    POICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"POICollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];

    cell.POILabel.text = @"附近有趣的景点";
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //NSString * cellData = @"select";
    NSLog(@"selected collection view %ld",(long)indexPath.row);
    
    POIDetailViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"POIDetail"];
    [self.navigationController pushViewController:vc animated:YES];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
}


#pragma mark - UICollectionViewDelegateFlowout

#pragma mark - CLLocationmanagerdelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location = [locations lastObject];
    self.userLocation = location;
    //NSLog(@"user location lat %f long %f",self.userLocation.coordinate.latitude,self.userLocation.coordinate.longitude);
}


@end
