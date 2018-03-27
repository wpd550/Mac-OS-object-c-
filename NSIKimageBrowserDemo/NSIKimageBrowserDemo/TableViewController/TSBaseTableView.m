//
//  TSBaseTableView.m
//
//  Created by liu on 2018/2/27.
//  Copyright © 2018年 Tenorshare Developer. All rights reserved.
//

#import "TSBaseTableView.h"

typedef NSMenu *(^MenuBlock)(NSInteger row);
typedef void(^CheckBoxBlock)(NSButton *checkBox);

@interface TSBaseTableView ()
@property (nonatomic, copy) MenuBlock rightMouseMenuBlock;
@property (assign) NSInteger checkBoxColumeIndex;
@end

@implementation TSBaseTableView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSRect rect = [self.headerView headerRectOfColumn:self.checkBoxColumeIndex];
    self.headCheckBox.frame = NSMakeRect(floorf(NSMidX(rect) - 9 - 1), floorf(NSMidY(rect) - 9), 18, 18);
}

static NSString *TSCheckBoxCellColumnID = @"CheckBoxCell";
- (void)addCheckBoxForTableColumn:(NSInteger)column {
    if (column > self.tableColumns.count) {
        column = self.tableColumns.count;
    }
    
    self.checkBoxColumeIndex = column;
    
    NSTableColumn *tableColume = [self tableColumnWithIdentifier:TSCheckBoxCellColumnID];
    if (tableColume == nil) {
        tableColume = [[NSTableColumn alloc] initWithIdentifier:TSCheckBoxCellColumnID];
        tableColume.minWidth = 30;
        tableColume.maxWidth = 30;
//        tableColume.title = @""; // SDK10.10+
        tableColume.headerCell.title = @"";
        
        [self addTableColumn:tableColume];
        
        self.headCheckBox = [[TUICheckBox alloc] init];
        
        [self.headerView addSubview:self.headCheckBox];
    }
    
    [self moveColumn:[self.tableColumns indexOfObject:tableColume] toColumn:column];
}

- (NSString *)getCheckBoxColumnIdentifier {
    return TSCheckBoxCellColumnID;
}

- (NSInteger)getCheckBoxColumnIndex {
    return _checkBoxColumeIndex;
}

- (void)setRightMouseMenu:(NSMenu *(^)(NSInteger))menuBlock {
    self.rightMouseMenuBlock = menuBlock;
}

- (void)setHeadCheckBoxClickBlock:(void (^)(NSButton *checkBox))checkBoxClickBlock {
    self.headCheckBoxClickBlock = checkBoxClickBlock;
}

- (void)rightMouseDown:(NSEvent *)event {
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
