//
//  LightCell.m
//  CityGuide
//
//  Created by zhuzai on 16/7/26.
//  Copyright © 2016年 zhuzai. All rights reserved.
//

#import "LightCell.h"

@implementation LightCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        label.text = @"error";
        [self.contentView addSubview:label];
    }
    
    return self;
}

-(NSDateFormatter *)dateFormatter{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.timeStyle = NSDateFormatterMediumStyle;
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        
    }
    return dateFormatter;
}


@end
