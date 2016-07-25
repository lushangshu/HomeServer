//
//  SearchingWebViewController.m
//  CityGuide
//
//  Created by zhuzai on 16/7/23.
//  Copyright © 2016年 zhuzai. All rights reserved.
//

#import "SearchingWebViewController.h"
#import "TOWebViewController.h"
//#import "TOWebViewController+1Password.h"

#ifndef NSFoundationVersionNumber_iOS_6_1
#define NSFoundationVersionNumber_iOS_6_1  993.00
#endif

/* Detect if we're running iOS 7.0 or higher */
#define MINIMAL_UI (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)


@interface SearchingWebViewController ()

@end

@implementation SearchingWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)showWebView{
    [self showWebViewC];
}

-(void) showWebViewC{
    NSURL *url = nil;
    url = [NSURL URLWithString:@"https://www.baidu.com"];
    TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:url];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:webViewController] animated:YES completion:nil];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
