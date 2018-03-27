//
//  AppDelegate.h
//  testTSImageBrowserViewDemo
//
//  Created by wudong on 2018/3/23.
//  Copyright © 2018年 wudong. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TSBaseTableView.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet TSImageBrowserView *imageBrowser;

@end

