//
//  AppDelegate.m
//  myNSScrollViewDemo
//
//  Created by wudong on 2018/3/21.
//  Copyright © 2018年 wudong. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    self.box.frame = NSMakeRect(0, 0, 1000, 1000);
    self.srcollView.documentView = self.box;
    self.srcollView.hasVerticalScroller = NO;
    self.srcollView.hasHorizontalScroller = NO;

}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
