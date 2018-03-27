//
//  TSImageBrowserView.m
//
//  Created by liu on 2018/3/8.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "TSImageBrowserView.h"
#import "TSImageBrowserCell.h"

@interface TSImageBrowserView ()

@property NSRect lastVisibleRect;

@end

#pragma mark -

@implementation TSImageBrowserView

// 返回cell类型
- (IKImageBrowserCell *)newCellForRepresentedItem:(id)cell
{
    // TODO: - 应该没有用到重用，后面再优化（此方法只会在需要新加cell时候调用一次）
    
    // 10.8 会出现invalid pixel format和invalid context错误
    if (floor(NSAppKitVersionNumber) > NSAppKitVersionNumber10_8) {
        return [[TSImageBrowserCell alloc] init];
    }

    return [super newCellForRepresentedItem:cell];
}

- (void)drawRect:(NSRect)rect
{
    // 可视rect
    NSRect visibleRect = self.visibleRect;
    
    if (!NSEqualRects(visibleRect, self.lastVisibleRect)) {
        // we did scroll or resize, redraw the background
        [[self backgroundLayer] setNeedsDisplay];
        
        // update last visible rect
        _lastVisibleRect = visibleRect;
    }
    
    [super drawRect:rect];
}

// cell拖动的处理，暂时全部返回None
- (NSDragOperation)draggingSession:(NSDraggingSession *)session sourceOperationMaskForDraggingContext:(NSDraggingContext)context {
    switch (context) {
            // 拖到APP以外
        case NSDraggingContextOutsideApplication:
            return NSDragOperationNone;
        default:
            return NSDragOperationNone;
            break;
    }
}

@end
