//
//  weatherView.m
//  CityGuide
//
//  Created by zhuzai on 16/7/28.
//  Copyright © 2016年 zhuzai. All rights reserved.
//

#import "weatherView.h"
#import "FetchWeatherInfo.h"


@implementation weatherView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.cityName.text = @"kunming";
    
    //[self FetchWeatherData];
}

-(void)FetchWeatherData{
    NSString *httpUrl = @"http://apis.baidu.com/heweather/weather/free";
    NSString *httpArg = @"city=beijing";
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, httpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"e84f8a92cdab94f1dc4580407b9118c1" forHTTPHeaderField: @"apikey"];
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
                               } else {
                                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                   NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   //NSLog(@"HttpResponseCode:%ld", responseCode);
                                   NSMutableArray *array = [self.weather parseWeatherData:data];
                                   NSLog(@"%@",array);
                                   //NSLog(@"HttpResponseBody %@",responseString);
                               }
                           }];
}

-(IBAction)show{
    NSLog(@"click click click");
}

@end
