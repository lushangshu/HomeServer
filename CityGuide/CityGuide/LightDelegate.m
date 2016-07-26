//
//  LightDelegate.m
//  CityGuide
//
//  Created by zhuzai on 16/7/26.
//  Copyright © 2016年 zhuzai. All rights reserved.
//

#import "LightDelegate.h"

@implementation LightDelegate
#pragma mark UITableViewDelegate
-(void)didSelectRowAtIndexPath:(void (^)(id cell, NSIndexPath *indexPath))didSelectRowAtIndexPath{
    _didSelectRowAtIndexPath = [didSelectRowAtIndexPath copy];
}
-(void)didDeselectRowAtIndexPath:(void (^)(id cell, NSIndexPath *indexPath))didDeselectRowAtIndexPath{
    _didDeselectRowAtIndexPath = [didDeselectRowAtIndexPath copy];
}
-(void)willDisplayCell:(void (^)(id cell, NSIndexPath *indexPath))willDisplayCell{
    _willDisplayCell =  [willDisplayCell copy];
}
-(void)heightForRowAtIndexPath:(CGFloat (^)( NSIndexPath *indexPath))heightForRowAtIndexPath{
    _heightForRowAtIndexPath = [heightForRowAtIndexPath copy];
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (_didSelectRowAtIndexPath) {
        _didSelectRowAtIndexPath(cell,indexPath);
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (_didDeselectRowAtIndexPath) {
        _didDeselectRowAtIndexPath(cell,indexPath);
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_willDisplayCell) {
        _willDisplayCell(cell,indexPath);
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_heightForRowAtIndexPath) {
        return _heightForRowAtIndexPath(indexPath);
    }
    return tableView.rowHeight;
}
@end

