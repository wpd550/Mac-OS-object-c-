//
//  AppDelegate.m
//  icareFoneDatainfo
//
//  Created by wudong on 2018/3/9.
//  Copyright © 2018年 wudong. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    do{
        __strong NSString *str = [[NSString alloc] initWithFormat:@"123"];
    }while(1);
    
    
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
