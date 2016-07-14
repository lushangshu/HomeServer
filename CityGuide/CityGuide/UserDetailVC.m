//
//  UserDetailVC.m
//  CityGuide
//
//  Created by zhuzai on 16/7/14.
//  Copyright © 2016年 zhuzai. All rights reserved.
//

#import "UserDetailVC.h"

@interface UserDetailVC ()

@end

@implementation UserDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.userName setText:myDelegate.wbCurrentUserID];
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
