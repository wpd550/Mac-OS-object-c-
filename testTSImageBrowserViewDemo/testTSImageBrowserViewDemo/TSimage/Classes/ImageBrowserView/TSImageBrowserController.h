//
//  TSImageBrowserController.h
//
//  Created by liu on 2018/3/8.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "TSBaseViewController.h"
#import "TSImageBrowserView.h"

@import Quartz;

@class TSBaseImageBrowserViewModel;
@interface TSImageBrowserController : TSBaseViewController

@property (weak) IBOutlet TSImageBrowserView *imageBrowser;

/**
 设置DataSource
 
 每次有新ViewModel需要重新设置
 */
- (void)setImageBrowserDataSourceToViewModel:(__kindof TSBaseImageBrowserViewModel *)baseViewModel;

@end
