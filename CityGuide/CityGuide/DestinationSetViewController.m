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

#import "GeocodeAnnotation.h"

#define self_Width CGRectGetWidth([UIScreen mainScreen].bounds)
#define self_Height CGRectGetHeight([UIScreen mainScreen].bounds)



@interface DestinationSetViewController ()
@property (nonatomic, strong) MAPointAnnotation *poiAnnotation;

@end

@implementation DestinationSetViewController
@synthesize tableView = _tableView;
@synthesize tableViewCell =_tableViewCell;
@synthesize poiAnnotation = _poiAnnotation;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, self_Width, self_Height-100) style:UITableViewStylePlain];

    self.tableView.delegate=self;
    self.tableView.dataSource=self;
   // self.tableView.allowsSelection = NO;
    self.mapView_1.touchPOIEnabled = YES;
    
    self.DesSearch = [[AMapSearchAPI alloc]init];
    self.DesSearch.delegate = self;
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = @"昆明市滨江俊园";
    [self.DesSearch AMapGeocodeSearch:geo];
    
    [self initMapViews];
    [self initSearchBars];
    [self.view addSubview:self.tableView];[NSTimer scheduledTimerWithTimeInterval:.3 target:self selector:@selector(reloadTableview:) userInfo:nil repeats:NO];
}



-(IBAction)reloadTableview:(id)sender{
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)initSearchBars{
    self.searchBar1.frame = CGRectMake(0, 70, self_Width, 90);
    self.searchBar2.frame = CGRectMake(0, 70, self_Width, 90);
}

-(void)initMapViews{
    CGRect defaultMapFrame = CGRectMake(0, 30, self_Width, self_Height*0.2);
    self.mapView_1 = [[MAMapView alloc] initWithFrame:defaultMapFrame];

    self.mapView_1.mapType = MAMapTypeStandard;
    self.mapView_1.zoomLevel = 13;
    //self.mapView_1.cameraDegree = 55.f;
    self.mapView_1.delegate = self;
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
    self.mapView_2.delegate = self;
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
        [cell addSubview:self.searchBar1];
        
    }
    else{
        NSUInteger row = [indexPath row];
        
        self.mapView_2.frame = CGRectMake(0,self_Height/2-self_Height*0.3, self_Width, self_Height*0.3);
        [cell addSubview:self.mapView_2];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:40.0f];
        [cell addSubview:self.searchBar2];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (self_Height-100)/2;
    
}


#pragma mark - Utility

/* Convert MATouchPoi to MAPointAnnotation. */
- (MAPointAnnotation *)annotationForTouchPoi:(MATouchPoi *)touchPoi
{
    if (touchPoi == nil)
    {
        return nil;
    }
    
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    
    annotation.coordinate = touchPoi.coordinate;
    annotation.title      = touchPoi.name;
    
    return annotation;
}


#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *touchPoiReuseIndetifier = @"touchPoiReuseIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:touchPoiReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:touchPoiReuseIndetifier];
        }
        
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop   = NO;
        annotationView.draggable      = NO;
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didTouchPois:(NSArray *)pois
{
    
    if (pois.count == 0)
    {
        return;
    }
    
    MAPointAnnotation *annotation = [self annotationForTouchPoi:pois[0]];
    
    /* Remove prior annotation. */
    if(mapView == self.mapView_1){
        [self.mapView_1 removeAnnotation:self.poiAnnotation];
        
        [self.mapView_1 addAnnotation:annotation];
        [self.mapView_1 selectAnnotation:annotation animated:YES];
        
        self.poiAnnotation = annotation;
    }
    else{
        [self.mapView_2 removeAnnotation:self.poiAnnotation];
        
        [self.mapView_2 addAnnotation:annotation];
        [self.mapView_2 selectAnnotation:annotation animated:YES];
        
        self.poiAnnotation = annotation;
    }
    
    NSLog(@"hihhihihihj %f %f",annotation.coordinate.latitude,annotation.coordinate.longitude);
}

#pragma mark -- geo search delegate functions
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    if (response.geocodes.count == 0)
    {
        return;
    }
    
    NSMutableArray *annotations = [NSMutableArray array];
    
    [response.geocodes enumerateObjectsUsingBlock:^(AMapGeocode *obj, NSUInteger idx, BOOL *stop) {
        GeocodeAnnotation *geocodeAnnotation = [[GeocodeAnnotation alloc] initWithGeocode:obj];
        
        [annotations addObject:geocodeAnnotation];
    }];

    if (annotations.count == 1)
    {
        [self.mapView_1 setCenterCoordinate:[annotations[0] coordinate] animated:YES];
    }
    else
    {
//        [self.mapView_1 setVisibleMapRect:[CommonUtility minMapRectForAnnotations:annotations]
//                               animated:YES];
    }
    for(int i=0;i<[annotations count];i++){
        NSLog(@"response is %f %f",[annotations[i] coordinate].longitude,[annotations[i] coordinate].latitude);

    }
        //[self.mapView_1 addAnnotations:annotations];
}


@end
