//
//  UserDetailVC.h
//  CityGuide
//
//  Created by zhuzai on 16/7/14.
//  Copyright © 2016年 zhuzai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface UserDetailVC : UIViewController
{
    AppDelegate *myDelegate;
}

@property (nonatomic,strong) IBOutlet UILabel *userName;

@end
