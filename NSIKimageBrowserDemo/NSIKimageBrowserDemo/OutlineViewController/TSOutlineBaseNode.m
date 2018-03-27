//
//  TSOutlineBaseNode.m
//
//  Created by liu on 2018/3/5.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "TSOutlineBaseNode.h"

//---------------------------------------------------------------------------------
// 数据模型
//
// TODO: 后面许多节点等功能在此模型中实现
//---------------------------------------------------------------------------------

@implementation TSOutlineBaseNode

- (NSMutableArray *)children {
    if (_children == nil) {
        _children = [[NSMutableArray alloc] init];
    }
    
    return  _children;
}

@end
