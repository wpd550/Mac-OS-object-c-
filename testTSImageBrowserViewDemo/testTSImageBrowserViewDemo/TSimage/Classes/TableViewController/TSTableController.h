//
//  TSTableController.h
//
//  Created by liu on 2018/2/27.
//  Copyright © 2018年 Tenorshare Developer. All rights reserved.
//

#import "TSBaseViewController.h"
#import "TSBaseTableView.h"

@class TSBaseTableViewModel;
@class TSCheckBoxTableCellView;
@interface TSTableController : TSBaseViewController <NSTableViewDelegate>

@property (weak) IBOutlet TSBaseTableView *tableView;

@property (assign) BOOL needRemoveGroupIndexes;

/**
 设置DataSource
 
 每次有新ViewModel需要重新设置
 */
- (void)setTableViewDataSourceToViewModel:(__kindof TSBaseTableViewModel *)baseViewModel;

/**
 table行选择变化后，响应函数，可供子类重写
 */
- (void)selectedRowDidChange;


/**
 table行选中将要变化，响应函数，供重写

 @param selectionIndexes 将要选中的selectionIndexes
 */
- (void)selectedRowWillChange:(NSIndexSet *)selectionIndexes;


/**
 添加CheckBox列

 @param index 第几列
 */
- (void)addCheckBoxForTableViewColumn:(NSInteger)index;

/// 头CheckBox点击回调
- (void)headCheckBoxDidClick:(NSButton *)checkBox;
/// cell checkBox点击回调
- (void)cellCheckBoxDidClick:(NSButton *)checkBox;

/**
 需要绑定cell CheckBox回调

 方法会在每次要显示cellView的时候回调
 
 @param cellView 需要绑定的CheckBox所在View
 @param row cell所在row
 */
- (void)bindTableCellViewCheckBox:(__kindof TSCheckBoxTableCellView *)cellView atRow:(NSInteger)row;

@end
