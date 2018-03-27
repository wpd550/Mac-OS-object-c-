//
//  TSBaseTableView.h
//
//  Created by liu on 2018/2/27.
//  Copyright © 2018年 Tenorshare Developer. All rights reserved.
//

#import <TSUIKit/TSUIKit.h>
#import <Cocoa/Cocoa.h>

@interface TSBaseTableView : NSTableView

@property (nonatomic, strong) TUICheckBox *headCheckBox;

/**
 添加CheckBox列
 
 ！！！需要添加的话请调用VC的添加方法，VC会绑定headCheckBox的一个值，来获取一些情况下的显示值。
 */
- (void)addCheckBoxForTableColumn:(NSInteger)column;
/// CheckBox column统一的identifier
- (NSString *)getCheckBoxColumnIdentifier;

- (NSInteger)getCheckBoxColumnIndex;

- (void)setRightMouseMenu:(NSMenu * (^)(NSInteger row))menuBlock;

@end
