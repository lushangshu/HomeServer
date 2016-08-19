//
//  WeiboDetailViewController.h
//  CityGuide
//
//  Created by zhuzai on 16/8/18.
//  Copyright © 2016年 zhuzai. All rights reserved.
//

#import "ViewController.h"

@interface WeiboDetailViewController : ViewController
@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UILabel *label2;

@property (strong,nonatomic) NSString *receive;
@property (strong,nonatomic) NSArray *weiboDetailArray;
@end
