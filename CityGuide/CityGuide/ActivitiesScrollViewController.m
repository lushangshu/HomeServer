//
//  ActivitiesScrollViewController.m
//  CityGuide
//
//  Created by lushangshu on 16/7/14.
//  Copyright © 2016年 lushangshu. All rights reserved.
//

#import "ActivitiesScrollViewController.h"
#import "LFLUISegmentedControl.h"
#import "MovieAndBooksView.h"
#import "AFNetworking.h"
#import "LightCell.h"
#import "FetchWeatherInfo.h"
#import "WeatherDataObserver.h"
#import "wbUserDetailVC.h"
#import "NearbyActivityCell.h"
#import "Activity.h"
#import "HttpClientRequest.h"

#import "VVeboTableView.h"

#import "WeiboDetailViewController.h"

#define self_Width CGRectGetWidth([UIScreen mainScreen].bounds)
#define self_Height CGRectGetHeight([UIScreen mainScreen].bounds)

@interface ActivitiesScrollViewController ()<LFLUISegmentedControlDelegate,UIScrollViewDelegate,HttpClientRequestDelegete>

@property(nonatomic, strong)UIScrollView *mainScrollView; /**< 正文mainSV */
@property (nonatomic ,strong)LFLUISegmentedControl * LFLuisement; /**< LFLuisement */

//豆瓣活动
@property (nonatomic,retain) NSMutableArray *array;


@end

@implementation ActivitiesScrollViewController
{
    VVeboTableView *vvTableView;
}
@synthesize listData=_listData;
@synthesize tableView = _tableView;
@synthesize tableViewCell =_tableViewCell;
@synthesize weatherData = _weatherData;
@synthesize weaTableView = _weatherTableView;
@synthesize weaTableViewCell = _weaTableViewCell;
@synthesize activityTableView = _activityTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    LFLUISegmentedControl* LFLuisement=[[LFLUISegmentedControl alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
    
    LFLuisement.delegate = self;
    NSArray* LFLarray=[NSArray arrayWithObjects:@"今日话题",@"随便看看",@"附近好玩",@"天气咋样",nil];
    [LFLuisement AddSegumentArray:LFLarray];
    [LFLuisement selectTheSegument:0];
    self.LFLuisement = LFLuisement;
    [self.view addSubview:LFLuisement];
    
    self.dbListData = [NSArray arrayWithObjects:@"1",@"2",@"3db",@"1",@"2",@"3db",@"1",@"2",@"3db", nil];
    
    
    [self createMainScrollView];
}
- (void)createMainScrollView {
    CGFloat begainScrollViewY = 37+ 64;
    self.mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, begainScrollViewY, self_Width,(self_Height -begainScrollViewY))];
    self.mainScrollView.scrollsToTop = NO;
    self.mainScrollView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:self.mainScrollView];
    self.mainScrollView.bounces = NO;
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.scrollEnabled = NO;
    self.mainScrollView.contentSize = CGSizeMake(self_Width * 4, (self_Height -begainScrollViewY));
    //设置代理
    self.mainScrollView.delegate = self;

    [self.mainScrollView addSubview:[self TopicsView]];
    [self.mainScrollView addSubview:[self NearbyView]];
    [self.mainScrollView addSubview:[self RandomImagesView]];
    [self.mainScrollView addSubview:[self WheatherView]];
    
}
//通过微博的公共public weibo api 获取今日的热门数据
-(UIView* )TopicsView{
    
    UIView *viewExample = [[UIView alloc]initWithFrame:CGRectMake(self_Width *0, 0, self_Width,self_Height)];
    viewExample.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]init];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *wbtoken = [user objectForKey:@"wbToken"];
    //NSLog(@"dao le zhe li access token is %@",wbtoken);
    [params setObject: wbtoken forKey:@"access_token"];
    [params setObject:@"50" forKey:@"count"];
    [manager GET:@"https://api.weibo.com/2/statuses/public_timeline.json?"
      parameters:params progress:^(NSProgress * Nonnull){
          NSLog(@"Activities Nearby");
      }
         success:^(NSURLSessionTask *task,id responseObject){
             
             //NSLog(@"%@",responseObject); //输出返回的结果json
             
             NSArray *dic = [responseObject objectForKey:@"statuses"];
             NSMutableArray *result = [[NSMutableArray alloc]init];
             result = [self parseJsonData:dic];
             //NSLog(@"%@",result);
             
             self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(self_Width *0, 0, self_Width, self_Height)];
             self.tableView.delegate=self;
             self.tableView.dataSource=self;
             [self.tableView setScrollsToTop:YES];
             //把tabView添加到视图之上
             [viewExample addSubview:self.tableView];
             
             self.listData = result;
             [self.tableView reloadData];
            
         }failure:^(NSURLSessionTask *operation,NSError *error){
             NSLog(@"&&&& %@",error);
         }];
    
    return viewExample;
}

