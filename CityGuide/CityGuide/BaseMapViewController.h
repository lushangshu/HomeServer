//
//  BaseMapViewController.h
//  CityGuide
//
//  Created by zhuzai on 16/8/24.
//  Copyright © 2016年 zhuzai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface BaseMapViewController : UIViewController<MAMapViewDelegate, AMapSearchDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) AMapSearchAPI *search;

- (void)returnAction;

- (NSString *)getApplicationName;
- (NSString *)getApplicationScheme;
@end
