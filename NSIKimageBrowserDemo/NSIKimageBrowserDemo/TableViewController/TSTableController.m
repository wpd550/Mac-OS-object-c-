//
//  TSTableController.m
//
//  Created by liu on 2018/2/27.
//  Copyright © 2018年 Tenorshare Developer. All rights reserved.
//
#import "TSTableController.h"
#import "TSCheckBoxTableCellView.h"
#import "TSBaseTableViewModel.h"
#import "TSTableModelDelegate.h"

@interface TSTableController ()
@property (weak) TSBaseTableViewModel *baseViewModel;
@end

@implementation TSTableController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - 私有方法

- (void)setupDefaults {
    
}

/// 子类请调super
- (void)setupUI {
    self.tableView.delegate = self;
    
    if (_baseViewModel != nil) {
        [self setTableViewDataSourceToViewModel:_baseViewModel];
    }
}

#pragma mark - NSTableViewDelegate
// 提问：如果子类重写了这个方法，这里会不会出问题呢？
// 答：重写之后，自己在所需的一些条件下做处理，然后其他的情况还是调super就行了
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSString *columnIdentifier = tableColumn.identifier;
    NSTableCellView *view = [tableView makeViewWithIdentifier:columnIdentifier owner:nil];
//    if ([self tableView:self.tableView isGroupRow:row]) {
//        NSString *identifier = tableView.tableColumns[1].identifier;
//        view = [tableView makeViewWithIdentifier:identifier owner:self];
//        view.textField.stringValue = @"Group";
//        return view;
//    }
    
    NSString *checkBoxIdentifier = [self.tableView getCheckBoxColumnIdentifier];
    if ([columnIdentifier isEqualToString:checkBoxIdentifier]) {
        TSCheckBoxTableCellView *cellView = nil;
        if (![view isKindOfClass:[TSCheckBoxTableCellView class]]) {
            cellView = [[TSCheckBoxTableCellView alloc] init];
        } else {
            cellView = (TSCheckBoxTableCellView *)view;
        }
        cellView.checkBox.target = self;
        cellView.checkBox.action = @selector(cellCheckBoxDidClick:);
        cellView.checkBox.tag = row;
        
        [self bindTableCellViewCheckBox:cellView atRow:row];
        
        return cellView;
    }

    return view;
}

- (BOOL)tableView:(NSTableView *)tableView shouldReorderColumn:(NSInteger)columnIndex toColumn:(NSInteger)newColumnIndex {
    NSInteger checkBoxIndex = [self.tableView getCheckBoxColumnIndex];
    if (columnIndex == checkBoxIndex || newColumnIndex == checkBoxIndex) { // 禁止check列拖动
        return NO;
    }
    
    return YES;
}

- (BOOL)tableView:(NSTableView *)tableView isGroupRow:(NSInteger)row {
    id cellModel = self.baseViewModel.contents[row];
    if ([cellModel conformsToProtocol:@protocol(TSTableModelDelegate)]) {
        if ([cellModel respondsToSelector:@selector(isGroupCell)]) {
            return [cellModel isGroupCell];
        }
    }
    
    return NO;
}

// did change回调
- (void)tableViewSelectionDidChange:(NSNotification *)notification {
   
    [self selectedRowDidChange];
}

// will change回调(可用来在选中过程中, 刷新一些UI)
- (NSIndexSet *)tableView:(NSTableView *)tableView selectionIndexesForProposedSelection:(NSIndexSet *)proposedSelectionIndexes {
    
    NSIndexSet *realSet = [self.baseViewModel realSelectionIndexesFromProposed:proposedSelectionIndexes];
    
    // 回调方法
    [self selectedRowWillChange:realSet];
    
    return realSet;
}

- (void)tableView:(NSTableView *)tableView mouseDownInHeaderOfTableColumn:(NSTableColumn *)tableColumn {
    //如果设置了sort key,sortDescriptorsDidChange就会触发
    [self.baseViewModel setCurrentColumnSortKey:tableColumn.sortDescriptorPrototype.key];
    
    // 点击tableColumn是TableView的selectIndex会和arrayController的selectIndex产生差异(TableView会deselect所有的cell)，这里强行同步一下
    [self.baseViewModel setSelectionIndexes:nil];
}

#pragma mark - 事件响应

- (void)headCheckBoxDidClick:(NSButton *)checkBox {
    if (checkBox.state == NSOffState) {
        [self.baseViewModel setSelectionIndexes:nil];
    } else {
        NSIndexSet *allIndexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.baseViewModel.contents.count)];
        [self.baseViewModel setSelectionIndexes:[self.baseViewModel realSelectionIndexesFromProposed:allIndexSet]];
    }
}

- (void)cellCheckBoxDidClick:(NSButton *)checkBox {
    NSMutableIndexSet *select = [[NSMutableIndexSet alloc] initWithIndexSet:[self.baseViewModel selectionIndexes]];
    if ([select containsIndex:checkBox.tag]) {
        [select removeIndex:checkBox.tag];
    } else {
        [select addIndex:checkBox.tag];
    }
    
    [self.baseViewModel setSelectionIndexes:select];
}

#pragma mark - 公共方法

- (void)selectedRowDidChange {
    
}

- (void)selectedRowWillChange:(NSIndexSet *)selectionIndexes {
    
}

- (void)addCheckBoxForTableViewColumn:(NSInteger)index {
    [self.tableView addCheckBoxForTableColumn:index];
    [self.tableView.headCheckBox setTarget:self];
    [self.tableView.headCheckBox setAction:@selector(headCheckBoxDidClick:)];
    [self.baseViewModel bindTableViewCheckBox:self.tableView.headCheckBox];
}

- (void)setRightMouseMenu:(NSMenu *(^)(NSInteger))menuBlock {
    [self.tableView setRightMouseMenu:menuBlock];
}

- (void)bindTableCellViewCheckBox:(__kindof TSCheckBoxTableCellView *)cellView atRow:(NSInteger)row {
    NSTableRowView *rowView = [self.tableView rowViewAtRow:row makeIfNecessary:YES];
    
    [cellView.checkBox bind:NSValueBinding toObject:rowView withKeyPath:@"selected" options:nil];
}

#pragma mark - Setter && Getter

- (void)setTableViewDataSourceToViewModel:(__kindof TSBaseTableViewModel *)baseViewModel {
    if (_baseViewModel != baseViewModel) {
        [_baseViewModel unbindTableView:self.tableView];
    }
    _baseViewModel = baseViewModel;
    
    // 先绑定后设置数据源，Xcode就不会提示DataSource required的方法没有实现
    [_baseViewModel bindTableView:self.tableView];
    self.tableView.dataSource = _baseViewModel;
}

@end
