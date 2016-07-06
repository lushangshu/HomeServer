//
//  NearbyViewController.m
//  CityGuide
//
//  Created by zhuzai on 16/7/5.
//  Copyright © 2016年 zhuzai. All rights reserved.
//

#import "NearbyViewController.h"
#import "AppDelegate.h"
#import "WeiboSDK.h"
#import "WeiboSDK+Statistics.h"

#define kRedirectURI @"https://api.weibo.com/oauth2/default.html"
#define aTestUserID @"1726035124"


@interface NearbyViewController ()

@end

@implementation NearbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)showLabels{
    
}
void DemoRequestHanlder(WBHttpRequest *httpRequest, id result, NSError *error)
{
    NSString *title = nil;
    UIAlertView *alert = nil;
    
    
    
    if (error)
    {
        title = NSLocalizedString(@"请求异常", nil);
        alert = [[UIAlertView alloc] initWithTitle:title
                                           message:[NSString stringWithFormat:@"%@",error]
                                          delegate:nil
                                 cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                 otherButtonTitles:nil];
        NSLog(@"error is %@",[NSString stringWithFormat:@"%@",error]);
    }
    else
    {
        title = NSLocalizedString(@"收到网络回调", nil);
        alert = [[UIAlertView alloc] initWithTitle:title
                                           message:[NSString stringWithFormat:@"%@",result]
                                          delegate:nil
                                 cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                 otherButtonTitles:nil];
    }
    
    NSLog(@" !!!!!! !!!!! !!!!! %@",[NSString stringWithFormat:@"%@",result]);
    [alert show];
}

-(IBAction)showResult{
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [WBHttpRequest requestForUserProfile:myDelegate.wbCurrentUserID withAccessToken:myDelegate.wbtoken andOtherProperties:nil queue:nil withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
        DemoRequestHanlder(httpRequest,result,error);
    } ];
    
    NSLog(@" ****** id: %@ token: %@ freshtoken :  %@",myDelegate.wbCurrentUserID,myDelegate.wbtoken,myDelegate.wbRefreshToken);
    
}


-(IBAction)pressButtonLogin{
    
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];

    
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
