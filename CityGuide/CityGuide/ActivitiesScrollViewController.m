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
#import "weatherView.h"

#define self_Width CGRectGetWidth([UIScreen mainScreen].bounds)
#define self_Height CGRectGetHeight([UIScreen mainScreen].bounds)

@interface ActivitiesScrollViewController ()<LFLUISegmentedControlDelegate,UIScrollViewDelegate>

@property(nonatomic, strong)UIScrollView *mainScrollView; /**< 正文mainSV */
@property (nonatomic ,strong)LFLUISegmentedControl * LFLuisement; /**< LFLuisement */

@end

@implementation ActivitiesScrollViewController
@synthesize listData=_listData;
@synthesize tableView = _tableView;
@synthesize tableViewCell =_tableViewCell;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    LFLUISegmentedControl* LFLuisement=[[LFLUISegmentedControl alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
    
    LFLuisement.delegate = self;
    NSArray* LFLarray=[NSArray arrayWithObjects:@"今日话题",@"附近好玩",@"随便看看",@"天气咋样",nil];
    [LFLuisement AddSegumentArray:LFLarray];
    [LFLuisement selectTheSegument:0];
    self.LFLuisement = LFLuisement;
    [self.view addSubview:LFLuisement];
    
    self.dbListData = [NSArray arrayWithObjects:@"1",@"2",@"3db", nil];
    
    [self createMainScrollView];
}
- (void)createMainScrollView {
    CGFloat begainScrollViewY = 37+ 64;
    self.mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, begainScrollViewY, self_Width,(self_Height -begainScrollViewY))];
    self.mainScrollView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:self.mainScrollView];
    self.mainScrollView.bounces = NO;
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.contentSize = CGSizeMake(self_Width * 4, (self_Height -begainScrollViewY));
    //设置代理
    self.mainScrollView.delegate = self;

    [self.mainScrollView addSubview:[self TopicsView]];
    [self.mainScrollView addSubview:[self NearbyView]];
    [self.mainScrollView addSubview:[self RandomImagesView]];
    [self.mainScrollView addSubview:[self WheatherView]];
}

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
             
             NSArray *dic = [responseObject objectForKey:@"statuses"];
             NSMutableArray *result = [[NSMutableArray alloc]init];
             result = [self parseJsonData:dic];
             //NSLog(@"%@",result);
             self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(self_Width *0, 0, self_Width, self_Height)];
             self.tableView.delegate=self;
             self.tableView.dataSource=self;
             //把tabView添加到视图之上
             [viewExample addSubview:self.tableView];
             //    存放显示在单元格上的数据
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
    UILabel *labelTest = [[UILabel alloc]initWithFrame:CGRectMake(3, 3, 100, 100)];
    labelTest.text = @"fujin";
    [viewExample addSubview:labelTest];
    return viewExample;
}

-(UIView* )RandomImagesView{
    UIView *viewExample = [[UIView alloc]initWithFrame:CGRectMake(self_Width *2, 0, self_Width,self_Height)];
    viewExample.backgroundColor = [UIColor whiteColor];
    self.dbTableView = [[UITableView alloc]initWithFrame:CGRectMake(self_Width *0, 0, self_Width, self_Height)];
    self.dbTableView.delegate=self;
    self.dbTableView.dataSource=self;
    [self.dbTableView reloadData];
    [viewExample addSubview:self.dbTableView];
    return viewExample;
}

-(UIView* )WheatherView{
    UIView *viewExample = [[UIView alloc]initWithFrame:CGRectMake(self_Width *3, 0, self_Width,self_Height)];
    viewExample.backgroundColor = [UIColor whiteColor];
    UILabel *labelTest = [[UILabel alloc]initWithFrame:CGRectMake(3, 3, 100, 100)];
    labelTest.text = @"tianqiqingkuang";
    WeatherDataObserver *wea = [[WeatherDataObserver alloc]init];
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
                                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                   NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   NSMutableArray *array = [wea parseWeatherData:data];
                                   labelTest.text = responseString;
                                   //NSLog(@"HttpResponseCode:%ld", responseCode);
                                   //NSLog(@"HttpResponseBody %@",responseString);
                               }
                           }];
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"weatherView" owner:self options:nil];
    weatherView *weather  = [nibContents lastObject];
    [viewExample addSubview:weather];
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

-(NSMutableArray *) parseJsonData: (NSArray *) json
{
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    for (int i=0;i< [json count];i++)
    {
        NSDictionary *subject = [json objectAtIndex:i];
        NSString *created_at = [subject objectForKey:@"created_at"];
        NSString *text = [subject objectForKey:@"text"];
        NSDictionary *test3 = [subject objectForKey:@"user"];
        
        NSString *avatar_hd = [test3 objectForKey:@"avatar_large"];
        NSString *screen_name = [test3 objectForKey:@"screen_name"];
        
        NSArray *array = [[NSArray alloc]initWithObjects:created_at,text,avatar_hd,screen_name, nil];
        [resultArray addObject:array];
    }
    return resultArray;
}

#pragma mark --- UIScrollView代理方法

static NSInteger pageNumber = 0;

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    pageNumber = (int)(scrollView.contentOffset.x / self_Width + 0.5);
    [self.LFLuisement selectTheSegument:pageNumber];
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
    else{
        return [self.dbListData count];
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
            UILabel *screenName = [[UILabel alloc]initWithFrame:CGRectMake(65, 3, self_Width-50, 30)];
            [contentLabel setNumberOfLines:0];
            contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
            [cell.contentView.superview setClipsToBounds:NO];
            [contentLabel setText:[[self.listData objectAtIndex:row] objectAtIndex:1]];
            [screenName setText:[[self.listData objectAtIndex:row]objectAtIndex:3]];
            CGSize size = [contentLabel sizeThatFits:CGSizeMake(contentLabel.frame.size.width,MAXFLOAT)];
            contentLabel.frame = CGRectMake(3, 70, self_Width-10, size.height);
            contentLabel.font = [UIFont boldSystemFontOfSize:12.0f];
            screenName.font = [UIFont boldSystemFontOfSize:10.0f];
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
    else{
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
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self_Height/2.2;
    
}
-(NSInteger) tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSString *rowValue = [[self.listData objectAtIndex:row] objectAtIndex:1];
    NSString *message = [[NSString alloc]initWithFormat:@"You selected%@",rowValue];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                   message:message
                                                  delegate:self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles: nil];
    [alert show];
}
@end
