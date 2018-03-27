//
//  TSBaseOutlineView.h
//  TSTableViewExample
//
//  Created by liu on 2018/3/16.
//  Copyright © 2018年 liu. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TSBaseOutlineView : NSOutlineView

/**
 右键菜单
 
 @param menuBlock 参数为右键选到的row，没有选中时为-1或一个比较大的值, 返回需要显示的Menu
 */
- (void)setRightMouseMenu:(NSMenu * (^)(NSInteger row))menuBlock;

@end
