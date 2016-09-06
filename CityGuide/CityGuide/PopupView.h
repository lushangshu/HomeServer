//
//  PopupView.h
//  CityGuide
//
//  Created by zhuzai on 16/9/6.
//  Copyright © 2016年 zhuzai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopupView : UIView
@property (nonatomic, strong)IBOutlet UIView *innerView;
@property (nonatomic, weak)UIViewController *parentVC;
@property (nonatomic,strong)NSString *searchType;

+ (instancetype)defaultPopupView;
@end
