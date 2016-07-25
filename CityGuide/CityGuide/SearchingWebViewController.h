//
//  SearchingWebViewController.h
//  CityGuide
//
//  Created by zhuzai on 16/7/23.
//  Copyright © 2016年 zhuzai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchingWebViewController : UIViewController


@property (nonatomic,strong) IBOutlet UIWebView *webView;

@property (nonatomic,strong) IBOutlet UIButton *open;


-(IBAction)showWebView;
@end
