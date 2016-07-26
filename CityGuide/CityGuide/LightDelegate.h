//
//  LightDelegate.h
//  CityGuide
//
//  Created by zhuzai on 16/7/26.
//  Copyright © 2016年 zhuzai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^didSelectRowAtIndexPath)(id cell, NSIndexPath *indexPath);
typedef void (^didDeselectRowAtIndexPath)(id cell, NSIndexPath *indexPath);
typedef void (^willDisplayCell)(id cell, NSIndexPath *indexPath);

typedef CGFloat (^heightForRowAtIndexPath)(NSIndexPath *indexPath);

@interface LightDelegate : NSObject <UITableViewDelegate>
{
    didSelectRowAtIndexPath _didSelectRowAtIndexPath;
    didDeselectRowAtIndexPath _didDeselectRowAtIndexPath;
    willDisplayCell _willDisplayCell;
    heightForRowAtIndexPath _heightForRowAtIndexPath;
}

-(void)didSelectRowAtIndexPath:(void (^)(id cell, NSIndexPath *indexPath))didSelectRowAtIndexPath;
-(void)didDeselectRowAtIndexPath:(void (^)(id cell, NSIndexPath *indexPath))didDeselectRowAtIndexPath;
-(void)willDisplayCell:(void (^)(id cell, NSIndexPath *indexPath))willDisplayCell;

-(void)heightForRowAtIndexPath:(CGFloat (^)( NSIndexPath *indexPath))heightForRowAtIndexPath;

@end
