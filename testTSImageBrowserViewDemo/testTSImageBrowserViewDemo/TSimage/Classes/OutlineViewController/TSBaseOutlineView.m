//
//  TSBaseOutlineView.m
//  TSTableViewExample
//
//  Created by liu on 2018/3/16.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "TSBaseOutlineView.h"

typedef NSMenu *(^MenuBlock)(NSInteger row);

@interface TSBaseOutlineView ()
@property (nonatomic, copy)  MenuBlock rightMouseMenuBlock;
@end

@implementation TSBaseOutlineView

/* 这里如果不注释掉居然会引起一个显示bug，你敢信？（在关闭展开的行时，会出现黑色背景+闪屏） */
//- (void)drawRect:(NSRect)dirtyRect {
//    [super drawRect:dirtyRect];
//
//    // Drawing code here.
//}

- (void)setRightMouseMenu:(NSMenu *(^)(NSInteger))menuBlock {
    self.rightMouseMenuBlock = menuBlock;
}

- (void)rightMouseDown:(NSEvent *)event {
    [super rightMouseDown:event];
    
    NSPoint location = [event locationInWindow];
    NSPoint point = [self convertPoint:location fromView:nil];
    NSInteger row = [self rowAtPoint:point];
    
    if (self.rightMouseMenuBlock) {
        NSMenu *menu = self.rightMouseMenuBlock(row);
        if (menu == nil) {
            return;
        }
        [NSMenu popUpContextMenu:menu withEvent:event forView:self];
    }
}

@end
