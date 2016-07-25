//
//  LoginTableViewCell.m
//  CityGuide
//
//  Created by zhuzai on 16/7/25.
//  Copyright © 2016年 zhuzai. All rights reserved.
//

#import "LoginTableViewCell.h"



@implementation LoginTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _loginHit = [UIButton buttonWithType:UIButtonTypeSystem];
        
        [_loginHit setTitle:@"haha" forState:UIControlStateNormal];
        
       
        _loginType.backgroundColor = [UIColor grayColor];
        
        [self.contentView addSubview:_loginType];
        [self.contentView addSubview:_loginHit];
    }
    
    return self;
}

@end
