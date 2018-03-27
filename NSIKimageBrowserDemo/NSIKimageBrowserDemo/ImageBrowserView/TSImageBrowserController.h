//
//  TSImageBrowserController.h
//
//  Created by liu on 2018/3/8.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "TSBaseViewController.h"

@import Quartz;
@class TSImageBrowserView;
@interface TSImageBrowserController : TSBaseViewController

@property (weak) IBOutlet __kindof TSImageBrowserView *imageBrowser;
@property (strong) NSMutableArray *imageModels;

- (void)setImageBrowserDatas:(NSDictionary *)datas withSortGroupTitles:(NSArray *)sortTitles;

@end
