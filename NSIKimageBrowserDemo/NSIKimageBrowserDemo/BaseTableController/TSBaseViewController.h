//
//  TSBaseViewController.h
//
//  Created by liu on 2018/3/7.
//  Copyright © 2018年 liu. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TSBaseViewController : NSViewController


/**
 通过自身class同名，同bundle的nib，创建的控制器
 */
- (instancetype)initFromController;


/**
 通过自身class同名，指定bundle的nib，创建的控制器

 @param nibBundle nib所在的bundle
 */
- (instancetype)initFromControllerNibWithBundle:(NSBundle *)nibBundle;

/**
 初始化基础数据等(供重写，必要时请调super)
 
 此方法会在每次初始化类时候调用，一般用来初始化一些数组等对象（初始化UI一些方法请在setupUI里调用，因为此时Xib里的UI还未加载好）
 */
- (void)setupDefaults;


/**
 初始化UI控件(供重写，必要时请调super)
 
 此方法会在每次ViewDidLoad后调用，此时UI已经加载好，可以愉快的请求数据然后显示了！
 */
- (void)setupUI;


/**
 将long long 数据转换成时分秒
 
 @param time 待转换时长
 @return 时分秒字符
 */
-(NSString *)longlongToTimeString:(long long)time;


/**
 显示加载数据窗口
 
 @param isShow 打开还是关闭
 @param message 加载信息
 */
- (void)showLoadingWindow:(BOOL)isShow withLoadingMessage:(NSString *)message;


/**
 导入文件
 
 @param isChooseDirectories 选择文件或文件夹
 @param allowedTypes 导入的文件格式
 @param prompt 选中按钮的显示文本
 @return 文件的URLs，没有或取消则为nil
 */
- (NSArray<NSURL *> *)importFile:(BOOL)isChooseDirectories allowedFileTypes:(NSArray<NSString *> *)allowedTypes prompt:(NSString *)prompt;


/**
 导出文件
 
 @param prompt 选中按钮的显示文本
 @return 文件夹URL，没有或取消则为nil
 */
- (NSURL *)exportFileToLocalWithPrompt:(NSString *)prompt;


/**
 右键菜单
 
 @param menuBlock 参数为右键选到的row，没有选中时为-1或一个比较大的值, 返回需要显示的Menu
 */
- (void)setRightMouseMenu:(NSMenu *(^)(NSInteger))menuBlock;

@end
