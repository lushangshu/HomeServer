//
//  NearbyViewController.h
//  CityGuide
//
//  Created by zhuzai on 16/7/5.
//  Copyright © 2016年 zhuzai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBHttpRequest.h"
#import "AppDelegate.h"
#import "WeiboSDK.h"


@interface NearbyViewController : UIViewController<WBHttpRequestDelegate,UITableViewDataSource,UITableViewDelegate>
{
    AppDelegate *myDelegate;
    
}

-(IBAction)pressButtonLogin;
-(IBAction)showResult;

@property (nonatomic,strong) IBOutlet UINavigationBar *navBar;
@property (nonatomic,strong) NSArray *loginList;
@property (nonatomic,strong) IBOutlet UILabel *label1;
@property (nonatomic,strong) IBOutlet UILabel *label2;
@property (nonatomic,strong) IBOutlet UILabel *label3;
//@property (nonatomic,strong) IBOutlet UILabel *label4;


@property (nonatomic,strong) IBOutlet UITableView *tableView;
@property (nonatomic,strong) IBOutlet UITableViewCell *cell;

@property (nonatomic,strong) IBOutlet UIButton *loginButton;
@property (nonatomic,strong) IBOutlet UIButton *showDetailButton;

@property (nonatomic,strong) IBOutlet UIImageView *avatarView;
@property (nonatomic,strong) IBOutlet UIActivityIndicatorView *indicator;

-(void)showLabels;
//-(void)didReceiveWeiboResponse:(WBBaseResponse *)response;

@end