-(UIView* )NearbyView{
    UIView *viewExample = [[UIView alloc]initWithFrame:CGRectMake(self_Width *1, 0, self_Width,self_Height)];
    viewExample.backgroundColor = [UIColor whiteColor];
    //豆瓣活动的网络请求与初始化
    _activityTableView = [[UITableView alloc]initWithFrame:CGRectMake(self_Width *0, 0, self_Width, self_Height)];
    [_activityTableView registerNib:[UINib nibWithNibName:@"NearbyActivityCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"activityCellReuse"];
    [HttpClientRequest getHttpClientRequest:@"http://project.lanou3g.com/teacher/yihuiyun/lanouproject/activitylist.php" andDelegate:self];
    _activityTableView.delegate = self;
    _activityTableView.dataSource = self;
    
//    UILabel *labelTest = [[UILabel alloc]initWithFrame:CGRectMake(3, 3, 100, 100)];
//    labelTest.text = @"附近";
    [viewExample addSubview:_activityTableView];
    return viewExample;
}

//附近好玩的界面
-(UIView* )RandomImagesView{
    UIView *viewExample = [[UIView alloc]initWithFrame:CGRectMake(self_Width *2, 0, self_Width,self_Height)];
    viewExample.backgroundColor = [UIColor whiteColor];
    self.dbTableView = [[UITableView alloc]initWithFrame:CGRectMake(self_Width *0, 0, self_Width, self_Height)];
    self.dbTableView.delegate=self;
    self.dbTableView.dataSource=self;
    [self.dbTableView reloadData];
    //[viewExample addSubview:self.dbTableView];
    
    vvTableView = [[VVeboTableView alloc] initWithFrame:CGRectMake(self_Width *0, 0, self_Width, self_Height) style:UITableViewStylePlain];
    vvTableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    vvTableView.scrollIndicatorInsets = vvTableView.contentInset;
    [viewExample addSubview:vvTableView];
    return viewExample;
}

-(UIView* )WheatherView{
    UIView *viewExample = [[UIView alloc]initWithFrame:CGRectMake(self_Width *3, 0, self_Width,self_Height)];
    viewExample.backgroundColor = [UIColor whiteColor];
    WeatherDataObserver *wea = [[WeatherDataObserver alloc]init];
    
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"weatherView" owner:self options:nil];
    self.weatherView = [nibContents lastObject];
   
    self.weatherView.forcastTableview.delegate = self;
    self.weatherView.forcastTableview.dataSource = self;
    
    NSString *httpUrl = @"http://apis.baidu.com/heweather/weather/free";
    NSString *httpArg = @"city=kunming";
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, httpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"e84f8a92cdab94f1dc4580407b9118c1" forHTTPHeaderField: @"apikey"];
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
                               } else {
                                   self.weatherView.forcastTableview.frame = CGRectMake(0,self_Height/8+self_Height/6 , self_Width,self_Height-150);
                                   self.weatherView.cityName.frame = CGRectMake(3, 3, self_Width/2.5, self_Height/6);
                                   self.weatherView.tempLabel.frame = CGRectMake(3, 3+self_Height/8, self_Width/2.5, self_Height/6);
                                   self.weatherView.weatherInfo.frame = CGRectMake(10+self_Width/2.5, 3, self_Width/2, self_Height/6);
                                   self.weatherData = [wea parseWeatherData:data];
                                   [self.weatherView.forcastTableview reloadData];
                                   self.weatherView.cityName.text = [[self.weatherData objectAtIndex:0]objectAtIndex:0];
                                   NSString *temp = [NSString stringWithFormat:@"今天的气温是："];
                                   NSString *temp1 = [temp stringByAppendingString:[[self.weatherData objectAtIndex:1]objectAtIndex:1]];
                                   NSString *temp2 = [temp1 stringByAppendingString:@" 到 "];
                                   NSString *temp3 = [temp2 stringByAppendingString:[[self.weatherData objectAtIndex:1]objectAtIndex:2]];
                                   self.weatherView.tempLabel.text = temp3;
                                   self.weatherView.weatherInfo.text = [[self.weatherData objectAtIndex:8]objectAtIndex:1];
                                   
                                   NSLog(@"HttpResponseCode:%@", self.weatherData);
                                   //NSLog(@"HttpResponseBody %@",responseString);
                               }
                           }];
    
    [viewExample addSubview:self.weatherView];
    
    return viewExample;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

