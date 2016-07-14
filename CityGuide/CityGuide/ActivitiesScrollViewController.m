//
//  ActivitiesScrollViewController.m
//  CityGuide
//
//  Created by zhuzai on 16/7/14.
//  Copyright © 2016年 zhuzai. All rights reserved.
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
    [LFLuisement selectTheSegument:2];
    self.LFLuisement = LFLuisement;
    [self.view addSubview:LFLuisement];
    
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
    
    //添加滚动显示的4个对应的界面view
//    for (int i = 0; i < 4; i++) {
//        UIView *viewExample = [[UIView alloc]initWithFrame:CGRectMake(self_Width *i, 0, self_Width,self_Height)];
//        viewExample.backgroundColor = [UIColor whiteColor];
//        [self.mainScrollView addSubview:viewExample];
//    }
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
    [params setObject:@"3" forKey:@"count"];
    [manager GET:@"https://api.weibo.com/2/statuses/public_timeline.json?"
      parameters:params progress:^(NSProgress * Nonnull){
          NSLog(@"Activities Nearby");
      }
         success:^(NSURLSessionTask *task,id responseObject){
             
             NSDictionary *dic = responseObject;
//             NSString *userName = [dic valueForKey:@"screen_name"];
//             NSString *fCount = [[NSString alloc] initWithFormat:@"%@",[dic valueForKey:@"followers_count"]];
//             NSString *frinedsCount = [[NSString alloc] initWithFormat:@"%@",[dic valueForKeyPath:@"friends_count"]];
//             NSString *avatarURL = [dic valueForKeyPath:@"avatar_hd"];
             //[label setText:[NSString stringWithFormat:dic]];
             NSLog(@"%@",responseObject);
             //[viewExample addSubview:label];
             
         }failure:^(NSURLSessionTask *operation,NSError *error){
             NSLog(@"&&&& %@",error);
         }];
    
    return viewExample;
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
 *
 *  @param selection 对应下标 begain 0
 */
-(void)uisegumentSelectionChange:(NSInteger)selection{
    //    加入动画,显得不太过于生硬切换
    [UIView animateWithDuration:.2 animations:^{
        [self.mainScrollView setContentOffset:CGPointMake(self_Width *selection, 0)];
    }];
}



@end
