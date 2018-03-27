//
//  TSBaseOutlineViewModel.m
//  TSTableViewExample
//
//  Created by liu on 2018/3/16.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "TSBaseOutlineViewModel.h"
#import <Cocoa/Cocoa.h>

@interface TSBaseOutlineViewModel ()
@property (nonatomic, strong) NSTreeController *outlineTreeController;
@end

@implementation TSBaseOutlineViewModel

#pragma mark -

- (instancetype)init {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    [self setupDefaults];
    
    return self;
}

#pragma mark -

- (void)setupDefaults {
    _contents = [[NSMutableArray alloc] init];
    
    self.outlineTreeController.avoidsEmptySelection = YES;
    [self.outlineTreeController bind:NSContentArrayBinding toObject:self withKeyPath:NSStringFromSelector(@selector(contents)) options:nil];
    
    // treeController通过设置KeyPath的isLeaf来确定叶节点
    self.outlineTreeController.leafKeyPath = NSStringFromSelector(@selector(isLeaf));
    // children 会自动遍历这个数组来确认其他节点
    self.outlineTreeController.childrenKeyPath = NSStringFromSelector(@selector(children));
}

#pragma mark -

- (void)bindOutlineView:(id)outlineView {
    [outlineView bind:NSContentBinding toObject:self.outlineTreeController withKeyPath:NSStringFromSelector(@selector(arrangedObjects)) options:nil];
    [outlineView bind:NSSelectionIndexPathsBinding toObject:self.outlineTreeController withKeyPath:NSStringFromSelector(@selector(selectionIndexPaths)) options:nil];
}

- (void)unbindOutlineView:(id)outlineView {
    [outlineView unbind:NSContentBinding];
    [outlineView unbind:NSSelectionIndexPathsBinding];
}

- (BOOL)setSelectionIndexes:(NSIndexPath *)selectionIndexes {
    return [self.outlineTreeController setSelectionIndexPath:selectionIndexes];
}

- (NSArray *)selectedObjects {
    return self.outlineTreeController.selectedObjects;
}

- (NSArray<NSIndexPath *> *)selectionIndexPaths {
    return self.outlineTreeController.selectionIndexPaths;
}

#pragma mark -

- (void)addEntries:(id)entries flag:(BOOL)flag {
    // 为数组时统一处理
    if ([entries isKindOfClass:[NSArray class]]) {
        for (TSOutlineBaseNode *entry in entries) {
            if (![entry isKindOfClass:[TSOutlineBaseNode class]]) {
                continue;
            }
            
            [self.outlineTreeController addObject:entry];
        }
        
        // 取消掉所有选中
        NSArray *selectionIndexPaths = self.outlineTreeController.selectionIndexPaths;
        [self.outlineTreeController removeSelectionIndexPaths:selectionIndexPaths];
    }
    
    // TODO: 以后再处理其他类型
}

- (void)addNode:(__kindof TSOutlineBaseNode *)node {
    NSIndexPath *indexPath = nil;
    if (self.outlineTreeController.selectedObjects.count == 0) {
        indexPath = [NSIndexPath indexPathWithIndex:self.contents.count];
    } else {
        // 取第一个
        TSOutlineBaseNode *selectObject = self.outlineTreeController.selectedObjects.firstObject;
        NSTreeNode *parentNode = nil;
        if (selectObject.isLeaf) { // 取叶节点父类
            parentNode = self.outlineTreeController.selectedNodes.firstObject.parentNode;
        } else { // 选中的为容器节点
            parentNode = self.outlineTreeController.selectedNodes.firstObject;
        }
        
        if (parentNode != nil) {
            indexPath = parentNode.indexPath;
            indexPath = [indexPath indexPathByAddingIndex:parentNode.childNodes.count];
        } else {
            indexPath = [NSIndexPath indexPathWithIndex:self.contents.count];
        }
    }
    
    [self.outlineTreeController insertObject:node atArrangedObjectIndexPath:indexPath];
}

- (void)removeNode {
    [self.outlineTreeController remove:self];
}

- (void)resetDataContents {
    [self.contents removeAllObjects];
    [self.outlineTreeController rearrangeObjects];
}

#pragma mark - Getter & Setter

- (NSTreeController *)outlineTreeController {
    if (_outlineTreeController == nil) {
        _outlineTreeController = [[NSTreeController alloc] init];
    }
    
    return _outlineTreeController;
}

- (void)setSelectsInsertedObjects:(BOOL)isSelect {
    self.outlineTreeController.selectsInsertedObjects = isSelect;
}

@end
