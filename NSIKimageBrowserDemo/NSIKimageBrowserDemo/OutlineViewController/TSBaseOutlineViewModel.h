//
//  TSBaseOutlineViewModel.h
//  TSTableViewExample
//
//  Created by liu on 2018/3/16.
//  Copyright © 2018年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSOutlineBaseNode.h"

@import Cocoa;
@interface TSBaseOutlineViewModel : NSObject<NSOutlineViewDataSource>
@property (strong) NSMutableArray *contents;

//---------------------------------------------------------------------------------
// 数据源管理
//---------------------------------------------------------------------------------
- (void)bindOutlineView:(id)outlineView;
- (void)unbindOutlineView:(id)outlineView;

/// 当前选中models
- (NSArray *)selectedObjects;
/// 当前选中indexPaths
- (NSArray<NSIndexPath *> *)selectionIndexPaths;
- (void)setSelectsInsertedObjects:(BOOL)isSelect;
- (BOOL)setSelectionIndexes:(NSIndexPath *)selectionIndexes;

//---------------------------------------------------------------------------------
// 数据管理
//---------------------------------------------------------------------------------

/**
 添加数据
 
 数据结构基本为：
 数组为例：
 @[Node, Node, Node]
 Node--|-isLeaf
       |-children--@[Node, Node]
 
 @param entries 数据实体
 @param flag 占位标志(暂时无具体作用)
 */
- (void)addEntries:(id)entries flag:(BOOL)flag;

/**
 添加新节点
 
 添加Node的位置为当前选中Node(如果为leaf则取父Node，否则就添加到此Node的子Node中)
 
 @param node 新添加的节点
 */
- (void)addNode:(__kindof TSOutlineBaseNode *)node;

/// 移除当前选中的节点
- (void)removeNode;

/// 清除当前数据
- (void)resetDataContents;

@end
