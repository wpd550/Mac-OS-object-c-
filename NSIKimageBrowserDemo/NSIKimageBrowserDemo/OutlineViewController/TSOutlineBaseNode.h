//
//  TSOutlineBaseNode.h
//
//  Created by liu on 2018/3/5.
//  Copyright © 2018年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSOutlineBaseNode : NSObject

@property (nonatomic, strong) NSMutableArray *children; ///< 保存子节点
@property (assign) BOOL isLeaf;                         ///< 是否为叶节点

@end
