//
//  MovieAndBooksView.m
//  CityGuide
//
//  Created by zhuzai on 16/7/26.
//  Copyright © 2016年 zhuzai. All rights reserved.
//

#import "MovieAndBooksView.h"
#define self_Width CGRectGetWidth([UIScreen mainScreen].bounds)
#define self_Height CGRectGetHeight([UIScreen mainScreen].bounds)

@implementation MovieAndBooksView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = @"data";
    return cell;
}
@end
