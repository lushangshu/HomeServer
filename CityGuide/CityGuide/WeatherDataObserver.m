//
//  WeatherDataObserver.m
//  CityGuide
//
//  Created by zhuzai on 16/7/27.
//  Copyright © 2016年 zhuzai. All rights reserved.
//

#import "WeatherDataObserver.h"

@implementation WeatherDataObserver

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"old %@",[change objectForKey:NSKeyValueChangeOldKey]);
    
    NSLog(@"context:%@",context);
}

@end
