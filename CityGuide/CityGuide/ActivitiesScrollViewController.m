//
//  ActivitiesScrollViewController.m
//  CityGuide
//
//  Created by lushangshu on 16/7/14.
//  Copyright © 2016年 lushangshu. All rights reserved.
//

#import "ActivitiesScrollViewController.h"
#import "LFLUISegmentedControl.h"

#import "AFNetworking.h"

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
    //    1.初次创建：
    LFLUISegmentedControl* LFLuisement=[[LFLUISegmentedControl alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
    LFLuisement.delegate = self;
    //   2.设置显示切换标题数组
    NSArray* LFLarray=[NSArray arrayWithObjects:@"今日话题",@"附近好玩",@"随便看看",@"天气咋样",nil];
    [LFLuisement AddSegumentArray:LFLarray];
    //   default Select the Button
    [LFLuisement selectTheSegument:0];
    self.LFLuisement = LFLuisement;
    [self.view addSubview:LFLuisement];
    
    [self createMainScrollView];
    // Do any additional setup after loading the view, typically from a nib.

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
    NSLog(@"dao le zhe li access token is %@",wbtoken);
    [params setObject: wbtoken forKey:@"access_token"];
    [params setObject:@"20" forKey:@"count"];
    [manager GET:@"https://api.weibo.com/2/statuses/public_timeline.json?"
      parameters:params progress:^(NSProgress * Nonnull){
          NSLog(@"Activities Nearby");
      }
         success:^(NSURLSessionTask *task,id responseObject){
             
             NSArray *dic = [responseObject objectForKey:@"statuses"];
             NSMutableArray *result = [[NSMutableArray alloc]init];
             result = [self parseJsonData:dic];
             NSLog(@"%@",result);
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

-(NSMutableArray *) parseJsonData: (NSArray *) json
{
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    for (int i=0;i< [json count];i++)
    {
        NSDictionary *subject = [json objectAtIndex:i];
        NSString *created_at = [subject objectForKey:@"created_at"];
        NSString *text = [subject objectForKey:@"text"];
        NSDictionary *test3 = [subject objectForKey:@"user"];
        
        NSString *avatar_hd = [test3 objectForKey:@"avatar_hd"];
        NSString *screen_name = [test3 objectForKey:@"screen_name"];
        
        NSArray *array = [[NSArray alloc]initWithObjects:created_at,text,avatar_hd,screen_name, nil];
        [resultArray addObject:array];
    }
    return resultArray;
}

-(UIView* )NearbyView{
    UIView *viewExample = [[UIView alloc]initWithFrame:CGRectMake(self_Width *1, 0, self_Width,self_Height)];
    viewExample.backgroundColor = [UIColor whiteColor];
    
    return viewExample;
}

-(UIView* )RandomImagesView{
    UIView *viewExample = [[UIView alloc]initWithFrame:CGRectMake(self_Width *2, 0, self_Width,self_Height)];
    viewExample.backgroundColor = [UIColor whiteColor];
    
    return viewExample;
}

-(UIView* )WheatherView{
    UIView *viewExample = [[UIView alloc]initWithFrame:CGRectMake(self_Width *3, 0, self_Width,self_Height)];
    viewExample.backgroundColor = [UIColor whiteColor];
    
    return viewExample;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark --- UIScrollView代理方法

static NSInteger pageNumber = 0;

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    pageNumber = (int)(scrollView.contentOffset.x / self_Width + 0.5);
    //    滑动SV里视图,切换标题
    [self.LFLuisement selectTheSegument:pageNumber];
}

#pragma mark ---LFLUISegmentedControlDelegate
/**
 *  点击标题按钮
 *  @param selection 对应下标 begain 0
 */
-(void)uisegumentSelectionChange:(NSInteger)selection{
    //    加入动画,显得不太过于生硬切换
    [UIView animateWithDuration:.1 animations:^{
        [self.mainScrollView setContentOffset:CGPointMake(self_Width *selection, 0)];
    }];
}

#pragma mark - tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    声明静态字符串型对象，用来标记重用单元格
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
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
    //    获取当前行信息值
    NSUInteger row = [indexPath row];
    //    填充行的详细内容
    cell.detailTextLabel.text = [[self.listData objectAtIndex:row] objectAtIndex:3];
    //    把数组中的值赋给单元格显示出来
    cell.textLabel.text=[[self.listData objectAtIndex:row] objectAtIndex:1];
    //    cell.textLabel.backgroundColor= [UIColor greenColor];
    //    表视图单元提供的UILabel属性，设置字体大小
    cell.textLabel.font = [UIFont boldSystemFontOfSize:10.0f];
    //    tableView.editing=YES;
    /*
     cell.textLabel.backgroundColor = [UIColor clearColor];
     UIView *backgroundView = [[UIView alloc] initWithFrame:cell.frame];
     backgroundView.backgroundColor = [UIColor greenColor];
     cell.backgroundView=backgroundView;
     */
    //    设置单元格UILabel属性背景颜色
    NSString *url = [[self.listData objectAtIndex:row] objectAtIndex:2];
    NSURL *avatarUrl = [NSURL URLWithString:url];
    [self downloadImageWithURL:avatarUrl completionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded) {
            // change the image in the cell
             cell.imageView.image = image;
        }
    }];
    
    cell.textLabel.backgroundColor=[UIColor clearColor];
    //    被选中后高亮显示的照片
    UIImage *highLightImage = [UIImage imageNamed:@"1.png"];
    cell.imageView.highlightedImage = highLightImage;
    return cell;  
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
    
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
    NSString *rowValue = [self.listData objectAtIndex:row];
    NSString *message = [[NSString alloc]initWithFormat:@"You selected%@",rowValue];
    //    弹出警告信息
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                   message:message
                                                  delegate:self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles: nil];
    [alert show];
}
@end
