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
+ (int)saveToCSV:(id)data ToDirectory:(NSString *)directory Progress:(int(^)(int index, int count))progress;
+ (int)saveToExcel:(id)data ToDirectory:(NSString *)directory Progress:(int(^)(int index, int count))progress;
+ (int)saveToXML:(id)data ToDirectory:(NSString *)directory Progress:(int(^)(int index, int count))progress;

@end
