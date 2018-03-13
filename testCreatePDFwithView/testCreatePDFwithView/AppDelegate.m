//
//  AppDelegate.m
//  testCreatePDFwithView
//
//  Created by wudong on 2018/3/13.
//  Copyright © 2018年 wudong. All rights reserved.
//

#import "AppDelegate.h"
#import "testView.h"
#import "CreatePDFWithTable.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    //testView *_subView = [[testView alloc] initWithNibName:@"testView" bundle:nil];
    CreatePDFWithTable *_subView = [[CreatePDFWithTable alloc] initWithNibName:@"CreatePDFWithTable" bundle:nil];
    
    NSLayoutConstraint * left = [NSLayoutConstraint constraintWithItem:_subView.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.window.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint * right = [NSLayoutConstraint constraintWithItem:_subView.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.window.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint * bottom = [NSLayoutConstraint constraintWithItem:_subView.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.window.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint * top = [NSLayoutConstraint constraintWithItem:_subView.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.window.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    
    [self.window.contentView addSubview:_subView.view];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
