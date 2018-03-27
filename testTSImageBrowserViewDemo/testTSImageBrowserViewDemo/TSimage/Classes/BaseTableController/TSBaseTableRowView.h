//
//  TSBaseTableRowView.h
//
//  Created by liu on 2018/2/27.
//  Copyright © 2018年 Tenorshare Developer. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TSBaseTableRowView : NSTableRowView {
    BOOL _mouseFocus;
}

@property (nonatomic, strong) NSColor *highlightColor;
@property (nonatomic, strong) NSColor *selectedColor;

@property (nonatomic, strong) id representedObject;

@end
