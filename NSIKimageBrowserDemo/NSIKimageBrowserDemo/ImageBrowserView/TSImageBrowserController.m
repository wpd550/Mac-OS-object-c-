//
//  TSImageBrowserController.m
//
//  Created by liu on 2018/3/8.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "TSImageBrowserController.h"
#import "TSImageBrowserView.h"
#import <Quartz/Quartz.h>

//---------------------------------------------------------------------------------
// imageBrowser要求的数据模型
//---------------------------------------------------------------------------------
@interface IBImageModel : NSObject
@property (strong) NSURL *url;
@end

@implementation IBImageModel

#pragma mark - Item data source protocol

- (NSString *)imageRepresentationType
{
    return IKImageBrowserNSURLRepresentationType;
}

- (id)imageRepresentation
{
    return self.url;
}

- (NSString *)imageUID
{
    return self.url.path;
}

/*
// 主标题
- (NSString *)imageTitle {
    return self.url.lastPathComponent.stringByDeletingPathExtension;
}

// 副标题
- (NSString *)imageSubtitle {
    return self.url.pathExtension;
}

// 版本，可用来更新图片
- (NSUInteger)imageVersion {
    
}
*/
@end

//---------------------------------------------------------------------------------
// TSImageBrowserController
//
// 注意！！！！！ 使用imageBrowser需要把XIB里imageBrowser所在Window的下面View的View Effects Inspector的Core Animation Layer里的钩去掉！！！
//---------------------------------------------------------------------------------
@interface TSImageBrowserController ()

@property (strong) NSMutableDictionary <NSString *, NSValue *> *modelRanges;
@property (strong) NSMutableArray *sortGroupKeys;
@property (strong) NSMutableArray *importedImageModels;

@end

@implementation TSImageBrowserController

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark -

- (void)setupUI {
    self.imageBrowser.delegate = self;
    self.imageBrowser.dataSource = self;
    
    // 排序、拖动cell、cell出现动画
    [self.imageBrowser setAnimates:YES];
//    [self.imageBrowser setAllowsReordering:YES];
//    [self.imageBrowser setDraggingDestinationDelegate:self];
    
    // 选中色
    [self.imageBrowser setValue:[NSColor colorWithCalibratedRed:0.51 green:0.82 blue:0.99 alpha:1.00] forKey:IKImageBrowserSelectionColorKey];
    // cell放大系数
    [self.imageBrowser setZoomValue:0.6];
    // mac空格预览文件
//    [self.imageBrowser setCanControlQuickLookPanel:YES];
    // 间距
//    [self.imageBrowser setIntercellSpacing:NSMakeSize(10, 10)];
    
    // cell显示样式
//    [self.imageBrowser setCellsStyleMask:IKCellsStyleTitled | IKCellsStyleOutlined];
    
    /* 后面可能会用到的设置
    
    // 字体设置
    
    // 段落样式
    NSMutableParagraphStyle *paraphStyle = [[NSMutableParagraphStyle alloc] init];
    paraphStyle.lineBreakMode = NSLineBreakByTruncatingMiddle;
    paraphStyle.alignment = NSTextAlignmentCenter;

    // 标题字体
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    attributes[NSFontAttributeName] = [NSFont systemFontOfSize:12];
    attributes[NSParagraphStyleAttributeName] = paraphStyle;
    attributes[NSForegroundColorAttributeName] = [NSColor blackColor];
    [self.imageBrowser setValue:attributes forKey:IKImageBrowserCellsTitleAttributesKey];

    // 选中时字体
    attributes = [[NSMutableDictionary alloc] init];
    attributes[NSFontAttributeName] = [NSFont boldSystemFontOfSize:12];
    attributes[NSParagraphStyleAttributeName] = paraphStyle;
    attributes[NSForegroundColorAttributeName] = [NSColor whiteColor];
    [self.imageBrowser setValue:attributes forKey:IKImageBrowserCellsHighlightedTitleAttributesKey];
     */
}

- (void)setupDefaults {
    _modelRanges         = [[NSMutableDictionary alloc] init];
    _sortGroupKeys       = [[NSMutableArray alloc] init];
    _imageModels         = [[NSMutableArray alloc] init];
    _importedImageModels = [[NSMutableArray alloc] init];
}

- (void)updateDatasource {
    // update our datasource, add recently imported items
    [self.imageModels addObjectsFromArray:self.importedImageModels];
    
    // empty our temporary array
    [self.importedImageModels removeAllObjects];
    
    // reload the image browser and set needs display
    [self.imageBrowser reloadData];
}

- (void)resetAllDatas {
    [self.imageModels removeAllObjects];
    [self.modelRanges removeAllObjects];
    [self.importedImageModels removeAllObjects];
    [self.sortGroupKeys removeAllObjects];
}

- (IBImageModel *)getImageModelWithUrl:(NSURL *)imageUrl {
    IBImageModel *model = [[IBImageModel alloc] init];
    model.url = imageUrl;
    return model;
}

- (NSArray *)getImageModelWithUrls:(NSArray <NSURL *>*)imageUrls {
    NSMutableArray *models = [[NSMutableArray alloc] init];
    for (NSURL *url in imageUrls) {
        [models addObject:[self getImageModelWithUrl:url]];
    }
    return models;
}

#pragma mark - IKImageBrowserDataSource && IKImageBrowserDelegate

- (NSUInteger)numberOfItemsInImageBrowser:(IKImageBrowserView *)view {
    return self.imageModels.count;
}

- (id)imageBrowser:(IKImageBrowserView *)view itemAtIndex:(NSUInteger)index {
    return self.imageModels[index];
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
    NSRange range = self.modelRanges[title].rangeValue;

    NSMutableDictionary *groupTypeKeys = [NSMutableDictionary dictionary];
    groupTypeKeys[IKImageBrowserGroupTitleKey] = title;
    groupTypeKeys[IKImageBrowserGroupRangeKey] = [NSValue valueWithRange:range];
    groupTypeKeys[IKImageBrowserGroupStyleKey] = [NSNumber numberWithInt:IKGroupDisclosureStyle];
    groupTypeKeys[IKImageBrowserGroupFooterLayer] = [CALayer layer]; // 去掉分割线
    return groupTypeKeys;
}

#pragma mark -

- (void)setImageBrowserDatas:(NSDictionary *)datas withSortGroupTitles:(NSArray *)sortTitles {
    [self resetAllDatas];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.sortGroupKeys addObjectsFromArray:sortTitles];
        
        NSMutableDictionary *rangeDic = [NSMutableDictionary dictionary];
        [self.sortGroupKeys enumerateObjectsUsingBlock:^(NSString *sortKey, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *mediaUrls = datas[sortKey];
            NSArray *models = [self getImageModelWithUrls:mediaUrls];
            // 先计算range
            NSRange range = NSMakeRange(self.importedImageModels.count, models.count);
            // 再保存数据
            [self.importedImageModels addObjectsFromArray:models];
            rangeDic[sortKey] = [NSValue valueWithRange:range];
        }];
        [self.modelRanges addEntriesFromDictionary:rangeDic];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateDatasource];
        });
    });
}


@end
