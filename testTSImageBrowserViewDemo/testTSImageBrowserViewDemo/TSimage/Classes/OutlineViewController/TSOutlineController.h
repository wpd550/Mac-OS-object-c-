//
//  TSOutlineController.h
//
//  Created by liu on 2018/3/5.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "TSBaseViewController.h"
#import "TSBaseOutlineView.h"

@class TSOutlineBaseNode;
@class TSBaseOutlineViewModel;
@interface TSOutlineController : TSBaseViewController<NSOutlineViewDelegate, NSOutlineViewDataSource>

@property (weak) IBOutlet TSBaseOutlineView *outlineView;


/**
 设置DataSource
 
 每次有新ViewModel时需重新设置
 */
- (void)setOutlineViewDataSourceToViewModel:(__kindof TSBaseOutlineViewModel *)baseViewModel;


/**
 选中行变化回调
 
 已经变化之后回调
 */
- (void)selectedRowDidChange;

/**
 选中行将要变化回调

 @param selectionIndexes 将要变化的值
 */
- (void)selectedRowWillChange:(NSIndexSet *)selectionIndexes;


/**
 获取选中个数

 @param selectCountBlock totalCount总选中数，leafCount叶节点数，internalCount内部节点数
 */
- (void)didSelectObjectCount:(void (^)(NSInteger totalCount, NSInteger leafCount, NSInteger internalCount))selectCountBlock;

@end
