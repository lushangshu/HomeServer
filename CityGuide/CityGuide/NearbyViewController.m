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
#import "AFNetworking.h"

#import "Common.h"


#define kRedirectURI @"https://api.weibo.com/oauth2/default.html"
#define aTestUserID @"1726035124"


@interface NearbyViewController ()


@end

@implementation NearbyViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.indicator.hidden = true;
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([user objectForKey:@"wbToken"] == nil) {
        self.loginButton.hidden = false;
        self.showDetailButton.hidden = true;
        
        self.label1.hidden = true;
        self.label2.hidden = true;
        self.avatarView.hidden = true;
        myDelegate.wbtoken = nil;
        
    }else{
        self.loginButton.hidden = true;
        self.showDetailButton.hidden = false;
        self.label1.hidden = false;
        self.label2.hidden = false;
        self.label3.hidden = false;
        self.avatarView.hidden = false;
        myDelegate.wbtoken = [user objectForKey:@"wbToken"];
        
        [self showResult];
    }
}

-(void)showLabels{
    
}


-(IBAction)showResult{
    
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
    [self.indicator setHidden:NO];
    [self.indicator startAnimating];
    
    [manager GET:@"https://api.weibo.com/2/users/show.json?"
        parameters:params progress:^(NSProgress * Nonnull){
            NSLog(@"it is downloading ");
        }
        success:^(NSURLSessionTask *task,id responseObject){
            
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
            [self.indicator stopAnimating];
            [self.indicator setHidden:YES];
        
    }failure:^(NSURLSessionTask *operation,NSError *error){
        NSLog(@"&&&& %@",error);
        [self.indicator stopAnimating];
    }];
    
}

-(void)GetWeiboActivitiesList{
    
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
