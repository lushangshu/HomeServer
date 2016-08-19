//
//  WeiboDetailViewController.m
//  CityGuide
//
//  Created by zhuzai on 16/8/18.
//  Copyright © 2016年 zhuzai. All rights reserved.
//

#import "WeiboDetailViewController.h"

#define self_Width CGRectGetWidth([UIScreen mainScreen].bounds)
#define self_Height CGRectGetHeight([UIScreen mainScreen].bounds)

@interface WeiboDetailViewController ()
@end

@implementation WeiboDetailViewController

@synthesize receive = _receive;
@synthesize weiboDetailArray = _weiboDetailArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"data 1 and data 2 is %@ %@ %@",self.label1.text,self.label2.text,self.receive);
    // Do any additional setup after loading the view.
    self.label2.text = self.receive;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
