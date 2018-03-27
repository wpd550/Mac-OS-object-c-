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
@property (strong) Class customCellClass;
@end

#pragma mark -

@implementation TSImageBrowserView

// 返回cell类型
- (IKImageBrowserCell *)newCellForRepresentedItem:(id)cell {
    // 10.8 会出现invalid pixel format和invalid context错误
    if (floor(NSAppKitVersionNumber) <= NSAppKitVersionNumber10_8) {
        return [super newCellForRepresentedItem:cell];
    }
    
    if (self.customCellClass != nil && [self.customCellClass isSubclassOfClass:[IKImageBrowserCell class]]) {
        return [[self.customCellClass alloc] init];
    }
    
    return [super newCellForRepresentedItem:cell];
}

- (void)drawRect:(NSRect)rect {
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

- (void)setImageBrowserCellClass:(Class)cellClass {
    self.customCellClass = cellClass;
}

@end
