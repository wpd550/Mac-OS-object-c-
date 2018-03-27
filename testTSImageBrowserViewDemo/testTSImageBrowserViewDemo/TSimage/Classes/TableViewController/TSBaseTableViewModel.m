
//  TSBaseTableViewModel.m
//  TSTableViewExample
//
//  Created by liu on 2018/3/15.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "TSBaseTableViewModel.h"
#import <Cocoa/Cocoa.h>
#import "TSTableModelDelegate.h"

@interface TSBaseTableViewModel ()<NSTableViewDataSource>
@property (nonatomic, strong, readwrite) NSMutableArray *contents;

@property (nonatomic, strong) NSArrayController *tableArrayController;
@property (nonatomic, copy) NSString *tableColumnSortKey;

@property (nonatomic, strong) NSPointerArray *groupWeakPointers;

@end

@implementation TSBaseTableViewModel

- (instancetype)init {
    self = [super init];
    
    if (self == nil) {
        return nil;
    }
    
    [self setupDefaults];
    
    return self;
}

- (void)dealloc {
    [self.tableArrayController removeObserver:self forKeyPath:@"selectionIndexes" context:nil];
}

#pragma mark -

- (void)setupDefaults {
    [self.tableArrayController bind:NSContentArrayBinding toObject:self withKeyPath:NSStringFromSelector(@selector(contents)) options:nil]; // 绑定数据源
    
    self.tableArrayController.avoidsEmptySelection = NO;
    
    [self.tableArrayController addObserver:self forKeyPath:@"selectionIndexes" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
}

- (void)bindTableView:(id)tableView {
    [tableView bind:NSContentBinding toObject:self.tableArrayController withKeyPath:@"arrangedObjects" options:nil]; // 绑定刷新数据
    [tableView bind:NSSelectionIndexesBinding toObject:self.tableArrayController withKeyPath:@"selectionIndexes" options:nil]; // 绑定选中
}

- (void)bindTableViewCheckBox:(id)checkBox {
    // 绑定头CheckBox的值
    [checkBox bind:NSValueBinding toObject:self withKeyPath:@"checkBoxValue" options:nil];
}

- (void)unbindTableView:(id)tableView {
    [tableView unbind:NSContentBinding];
    [tableView unbind:NSSelectionIndexesBinding];
}

- (void)updateDataSources {
    [self.tableArrayController rearrangeObjects];
}

- (NSIndexSet *)groupModelIndexes {
    NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
    for (id object in self.groupWeakPointers.allObjects) {
        NSInteger index = [self.contents indexOfObject:object];
        NSAssert(index != NSNotFound, @"没有找到组index");
        [indexes addIndex:index];
    }
    
    return indexes;
}

#pragma mark -

- (void)addData:(id)data {
    [self arrayControllerAddOjbect:data];
    [self updateDataSources];
}

- (void)addDatas:(NSArray *)array {
    for (id object in array) {
        [self arrayControllerAddOjbect:object];
    }
    
    [self updateDataSources];
}

- (void)arrayControllerAddOjbect:(id)object {
    if ([object conformsToProtocol:@protocol(TSTableModelDelegate)]) {
        if ([object isGroupCell]) {
            [self.groupWeakPointers addPointer:(__bridge void * _Nullable)(object)];
        }
    }
    [self.tableArrayController addObject:object];
}

- (void)removeData {
    NSIndexSet *selectIndexes = self.tableArrayController.selectionIndexes;
    if (selectIndexes.count > 0) {
        [self.tableArrayController removeObjectsAtArrangedObjectIndexes:selectIndexes];
        [self updateDataSources];
    }
}

- (void)resetDataContents {
    [self.contents removeAllObjects];
    [self.tableArrayController rearrangeObjects];
    
    // 暂时只想到这样处理
    if (self.groupWeakPointers.allObjects.count > 0) {
        self.groupWeakPointers = [NSPointerArray weakObjectsPointerArray];
    } else {
        [self.groupWeakPointers compact];
    }
}

#pragma mark - TableViewDataSource

- (void)tableView:(NSTableView *)tableView sortDescriptorsDidChange:(NSArray<NSSortDescriptor *> *)oldDescriptors {
    BOOL ascending = YES;
    if (oldDescriptors.count == 0) {
        if (self.tableColumnSortKey) {
            ascending = YES;
        }
    } else {
        NSSortDescriptor *oldPtor = [oldDescriptors objectAtIndex:0];
        if ([self.tableColumnSortKey isEqualToString:oldPtor.key]) {
            ascending = !oldPtor.ascending;
        } else {
            ascending = YES;
        }
    }

    NSArray *sortors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:self.tableColumnSortKey ascending:ascending]];
    [self.contents sortUsingDescriptors:sortors];
    [self updateDataSources];
}

#pragma mark - 观察者

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqual:@"selectionIndexes"]) {
        NSInteger selectCount = self.tableArrayController.selectedObjects.count;
//        if (needRemoveGroupCount) {
//        NSInteger realCount = self.contents.count - self.groupIndexSets.count;
//        }
        
        
        if (selectCount == 0) {
            self.checkBoxValue = [NSNumber numberWithInteger:NSOffState];
        } else if (selectCount == self.contents.count){
            self.checkBoxValue = [NSNumber numberWithInteger:NSOnState];
        } else {
            self.checkBoxValue = [NSNumber numberWithInteger:NSMixedState];
        }
    }
}

#pragma mark - Setter & Getter

- (NSMutableArray *)contents {
    if (_contents == nil) {
        _contents = [[NSMutableArray alloc] init];
    }

    return _contents;
}

- (NSArrayController *)tableArrayController {
    if (_tableArrayController == nil) {
        _tableArrayController = [[NSArrayController alloc] init];
    }
    
    return _tableArrayController;
}

- (NSArray *)selectedObjects {
    return self.tableArrayController.selectedObjects;
}

- (NSIndexSet *)selectionIndexes {
    return self.tableArrayController.selectionIndexes;
}

- (NSIndexSet *)realSelectionIndexesFromProposed:(NSIndexSet *)proposedIndexSet {
    
    //（以后可能有需要包含组的情况）
//    BOOL needRemoveGourpIndex = YES;
//    if (needRemoveGourpIndex) {
//        NSMutableIndexSet *mutSet = proposedIndexSet.mutableCopy;
//        [mutSet removeIndexes:self.groupIndexSets];
//        return mutSet;
//    } else {
//        return proposedIndexSet;
//    }
    
    return proposedIndexSet;
}

- (BOOL)setSelectionIndexes:(NSIndexSet *)indexes {
    if (indexes == nil) {
        indexes = [NSIndexSet indexSet]; // deselect all
    }
    
    return [self.tableArrayController setSelectionIndexes:indexes];
}

- (void)setSelectsInsertedObjects:(BOOL)select {
    if (!select) { // 取消全部选中
        [self.tableArrayController setSelectionIndexes:[NSIndexSet indexSet]];
    }
    
    self.tableArrayController.selectsInsertedObjects = select;
}

- (void)setCurrentColumnSortKey:(NSString *)sortKey {
    if (sortKey == nil) {
        return;
    }
    
    self.tableColumnSortKey = sortKey;
}

- (NSPointerArray *)groupWeakPointers {
    if (_groupWeakPointers == nil) {
        _groupWeakPointers = [NSPointerArray weakObjectsPointerArray];
    }
    
    return _groupWeakPointers;
}

@end
