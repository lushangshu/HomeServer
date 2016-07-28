//
//  weatherView.h
//  CityGuide
//
//  Created by zhuzai on 16/7/28.
//  Copyright © 2016年 zhuzai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherDataObserver.h"

@interface weatherView : UIView

@property (nonatomic,strong)IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;

@property (weak, nonatomic) IBOutlet UILabel *cityName;
@property (strong,nonatomic) WeatherDataObserver *weather;
@property (strong, nonatomic) IBOutlet UITableView *forcastTableview;
@property (weak, nonatomic) IBOutlet UILabel *weatherInfo;

-(IBAction)show;
@end
