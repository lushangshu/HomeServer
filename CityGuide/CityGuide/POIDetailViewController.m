//
//  POIDetailViewController.m
//  CityGuide
//
//  Created by zhuzai on 16/9/2.
//  Copyright © 2016年 zhuzai. All rights reserved.
//

#import "POIDetailViewController.h"

@interface POIDetailViewController ()

@end

@implementation POIDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.label1.frame = CGRectMake(10, 10, 100, 100);
    self.label2.frame = CGRectMake(110, 110, 50, 60);
    self.label1.text = self.cellData;
    [self.view addSubview:self.label1];
    [self.view addSubview:self.label2];
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
