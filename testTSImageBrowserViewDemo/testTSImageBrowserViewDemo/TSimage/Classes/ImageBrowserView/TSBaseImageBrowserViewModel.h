//
//  TSBaseImageBrowserViewModel.h
//  TSTableViewExample
//
//  Created by liu on 2018/3/21.
//  Copyright © 2018年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@import Quartz;
@interface TSBaseImageBrowserViewModel : NSObject

@property (strong, readonly) id arrangedObjects;
@property (strong) NSIndexSet *selectionIndexes;
@property (strong) NSMutableArray *contents;

- (void)setReloadDataCallBack:(void(^)(void))reloadBlock;
//---------------------------------------------------------------------------------
// 数据源管理
//---------------------------------------------------------------------------------

//---------------------------------------------------------------------------------
// 数据管理
//---------------------------------------------------------------------------------
- (void)setImageBrowserDatas:(NSDictionary *)datas withSortGroupTitles:(NSArray *)sortTitles;
- (void)resetDataContents;
- (void)addData:(id)data;
/// 移除选中数据
- (void)removeData;

@end