//解析返回的json数据 微博中的
-(NSMutableArray *) parseJsonData: (NSArray *) json
{
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    for (int i=0;i< [json count];i++)
    {
        NSDictionary *subject = [json objectAtIndex:i];
        NSString *created_at = [subject objectForKey:@"created_at"];
        NSString *text = [subject objectForKey:@"text"];
        NSArray *pic_urls = [subject objectForKey:@"pic_urls"];
//        if(pic_urls.count!=0){
//            NSLog(@"%@",pic_urls);
//        }
        NSMutableArray *thumbnail_urls = [[NSMutableArray alloc]init];
        for(int i=0;i<pic_urls.count;i++){
            NSString *url = [[pic_urls objectAtIndex:i]objectForKey:@"thumbnail_pic"];
            [thumbnail_urls addObject:url];
        }
        NSDictionary *test3 = [subject objectForKey:@"user"];
        
        NSString *avatar_hd = [test3 objectForKey:@"avatar_large"];
        NSString *screen_name = [test3 objectForKey:@"screen_name"];
        
        NSArray *array = [[NSArray alloc]initWithObjects:created_at,text,avatar_hd,screen_name, thumbnail_urls,nil];
        [resultArray addObject:array];
    }
    return resultArray;
}

#pragma mark --- UIScrollView代理方法

static NSInteger pageNumber = 0;

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    pageNumber = (int)(scrollView.contentOffset.x / self_Width + 0.5);
//    [self.LFLuisement selectTheSegument:pageNumber];
}

#pragma mark ---LFLUISegmentedControlDelegate

-(void)uisegumentSelectionChange:(NSInteger)selection{
    [UIView animateWithDuration:.1 animations:^{
        [self.mainScrollView setContentOffset:CGPointMake(self_Width *selection, 0)];
    }];
}

#pragma mark - tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.tableView){
        return [self.listData count];
    }
    else if(tableView == self.dbTableView){
        return [self.dbListData count];
    }else if(tableView == _activityTableView){
        return _array.count;
    }
    else{
        return [self.weatherData count]-2;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tableView){
        static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
        NSUInteger row = [indexPath row];
        //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TableSampleIdentifier];
            //texts
            UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, 70, self_Width-10, self_Height/2.5)];
            UILabel *screenName = [[UILabel alloc]initWithFrame:CGRectMake(80, 3, self_Width-50, 30)];
            [contentLabel setNumberOfLines:0];
            contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
            [cell.contentView.superview setClipsToBounds:NO];
            [contentLabel setText:[[self.listData objectAtIndex:row] objectAtIndex:1]];
            [screenName setText:[[self.listData objectAtIndex:row]objectAtIndex:3]];
            CGSize size = [contentLabel sizeThatFits:CGSizeMake(contentLabel.frame.size.width,MAXFLOAT)];
            contentLabel.frame = CGRectMake(3, 70, self_Width-10, size.height);
            contentLabel.font = [UIFont boldSystemFontOfSize:12.0f];
            screenName.font = [UIFont boldSystemFontOfSize:10.0f];
            NSUInteger counts = [[[_listData objectAtIndex:indexPath.row] objectAtIndex:4] count];
            NSMutableArray *pic_urls = [[_listData objectAtIndex:indexPath.row] objectAtIndex:4];
            
            NSLog(@"url is %@",pic_urls);
