//
//  GeocodeAnnotation.h
//  CityGuide
//
//  Created by zhuzai on 16/9/7.
//  Copyright © 2016年 zhuzai. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapCommonObj.h>

@interface GeocodeAnnotation : NSObject<MAAnnotation>

- (id)initWithGeocode:(AMapGeocode *)geocode;

@property (nonatomic, readonly, strong) AMapGeocode *geocode;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

/*!
 @brief 获取annotation标题
 @return 返回annotation的标题信息
 */
- (NSString *)title;

/*!
 @brief 获取annotation副标题
 @return 返回annotation的副标题信息
 */
- (NSString *)subtitle;

@end

