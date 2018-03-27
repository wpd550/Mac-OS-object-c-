//
//  TSBaseTableViewModel.h
//  TSTableViewExample
//
//  Created by liu on 2018/3/15.
//  Copyright © 2018年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@import Cocoa;
@interface TSBaseTableViewModel : NSObject<NSTableViewDataSource>

@property (nonatomic, strong, readonly) NSMutableArray *contents;
@property (strong) NSNumber *checkBoxValue; ///< header CheckBox的绑定值

- (void)setupDefaults;
//---------------------------------------------------------------------------------
// 数据源管理
//---------------------------------------------------------------------------------
- (void)bindTableView:(id)tableView;
- (void)bindTableViewCheckBox:(id)checkBox;
- (void)unbindTableView:(id)tableView;

- (void)setCurrentColumnSortKey:(NSString *)sortKey;
/// 当前选中models
- (NSArray *)selectedObjects;
/// 当前选中indexes
- (NSIndexSet *)selectionIndexes;
/// 获取为分组类型时，返回是否去掉分组index的值
- (NSIndexSet *)realSelectionIndexesFromProposed:(NSIndexSet *)proposedIndexSet;
- (BOOL)setSelectionIndexes:(NSIndexSet *)indexes;
- (void)updateDataSources;
- (void)setSelectsInsertedObjects:(BOOL)select;

//---------------------------------------------------------------------------------
// 数据管理
//---------------------------------------------------------------------------------
- (void)resetDataContents;
- (void)addData:(id)data;
- (void)addDatas:(NSArray *)array;
/// 移除选中数据
- (void)removeData;

@end
