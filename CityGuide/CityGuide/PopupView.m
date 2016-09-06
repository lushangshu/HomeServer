//
//  PopupView.m
//  CityGuide
//
//  Created by zhuzai on 16/9/6.
//  Copyright © 2016年 zhuzai. All rights reserved.
//

#import "PopupView.h"
#import "UIViewController+LewPopupViewController.h"
#import "LewPopupViewAnimationFade.h"
#import "LewPopupViewAnimationSlide.h"
#import "LewPopupViewAnimationSpring.h"
#import "LewPopupViewAnimationDrop.h"

@implementation PopupView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil];
        _innerView.frame = frame;
        [self addSubview:_innerView];
    }
    self.searchType = @"小吃";
    return self;
}


+ (instancetype)defaultPopupView{
    return [[PopupView alloc]initWithFrame:CGRectMake(0, 0, 195, 210)];
}

- (IBAction)dismissAction:(id)sender{
    self.searchType = @"餐饮";
    [_parentVC lew_dismissPopupView];
}

- (IBAction)dismissViewFadeAction:(id)sender{
    self.searchType = @"娱乐";
    [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationFade new]];
}

- (IBAction)dismissViewSlideAction:(id)sender{
    self.searchType = @"电影院";
    LewPopupViewAnimationSlide *animation = [[LewPopupViewAnimationSlide alloc]init];
    animation.type = LewPopupViewAnimationSlideTypeTopBottom;
    [_parentVC lew_dismissPopupViewWithanimation:animation];
}

- (IBAction)dismissViewSpringAction:(id)sender{
    self.searchType = @"ktv";
    [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
}

- (IBAction)dismissViewDropAction:(id)sender{
    self.searchType = @"公厕";
    [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationDrop new]];
}
@end

