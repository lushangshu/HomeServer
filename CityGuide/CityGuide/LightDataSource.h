//
//  LightDataSource.h
//  CityGuide
//
//  Created by zhuzai on 16/7/26.
//  Copyright © 2016年 zhuzai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^TableViewCellConfigureBlock)(id cell,id item);
@interface LightDataSource : NSObject <UITableViewDataSource>
{
    NSString *_cellIdentifier;
    Class _cellClass;
    NSString *_cellNibName;
    TableViewCellConfigureBlock _configureCellBlock;
}

@property (nonatomic,strong) NSMutableArray *items;

-(id)initWithCellIdentifier:(NSString *)aCellIdentifier
                  cellClass:(Class)aCellClass
         configureCellBlock:(void(^)(id cell, id item))aConfigureCellBlock;

-(id)initWitCellIdentifier:(NSString *)aCellIdentifier
               cellNibName:(NSString *)nibname
        configureCellBlock:(void(^)(id cell,id item))aConfigureCellBlock;

@end
