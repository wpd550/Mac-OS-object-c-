//
//  TSOutlineController.m
//
//  Created by liu on 2018/3/5.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "TSOutlineController.h"
#import "TSBaseOutlineViewModel.h"

/*
    @"NSOutlineViewDisclosureButtonKey" 可使用这个identifier自定义disclosure按钮
 */

@interface TSOutlineController ()
@property (weak) TSBaseOutlineViewModel *baseViewModel;
@end

@implementation TSOutlineController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - 私有方法

/// 设置了通用的一些UI属性，子类请调super
- (void)setupUI {
    self.outlineView.delegate = self;
    
    if (_baseViewModel != nil) {
        [self setOutlineViewDataSourceToViewModel:_baseViewModel];
    }
}

- (void)setupDefaults {
    
}

#pragma mark - NSOutlineViewDelegate

- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
    [self selectedRowDidChange];
}

- (NSIndexSet *)outlineView:(NSOutlineView *)outlineView selectionIndexesForProposedSelection:(NSIndexSet *)proposedSelectionIndexes {
    NSIndexSet *realSet = proposedSelectionIndexes;
    
    [self selectedRowWillChange:realSet];
    
    return realSet;
}

#pragma mark - 公共方法

- (void)selectedRowDidChange {
    
}

- (void)selectedRowWillChange:(NSIndexSet *)selectionIndexes {
    
}

#pragma mark - Getter && Setter

- (void)setOutlineViewDataSourceToViewModel:(__kindof TSBaseOutlineViewModel *)baseViewModel {
    if (_baseViewModel != baseViewModel) {
        [_baseViewModel unbindOutlineView:self.outlineView];
    }
    _baseViewModel = baseViewModel;
    
    // 先绑定后设置数据源，xcode就不会提示DataSource required的方法没有实现
    [_baseViewModel bindOutlineView:self.outlineView];
    self.outlineView.dataSource = _baseViewModel;
}

- (void)setRightMouseMenu:(NSMenu *(^)(NSInteger))menuBlock {
    [(TSBaseOutlineView *)self.outlineView setRightMouseMenu:menuBlock];
}

@end
