//
//  NearbyViewController.h
//  CityGuide
//
//  Created by zhuzai on 16/7/5.
//  Copyright © 2016年 zhuzai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBHttpRequest.h"
#import "WeiboSDK.h"

@interface NearbyViewController : UIViewController<WBHttpRequestDelegate>

-(IBAction)pressButtonLogin;
-(IBAction)showResult;

@property (nonatomic,strong) IBOutlet UILabel *label1;
@property (nonatomic,strong) IBOutlet UILabel *label2;
@property (nonatomic,strong) IBOutlet UILabel *label3;
@property (nonatomic,strong) IBOutlet UILabel *label4;

-(void)showLabels;
//-(void)didReceiveWeiboResponse:(WBBaseResponse *)response;

@end
