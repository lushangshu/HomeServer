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

#import "LoginTableViewCell.h"

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
        self.loginList = [[NSArray alloc]initWithObjects:@"微博",@"豆瓣",@"高德",nil];
        
    }else{
        self.loginButton.hidden = true;
        self.showDetailButton.hidden = false;
        self.label1.hidden = false;
        self.label2.hidden = false;
        self.label3.hidden = false;
        self.avatarView.hidden = false;
        myDelegate.wbtoken = [user objectForKey:@"wbToken"];
        self.loginList = [[NSArray alloc]initWithObjects:@"微博",@"豆瓣",@"高德",nil];
        
        
        [self showResult];
    }
    [_tableView setSeparatorColor:[UIColor blueColor]];
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
-(void)pressButtonLogOut{
    
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
    return [self.loginList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *TableSampleIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TableSampleIdentifier];
        
    }
    else {
        while ([cell.contentView.subviews lastObject ]!=nil) {
            [(UIView*)[cell.contentView.subviews lastObject]removeFromSuperview];
        }
    }
    NSUInteger row = [indexPath row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if(row == 0){
        
        if([user objectForKey:@"wbToken"] != nil){
            cell.detailTextLabel.text = @"微博已登录";
            cell.imageView.image = self.avatarView.image;
            [cell.imageView setFrame:CGRectMake(10, 10, 100,100)];
            UILabel *followers = [[UILabel alloc]initWithFrame:CGRectMake(200, 1, 40,55)];
            [followers setText:@"12211"];
            [cell addSubview:followers];
            //cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        }
        else{
            cell.detailTextLabel.text = @"微博未登录";
            cell.textLabel.text = @"点击登录微博";
            cell.textLabel.textColor = [UIColor yellowColor];

        }
        
    }else if(row ==1){
        cell.detailTextLabel.text = @"豆瓣未登录";
        cell.textLabel.text = [self.loginList objectAtIndex:row];
        cell.textLabel.textColor = [UIColor greenColor];
        
    }else if(row ==2){
        cell.detailTextLabel.text = @"高德未登录";
        cell.textLabel.text = [self.loginList objectAtIndex:row];
        cell.textLabel.textColor = [UIColor blueColor];
    }
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:60.0f];
    
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
    return 200;
    
}
-(NSInteger) tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    首先是用indexPath获取当前行的内容
    NSInteger row = [indexPath row];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if(row == 0){
        if([user objectForKey:@"wbToken"] == nil){
            [self pressButtonLogin];
        }
        else{
            
        }
        
    }else if(row ==1){
        
    }else if(row ==2){
        
    }
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
