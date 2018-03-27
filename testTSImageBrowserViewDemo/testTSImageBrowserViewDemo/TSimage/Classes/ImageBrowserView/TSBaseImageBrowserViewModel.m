//
//  TSBaseImageBrowserViewModel.m
//  TSTableViewExample
//
//  Created by liu on 2018/3/21.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "TSBaseImageBrowserViewModel.h"

typedef void(^ReloadCallBackBlock)(void);

@interface TSBaseImageBrowserViewModel ()

@property (strong) NSMutableDictionary<NSString *, NSArray *> *gourps;
@property (strong) NSMutableArray *sortGroupKeys;

@property (copy) ReloadCallBackBlock reloadBlock;

@end

@implementation TSBaseImageBrowserViewModel

- (instancetype)init {
    self = [super init];
    
    if (self == nil) {
        return nil;
    }
    
    [self setupDefaults];
    
    return self;
}

- (void)setupDefaults {
    _contents      = [[NSMutableArray alloc] init];
    _gourps        = [[NSMutableDictionary alloc] init];
    _sortGroupKeys = [[NSMutableArray alloc] init];
}

- (void)updateDataSource {
    if (self.reloadBlock) {
        self.reloadBlock();
    }
}

- (void)resetDataContents {
    [self.contents removeAllObjects];
    [self.gourps removeAllObjects];
    [self.sortGroupKeys removeAllObjects];
}

#pragma mark -
- (void)setImageBrowserDatas:(NSDictionary *)datas withSortGroupTitles:(NSArray *)sortTitles {
    [self resetDataContents];
    
    [self.gourps addEntriesFromDictionary:datas];
    [self.sortGroupKeys addObjectsFromArray:sortTitles];
    
    for (NSString *sortKey in sortTitles) {
        NSArray *models = datas[sortKey];
        [self.contents addObjectsFromArray:models];
    }
    
    [self updateDataSource];
}

- (void)removeData {

}


#pragma mark -
- (void)setReloadDataCallBack:(void (^)(void))reloadBlock {
    self.reloadBlock = reloadBlock;
}

#pragma mark - IKImageBrowserDataSource

- (NSUInteger)numberOfItemsInImageBrowser:(IKImageBrowserView *)view {
    return self.contents.count;
}

- (id)imageBrowser:(IKImageBrowserView *)view itemAtIndex:(NSUInteger)index {
    return self.contents[index];
}

- (NSUInteger)numberOfGroupsInImageBrowser:(IKImageBrowserView *)aBrowser {
    return self.sortGroupKeys.count;
}

- (NSDictionary *)imageBrowser:(IKImageBrowserView *)aBrowser groupAtIndex:(NSUInteger)index {
    if (self.sortGroupKeys.count == 0) {
        return nil;
    }
    
    NSArray *allKeys = self.sortGroupKeys;
    NSString *title = allKeys[index];
    NSArray *models = self.gourps[title];
    NSUInteger location = [self.contents indexOfObject:models.firstObject];
    NSAssert(location != NSNotFound, @"imageBrowser数据出错了");
    NSRange range = NSMakeRange(location, models.count);
    
    NSMutableDictionary *groupTypeKeys = [NSMutableDictionary dictionary];
    groupTypeKeys[IKImageBrowserGroupTitleKey] = title;
    groupTypeKeys[IKImageBrowserGroupRangeKey] = [NSValue valueWithRange:range];
    groupTypeKeys[IKImageBrowserGroupStyleKey] = [NSNumber numberWithInt:IKGroupDisclosureStyle];
    groupTypeKeys[IKImageBrowserGroupFooterLayer] = [CALayer layer]; // 去掉分割线
    return groupTypeKeys;
}

@end
