//
//  TSCheckBoxTableCellView.m
//
//  Created by liu on 2018/2/27.
//  Copyright © 2018年 Tenorshare Developer. All rights reserved.
//

#import "TSCheckBoxTableCellView.h"

@implementation TSCheckBoxTableCellView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

- (TUICheckBox *)checkBox {
    if (_checkBox == nil) {
        TUICheckBox *checkBox = [[TUICheckBox alloc] init];
        [checkBox setButtonType:NSButtonTypeSwitch];
        checkBox.allowsMixedState = NO;
        [self addSubview:checkBox];
        _checkBox = checkBox;
    }
    
    return _checkBox;
}

- (void)viewDidMoveToSuperview {
    [super viewDidMoveToSuperview];
    
    NSView *view = self.superview;
    if (view == nil) {
        return;
    }

    CGFloat length = 20;
    self.checkBox.frame = NSMakeRect((self.frame.size.width - length) / 2, (self.frame.size.height - length) / 2, length, length);
}

@end
