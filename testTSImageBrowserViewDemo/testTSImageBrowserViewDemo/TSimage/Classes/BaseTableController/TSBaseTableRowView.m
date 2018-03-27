//
//  TSBaseTableRowView.m
//
//  Created by liu on 2018/2/27.
//  Copyright © 2018年 Tenorshare Developer. All rights reserved.
//

#import "TSBaseTableRowView.h"

@implementation TSBaseTableRowView

@synthesize representedObject;

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self setUpDefault];
    }
    
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        [self setUpDefault];
    }
    
    return self;
}

- (void)setUpDefault {
    NSTrackingAreaOptions options = NSTrackingActiveAlways | NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved;
    NSTrackingArea *area = [[NSTrackingArea alloc] initWithRect:[self bounds] options:options owner:self userInfo:nil];
    [self addTrackingArea:area];
}

- (void)drawSelectionInRect:(NSRect)dirtyRect {
    if (self.selectionHighlightStyle != NSTableViewSelectionHighlightStyleNone) {
        NSRect selectRect = self.bounds;
        
        if (self.selectedColor) {
            [self.selectedColor setFill];
        }
        
        NSBezierPath *selectPath = [NSBezierPath bezierPathWithRoundedRect:selectRect xRadius:0 yRadius:0];
        [selectPath fill];
    }
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    if (!_mouseFocus) {
        return;
    }
    
    if (self.isSelected)
        return;
    
    if ([self selectionHighlightStyle] != NSTableViewSelectionHighlightStyleNone){
        NSRect selectRect = self.bounds;
        
        if (self.highlightColor) {
            [self.highlightColor setFill];
        }
        NSBezierPath *selectPath = [NSBezierPath bezierPathWithRoundedRect:selectRect xRadius:0 yRadius:0];
        [selectPath fill];
    } else {
        [super drawRect:dirtyRect];
    }
}

- (NSBackgroundStyle)interiorBackgroundStyle {
    return NSBackgroundStyleLight;
}

- (void)mouseEntered:(NSEvent *)theEvent {
    if ([self mouseInview]) {
        _mouseFocus = YES;
        [self display];
    }
}

-(void)mouseMoved:(NSEvent *)theEvent{
    //[super mouseMoved:theEvent];
    if (!_mouseFocus && [self mouseInview]) {
        _mouseFocus = YES;
        [self display];
    }
}

- (void)mouseExited:(NSEvent *)theEvent {
    if (_mouseFocus) {
        _mouseFocus = NO;
        [self display];
    }
}

- (BOOL)mouseInview {
    if (!self.window)
        return NO;
    if (self.isHidden)
        return NO;
    NSPoint point = [NSEvent mouseLocation];
    point = [self.window convertRectFromScreen:NSMakeRect(point.x, point.y,0,0)].origin;
    point = [self convertPoint:point fromView:nil];
    return NSPointInRect(point, self.visibleRect);
}

// 防止重用时出问题
- (void)viewDidMoveToSuperview {
    [super viewDidMoveToSuperview];
    
    _mouseFocus = NO;
}

- (void)updateTrackingAreas {
    [super updateTrackingAreas];
}

@end
