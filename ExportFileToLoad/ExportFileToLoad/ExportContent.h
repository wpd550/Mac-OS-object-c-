//
//  ExportContent.h
//  ExportFileToLoad
//
//  Created by wudong on 2018/3/12.
//  Copyright © 2018年 wudong. All rights reserved.
//

#import <Foundation/Foundation.h>

// return 非0，退出
typedef int(^fileCountPregressBlock)(int index, int count);

@interface ExportContent : NSObject{
    fileCountPregressBlock _fileCountBlock;
}

@property(copy) fileCountPregressBlock fileCountBlock;

+ (NSDictionary *)dicFromObjectPro:(NSObject *)object;
/**
 将model导出为csv格式文件，支持单个和数组，但是不支持嵌套
 @param data model 数据
 @param directory  路径
 @param progress   进度回掉，当返回非零时停止写入
 */
+ (int)saveToCSV:(id)data ToDirectory:(NSString *)directory Progress:(int(^)(int index, int count))progress;
/**
 将model导出为xls格式文件，支持单个和数组，但是不支持嵌套
 @param data model 数据
 @param directory  路径
 @param progress   进度回掉，当返回非零时停止写入
 */
+ (int)saveToExcel:(id)data ToDirectory:(NSString *)directory Progress:(int(^)(int index, int count))progress;
/**
 将model导出为xml格式文件，支持单个和数组，但是不支持嵌套
 @param data model 数据
 @param directory  路径
 @param progress   进度回掉，当返回非零时停止写入
 */
+ (int)saveToXML:(id)data ToDirectory:(NSString *)directory Progress:(int(^)(int index, int count))progress;

/**
 将model导出为xml格式文件，支持单个和数组，但是不支持嵌套
 @param data model 数据
 @param directory  路径
 @param progress   进度回掉，当返回非零时停止写入
 */
+ (int)saveToText:(id)data ToDirectory:(NSString *)directory Progress:(int(^)(int index, int count))progress;

+ (int)saveToCLDATA:(id)data ToDirectory:(NSString *)directory Progress:(int (^)(int, int))progress;


@end
