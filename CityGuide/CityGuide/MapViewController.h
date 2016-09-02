//
//  MapViewController.h
//  CityGuide
//
//  Created by zhuzai on 16/7/4.
//  Copyright © 2016年 zhuzai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BaseMapViewController.h"

@interface MapViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>


@property (nonatomic,strong) UICollectionView *POIcollectionView;
@property (nonatomic,strong)  UITableView *MaptableView;
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;

@end
