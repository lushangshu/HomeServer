//
//  NearbyActivityCell.m
//  CityGuide
//
//  Created by zhuzai on 16/8/18.
//  Copyright © 2016年 zhuzai. All rights reserved.
//

#import "NearbyActivityCell.h"

@implementation NearbyActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.conView.layer.masksToBounds = YES;
    self.conView.layer.cornerRadius = 5;
    //设置detailsView圆角
    self.detailsView.layer.masksToBounds = YES;
    self.detailsView.layer.cornerRadius = 5;
    //设置感兴趣和参加人数颜色
    self.interestNum.textColor = [UIColor redColor];
    self.takeinNum.textColor = [UIColor redColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setActivity:(Activity *)activity{
    //图片
    NSURL *avatarUrl = [NSURL URLWithString:activity.image];
    UIImage *himage = [UIImage imageWithData:[NSData dataWithContentsOfURL:avatarUrl]];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = himage;
    
    //[self.image sd_setImageWithURL:[NSURL URLWithString:activity.image] placeholderImage:[UIImage imageNamed:@"picholder"]];
    //标题
    self.title.text = activity.title;
    //日期
    self.date.text = [NSString stringWithFormat:@"%@ -- %@",activity.begin_time,activity.end_time];
    //地点
    self.locate.text = activity.address;
    //类别
    self.type.text = [NSString stringWithFormat:@"类型: %@",activity.category_name];
    //感兴趣人数
    self.interestNum.text = [NSString stringWithFormat:@"%d",activity.wisher_count];
    //参与人数
    self.takeinNum.text = [NSString stringWithFormat:@"%d",activity.participant_count];
}

@end
