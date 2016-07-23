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

//#import "Common.h"


#define kRedirectURI @"https://api.weibo.com/oauth2/default.html"
#define aTestUserID @"1726035124"


@interface NearbyViewController ()


@end

@implementation NearbyViewController

@synthesize tableView = _tableView;
@synthesize cell =_cell;

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


#pragma mark - Tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    声明静态字符串型对象，用来标记重用单元格
    static NSString *TableSampleIdentifier = @"cell";
    //    用TableSampleIdentifier表示需要重用的单元
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    //    如果如果没有多余单元，则需要创建新的单元
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TableSampleIdentifier];
    }
    
    else {
        while ([cell.contentView.subviews lastObject ]!=nil) {
            [(UIView*)[cell.contentView.subviews lastObject]removeFromSuperview];
        }
    }
    cell.textLabel.text = @"登录";
    cell.detailTextLabel.text = @"waka";
    //    把数组中的值赋给单元格显示出来
    cell.textLabel.font = [UIFont boldSystemFontOfSize:10.0f];
    //    tableView.editing=YES;
    /*
     cell.textLabel.backgroundColor = [UIColor clearColor];
     UIView *backgroundView = [[UIView alloc] initWithFrame:cell.frame];
     backgroundView.backgroundColor = [UIColor greenColor];
     cell.backgroundView=backgroundView;
     */
    //    设置单元格UILabel属性背景颜色
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
    
}
-(NSInteger) tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSInteger row = [indexPath row];
    //    if (row % 2==0) {
    //        return 0;
    //    }
    //    return 2;
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    首先是用indexPath获取当前行的内容
    NSInteger row = [indexPath row];
    //    从数组中取出当前行内容
//    NSString *rowValue = [self.listData objectAtIndex:row];
//    NSString *message = [[NSString alloc]initWithFormat:@"You selected%@",rowValue];
//    //    弹出警告信息
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
//                                                   message:message
//                                                  delegate:self
//                                         cancelButtonTitle:@"OK"
//                                         otherButtonTitles: nil];
//    [alert show];
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
