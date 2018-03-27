//
//  TSTableModelDelegate.h
//  TSTableViewExample
//
//  Created by liu on 2018/3/20.
//  Copyright © 2018年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 一些会用到的通用的方法
 */
@protocol TSTableModelDelegate <NSObject>

/**
 是否为组cell
 */
- (BOOL)isGroupCell;

@end
