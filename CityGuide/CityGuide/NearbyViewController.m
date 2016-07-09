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
#import "SBJson4.h"
#import "AFNetworking.h"


#define kRedirectURI @"https://api.weibo.com/oauth2/default.html"
#define aTestUserID @"1726035124"


@interface NearbyViewController ()


@end

@implementation NearbyViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([user objectForKey:@"wbToken"] == nil) {
        self.loginButton.hidden = false;
        self.showDetailButton.hidden = true;
        myDelegate.wbtoken = nil;
        
    }else{
        self.loginButton.hidden = true;
        self.showDetailButton.hidden = false;
        myDelegate.wbtoken = [user objectForKey:@"wbToken"];
    }
    // Do any additional setup after loading the view.
}

-(void)showLabels{
    
}
void UserProfileRequestHanlder(WBHttpRequest *httpRequest, id result, NSError *error)
{
    NSString *title = nil;
    UIAlertView *alert = nil;
    
    //UIAlertController *alertCont = nil;
    if (error)
    {
        title = NSLocalizedString(@"请求异常", nil);
        //alertCont = [UIAlertController alloc]initwith
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
        //NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:result];
        
        NSLog(@"!!!!!!!! result id is %@",(NSMutableDictionary *)result);
        NSLog(@"$$$finished$$$");
    }
    //NSLog(@" !!!!!! !!!!! !!!!! %@",[NSString stringWithFormat:@"%@",result]);
    [alert show];
}

-(IBAction)showResult{
    
    [WBHttpRequest requestForUserProfile:myDelegate.wbCurrentUserID withAccessToken:myDelegate.wbtoken andOtherProperties:nil queue:nil withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
        UserProfileRequestHanlder(httpRequest,result,error);
    } ];
    
    [self RequestWeiboUserFileUsingAFNetworking];
    
    NSLog(@" ****** id: %@ token: %@ freshtoken :  %@",myDelegate.wbCurrentUserID,myDelegate.wbtoken,myDelegate.wbRefreshToken);
    
}


-(IBAction)pressButtonLogin{
    
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];

}

-(void)downloadImage{
    // this function is used for load images without stuck the main thread
}

-(void)RequestWeiboUserFileUsingAFNetworking{
    //NSURL *URL = [NSURL URLWithString:@"https://api.weibo.com/2/users/show.json?uid=3985334031&access_token=2.00J8Di2EeszqrDeab1a32f9f0AVLXb"];
    //NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    myDelegate.wbtoken = [user objectForKey:@"wbToken"];
    myDelegate.wbCurrentUserID = [user objectForKey:@"wbUid"];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:myDelegate.wbCurrentUserID forKey:@"uid"];
    [params setObject:myDelegate.wbtoken forKey:@"access_token"];
    
    [manager GET:@"https://api.weibo.com/2/users/show.json?" parameters:params progress:nil success:^(NSURLSessionTask *task,id responseObject){
        NSDictionary *dic = responseObject;
        NSString *userName = [dic valueForKey:@"screen_name"];
        NSString *fCount = [[NSString alloc] initWithFormat:@"%@",[dic valueForKey:@"followers_count"]];
        NSString *frinedsCount = [[NSString alloc] initWithFormat:@"%@",[dic valueForKeyPath:@"friends_count"]];
        NSString *avatarURL = [dic valueForKeyPath:@"avatar_hd"];
        
        [self.label1 setText:userName];
        [self.label2 setText:fCount];
        [self.label3 setText:frinedsCount];
        
        NSURL *avatarUrl = [NSURL URLWithString:avatarURL];
        UIImage *himage = [UIImage imageWithData:[NSData dataWithContentsOfURL:avatarUrl]];
        _avatarView.contentMode = UIViewContentModeScaleAspectFit;
        self.avatarView.image = himage;
        
        [self.showDetailButton setTitle:@"登出" forState:nil];
        
        NSLog(@"%@",responseObject);
        
    }failure:^(NSURLSessionTask *operation,NSError *error){
        NSLog(@"&&&& %@",error);
    }];
    
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