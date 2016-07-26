//
//  LightDataSource.m
//  CityGuide
//
//  Created by zhuzai on 16/7/26.
//  Copyright © 2016年 zhuzai. All rights reserved.
//

#import "LightDataSource.h"

@implementation LightDataSource

-(id)init{
    return nil;
}

-(id)initWithCellIdentifier:(NSString *)aCellIdentifier cellClass:(Class)aCellClass configureCellBlock:(void (^)(id, id))aConfigureCellBlock{
    self = [super init];
    if(self){
        _cellIdentifier = aCellIdentifier;
        _configureCellBlock = [aConfigureCellBlock copy];
        _cellClass = aCellClass;
        _cellNibName = nil;
    }
    
    return self;
}

-(id)initWitCellIdentifier:(NSString *)aCellIdentifier cellNibName:(NSString *)nibname configureCellBlock:(void (^)(id, id))aConfigureCellBlock{
    
    self = [super init];
    if(self){
        _cellIdentifier = aCellIdentifier;
        _configureCellBlock = [aConfigureCellBlock copy];
        _cellClass = nil;
        _cellNibName = nibname;
    }
    
    return self;
}

#pragma mark UITableviewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_cellClass!=nil){
        [tableView registerClass:_cellClass forCellReuseIdentifier:_cellIdentifier];
        if([UINib nibWithNibName:[_cellClass description] bundle:nil]!=nil){
            NSLog(@"xib exists");
        }
    }
    if(_cellNibName!=nil){
        [tableView registerNib:[UINib nibWithNibName:[_cellNibName description] bundle:nil] forCellReuseIdentifier:_cellIdentifier];
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier forIndexPath:indexPath];
    
    id item = _items[indexPath.row];
    if(_configureCellBlock){
        _configureCellBlock(cell,item);
    }
    
    return cell;
}





@end
