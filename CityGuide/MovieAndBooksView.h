//
//  MovieAndBooksView.h
//  CityGuide
//
//  Created by zhuzai on 16/7/26.
//  Copyright © 2016年 zhuzai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieAndBooksView : UITableView <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UITableViewCell *cell;

@end
