//
//  TSCheckBoxTableCellView.h
//
//  Created by liu on 2018/2/27.
//  Copyright © 2018年 Tenorshare Developer. All rights reserved.
//

#import <TSUIKit/TUICheckBox.h>
#import <TSUIKit/TUICheckBoxCell.h>
#import <Cocoa/Cocoa.h>

@interface TSCheckBoxTableCellView : NSTableCellView

@property (nonatomic, weak) TUICheckBox *checkBox;

@end
