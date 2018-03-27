//
//  TSImageBrowserController.m
//
//  Created by liu on 2018/3/8.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "TSImageBrowserController.h"
#import "TSImageBrowserView.h"
#import "TSBaseImageBrowserViewModel.h"
#import <Quartz/Quartz.h>

//---------------------------------------------------------------------------------
// TSImageBrowserController
//
// 注意！！！！！ 使用imageBrowser需要把XIB里imageBrowser所在Window的下面View的View Effects Inspector的Core Animation Layer里的钩去掉！！！不然在10.8一丁点儿东西也不会显示。
//---------------------------------------------------------------------------------
@interface TSImageBrowserController ()
@property (weak) TSBaseImageBrowserViewModel *baseViewModel;
@end

@implementation TSImageBrowserController

#pragma mark -

- (void)setupUI {
    self.imageBrowser.delegate = self;
    
    if (_baseViewModel != nil) {
        self.imageBrowser.dataSource = self.baseViewModel;
        [self setViewModelReloadDataCallBackBlock];
//        [self.imageBrowser bind:NSContentBinding toObject:self.baseViewModel withKeyPath:@"arrangedObjects" options:nil];
        [self.imageBrowser bind:NSSelectionIndexesBinding toObject:self.baseViewModel withKeyPath:@"selectionIndexes" options:nil];
    }
}

- (void)setupDefaults {
    
}

- (void)setViewModelReloadDataCallBackBlock {
    typeof(self) __weak weakSelf = self;
    [weakSelf.baseViewModel setReloadDataCallBack:^{
        [weakSelf.imageBrowser reloadData];
    }];
}

#pragma mark - IKImageBrowserDelegate

//- (void)imageBrowser:(IKImageBrowserView *)aBrowser cellWasRightClickedAtIndex:(NSUInteger)index withEvent:(NSEvent *)event {
//
//}

//- (void)imageBrowser:(IKImageBrowserView *)aBrowser backgroundWasRightClickedWithEvent:(NSEvent *)event {
//    
//}

//- (void)imageBrowser:(IKImageBrowserView *)aBrowser cellWasDoubleClickedAtIndex:(NSUInteger)index {
//
//}
//
//- (void)imageBrowserSelectionDidChange:(IKImageBrowserView *)aBrowser {
//    //    NSLog(@"%@", self.imageBrowser.selectionIndexes);
//}

#pragma mark - Getter & Setter

- (void)setImageBrowserDataSourceToViewModel:(__kindof TSBaseImageBrowserViewModel *)baseViewModel {
    _baseViewModel = baseViewModel;
    
    [self setViewModelReloadDataCallBackBlock];
}

@end
