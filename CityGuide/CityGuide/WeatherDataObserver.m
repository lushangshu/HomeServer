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

-(NSMutableArray *)parseWeatherData:(NSData *)respond{
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:respond options:kNilOptions error:nil];
    
    NSArray *array1 = [json objectForKey:@"HeWeather data service 3.0"];
    NSDictionary *dic = [array1 objectAtIndex:0];
    NSDictionary *CityArray = [dic objectForKey:@"basic"];
    NSString *cityName = [CityArray objectForKey:@"city"];//
    NSString *countryName = [CityArray objectForKey:@"cnty"];//
    
    NSArray *daily_forecast= [dic objectForKey:@"daily_forecast"];
    
    NSArray *temp = [[NSArray alloc]initWithObjects:cityName,countryName, nil];
    [array addObject:temp];
    
    for(int i=0;i<[daily_forecast count];i++){
        NSDictionary *dic = [daily_forecast objectAtIndex:i];
        NSString *hum = [dic objectForKey:@"hum"];
        NSDictionary *tmp = [dic objectForKey:@"tmp"];
        NSString *max_tmp = [tmp objectForKey:@"max"];//
        NSString *min_tmp = [tmp objectForKey:@"min"];//
        
        NSDictionary *cond = [dic objectForKey:@"cond"];//
        NSString *txt_d = [tmp objectForKey:@"txt_d"];//
        
        NSArray *temp = [[NSArray alloc]initWithObjects:hum,max_tmp,min_tmp,cond,txt_d, nil];
        [array addObject:temp];
    }
    
    
    
    NSLog(@"%@",array);
    return array;
    
}

@end
