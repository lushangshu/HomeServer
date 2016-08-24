//
//  MapViewController.m
//  CityGuide
//
//  Created by zhuzai on 16/7/4.
//  Copyright © 2016年 zhuzai. All rights reserved.
//

#import "MapViewController.h"

#define self_Width CGRectGetWidth([UIScreen mainScreen].bounds)
#define self_Height CGRectGetHeight([UIScreen mainScreen].bounds)

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize mapView     = _mapView;
@synthesize search      = _search;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.MaptableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, self_Width, self_Height) style: UITableViewStylePlain];
    
    self.MaptableView.dataSource = self;
    self.MaptableView.delegate = self;
    
    
    self.MaptableView.backgroundColor = [UIColor grayColor];
    
    
    [self.view addSubview:self.MaptableView];
    [self initMapView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initMapView
{
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.frame];
    
    self.mapView.mapType = MAMapTypeStandard;
    self.mapView.zoomLevel = 17.5;
    self.mapView.cameraDegree = 55.f;
    
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    
    self.mapView.scrollEnabled       = YES;
    self.mapView.zoomEnabled         = YES;
    self.mapView.rotateEnabled       = YES;
    self.mapView.rotateCameraEnabled = YES;
    
    self.mapView.delegate = nil;
    //self.mapView.clipsToBounds = NO;
    [self.MaptableView reloadData];
}


#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    //return [self.loginList count];
    if(section == 0){
        return 1;
    }
    else if(section == 1){
        return 3;
    }
    else if(section ==2){
        return 1;
    }
    else return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section==2){
        return @"信息";
        
    }
    else if(section ==1){
        return @"附近POI";
    }
    else{
        return @"";
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section:(NSInteger)section{
    

        return 3.0;
    
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    if(indexPath.section ==0){
        self.mapView.frame = CGRectMake(0, 0, self_Width, self_Height*0.75);
        [cell addSubview:self.mapView];
//        cell.detailTextLabel.text = @"基础信息1";
//        cell.textLabel.text = @"基础信息";
//        cell.textLabel.textColor = [UIColor grayColor];
    }
    else if(indexPath.section == 1){
        
        switch (indexPath.row) {
            case 0:
                cell.detailTextLabel.text = @"开发中……";
                cell.textLabel.text = @"开发中……";
                cell.textLabel.textColor = [UIColor darkGrayColor];
                break;
                break;
            case 1:
                cell.detailTextLabel.text = @"开发中……";
                cell.textLabel.text = @"开发中……";
                cell.textLabel.textColor = [UIColor darkGrayColor];
                break;
            case 2:
                cell.detailTextLabel.text = @"开发中……";
                cell.textLabel.text = @"开发中……";
                cell.textLabel.textColor = [UIColor darkGrayColor];
                break;
            default:
                break;
        }
    }
    else if(indexPath.section==2){
        cell.detailTextLabel.text = @"点击进入设置界面";
        cell.textLabel.text = @"设置";
        cell.imageView.image = nil;
        cell.textLabel.textColor = [UIColor grayColor];
    }
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:60.0f];
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return self_Height*0.75;
    }
    else{
        return 160;
    }
    
}
-(NSInteger) tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    首先是用indexPath获取当前行的内容
    NSInteger row = [indexPath row];
    if(row == 0){
        
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
}@end
