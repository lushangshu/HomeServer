//
//  LightCell.h
//  CityGuide
//
//  Created by zhuzai on 16/7/26.
//  Copyright © 2016年 zhuzai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LightCell : UITableViewCell

@property (weak,nonatomic) IBOutlet UILabel *title;

-(void)configureCellData: (NSDictionary *)item;
-(NSDateFormatter *)dateFormatter;
@end