//            if(pic_urls.count!=0){
//                for(int i=0;i<counts;i++){
//                    NSLog(@"pic urls is %@",[pic_urls objectAtIndex:i]);
//                    [self downloadImageWithURL:[pic_urls objectAtIndex:i] completionBlock:^(BOOL succeeded, UIImage *image) {
//                        if (succeeded) {
//                            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(3,  3*i, 60, 60)];
//                            imageView.image = image;
//                            //                        imageView.layer.cornerRadius = imageView.frame.size.width/2.0;
//                            //                        imageView.layer.masksToBounds = YES;
//                            
//                            [cell addSubview:imageView];
//                        }
//                    }];
//                    
//                }
//            }
//            
            [cell addSubview:screenName];
            [cell addSubview:contentLabel];
            //images
            NSString *url = [[self.listData objectAtIndex:row] objectAtIndex:2];
            NSURL *avatarUrl = [NSURL URLWithString:url];
            
            [self downloadImageWithURL:avatarUrl completionBlock:^(BOOL succeeded, UIImage *image) {
                if (succeeded) {
                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(3, 3, 60, 60)];
                    imageView.image = image;
                    imageView.layer.cornerRadius = imageView.frame.size.width/2.0;
                    imageView.layer.masksToBounds = YES;
                    
                    [cell addSubview:imageView];
                }
            }];
            
        }
        else {
            while ([cell.contentView.subviews lastObject ]!=nil) {
                [(UIView*)[cell.contentView.subviews lastObject]removeFromSuperview];
                
            }
        }
        return cell;
    }
    //附近好玩的cell
    else if(tableView == self.dbTableView){
        static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
        NSUInteger row = [indexPath row];
        //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TableSampleIdentifier];
            UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, 70, self_Width-10, self_Height/2.5)];
            contentLabel.text = [self.dbListData objectAtIndex:row];
            [cell addSubview:contentLabel];
        }
        else {
            while ([cell.contentView.subviews lastObject ]!=nil) {
                [(UIView*)[cell.contentView.subviews lastObject]removeFromSuperview];
                
            }
        }
        
        return cell;
        
    }
    //随便看看的cell
    else if(tableView == self.activityTableView){
        NearbyActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"activityCellReuse" forIndexPath:indexPath];
        Activity *activity = _array[indexPath.row];
        cell.activity = activity;
        
//        cell.title.frame = CGRectMake(5, 5, self_Width, 20);
        cell.imageView.center = CGPointMake(self_Width/2, self_Height/2);
        cell.imageView.frame = CGRectMake(250, 50, 100, 150);
        return cell;
    }
    //天气的cell
    else{
        static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
        //NSString *cellIdentifier = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        NSUInteger row = [indexPath row];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TableSampleIdentifier];
            UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, 70, self_Width-10, self_Height/2.5)];
            UILabel *maxtemp = [[UILabel alloc]initWithFrame:CGRectMake(70, 70, self_Width-10, self_Height/2.5)];
            UILabel *mintemp = [[UILabel alloc]initWithFrame:CGRectMake(120, 70, self_Width-10, self_Height/2.5)];
            
            contentLabel.text = [[self.weatherData objectAtIndex:row+1]objectAtIndex:0];
            maxtemp.text = [[self.weatherData objectAtIndex:row+1]objectAtIndex:1];
            mintemp.text = [[self.weatherData objectAtIndex:row+1]objectAtIndex:2];
            [cell addSubview:maxtemp];
            [cell addSubview:mintemp];
            [cell addSubview:contentLabel];
        }
        else {
            while ([cell.contentView.subviews lastObject ]!=nil) {
                [(UIView*)[cell.contentView.subviews lastObject]removeFromSuperview];
                
            }
        }
        
        return cell;
        
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.dbTableView){//附近好玩的cell高度
        return self_Height/2.2;
    }
    else if(tableView ==self.tableView){//今日话题的cell高度
        //return self_Height/2.2;
        if([[[_listData objectAtIndex:indexPath.row] objectAtIndex:4] count]!=0){
            return self_Height/2;
        }else{
            return self_Height/4.7;
        }
    }
    else if(tableView == self.activityTableView){//随便看看的cell高度
        return kActivityCellHeight; 
    }
    else {
        return self_Height/2.5;//天气咋样的cell高度
    }
    
    
}
-(NSInteger) tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tableView){

        WeiboDetailViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"weiboDetail"];
        vc.label1.text = @"data passed here";
        //vc.label2.text = [[self.listData objectAtIndex:indexPath.row] objectAtIndex:1];
        [vc.label2 setText:@"nonon"];
        vc.receive = @"wjha";
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if(tableView == self.dbTableView){
        
    }
    else if(tableView == self.weatherView.forcastTableview){
        NSLog(@"click cell");

        
    }
}

#pragma segue functions
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
}
#pragma mark - HttpClientRequestDelegete代理事件
- (void)getHttpResponseData:(NSData *)data{
    if (data == nil) {
        return;
    }
    //解析数据字典
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    //获取数组
    NSArray *array = dictionary[@"events"];
    //初始化数组
    self.array = [NSMutableArray array];
    //循环赋值
    for (NSDictionary *dic in array) {
        Activity *activity = [Activity new];
        //赋值
        [activity setValuesForKeysWithDictionary:dic];
        //添加到数组
        [self.array addObject:activity];
    }
    //刷新数据
    [self.activityTableView reloadData];
}
@end
