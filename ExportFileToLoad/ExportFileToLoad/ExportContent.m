//
//  ExportContent.m
//  ExportFileToLoad
//
//  Created by wudong on 2018/3/12.
//  Copyright © 2018年 wudong. All rights reserved.
//

#import "ExportContent.h"
#import <objc/runtime.h>

@implementation ExportContent

@synthesize fileCountBlock = _fileCountBlock;


+ (NSDictionary *)dicFromObjectPro:(NSObject *)object
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([object class], &count);
    if(propertyList == NULL || count == 0 )
    {
        NSLog(@"object parameter error ");
        return nil;
    }
    
    for (int i = 0; i < count; i++)
    {
        objc_property_t property = propertyList[i];
        const char *cName = property_getName(property);
        NSString *name = [NSString stringWithUTF8String:cName];
        NSObject *value = [object valueForKey:name];//valueForKey返回的数字和字符串都是对象
        
        if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]])
        {
            //string , bool, int ,NSinteger
            [dic setObject:value forKey:name];
            
        }
        else if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]])
        {
            //字典或字典
            [dic setObject:[self arrayOrDicWithObject:(NSArray*)value] forKey:name];
            
        }
        else if (value == nil)
        {
            //[dic setObject:[NSNull null] forKey:name];
        }
        else
        {
            //model
            [dic setObject:[self dicFromObjectPro:value] forKey:name];
        }
    }
    
    return dic;
}
//将可能存在model数组转化为普通数组
+ (id)arrayOrDicWithObject:(id)origin
{
    if ([origin isKindOfClass:[NSArray class]])
    {
        //数组
        NSMutableArray *array = [NSMutableArray array];
        for (NSObject *object in origin)
        {
            if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]])
            {
                //string , bool, int ,NSinteger
                [array addObject:object];
                
            }
            else if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]])
            {
                //数组或字典
                [array addObject:[self arrayOrDicWithObject:(NSArray *)object]];
                
            } else
            {
                //model
                [array addObject:[self dicFromObjectPro:object]];
            }
        }
        return array ;
    }
    else if ([origin isKindOfClass:[NSDictionary class]]) {
        //字典
        NSDictionary *originDic = (NSDictionary *)origin;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for (NSString *key in originDic.allKeys) {
            id object = [originDic objectForKey:key];
            
            if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) {
                //string , bool, int ,NSinteger
                [dic setObject:object forKey:key];
                
            } else if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) {
                //数组或字典
                [dic setObject:[self arrayOrDicWithObject:object] forKey:key];
                
            } else {
                //model
                [dic setObject:[self dicFromObjectPro:object] forKey:key];
            }
        }
        return dic;
    }
    return [NSNull null];
}
//创建不存在的文件名
+(NSString*)createNewFileNameWithDirectory:(NSString*)directory Postfix:(NSString*)postfix
{
    NSString *outpath = [NSString stringWithFormat:@"%@.%@",directory,postfix];
    NSFileManager *manager = [NSFileManager defaultManager];
    int fileNum=0;
    do
    {
        fileNum++;
        if([manager fileExistsAtPath:outpath] == NO){
            break;
        }
        outpath = [NSString stringWithFormat:@"%@%i.%@",directory,fileNum,postfix];
        
    }
    while(1);
    return outpath;
}



// 返回 0 success， -1 failure
+ (int)saveToCSV:(id)data ToDirectory:(NSString *)directory Progress:(int(^)(int index, int count))progress
{
    NSString *outpath = [self createNewFileNameWithDirectory:directory Postfix:@"csv"];
  
    NSOutputStream *output = [[NSOutputStream alloc] initToFileAtPath:outpath append:YES];
    [output open];
    NSMutableArray *arrayData = [[NSMutableArray alloc] init];
    if([data isKindOfClass:[NSArray class]])
    {
        NSUInteger fileCount = [data count];
        for (int i = 0; i < fileCount; i++)
        {
            [arrayData addObject:[self dicFromObjectPro:[data objectAtIndex:i]]];
        }
    }
    else
    {
        [arrayData addObject:[self dicFromObjectPro:data]];
    }
    if(arrayData == nil || [arrayData count] == 0)
    {
        NSLog(@"无效的arraydata 数组");
        return -1;
    }
    
    NSMutableString *header = [NSMutableString string];
    NSMutableArray *keys = [NSMutableArray array];
    if ([arrayData count] > 0)
    {
        NSDictionary *dicData = [arrayData firstObject];
        for (int i = 0; i < [dicData.allKeys count]; i++)
        {
            if (i == [dicData.allKeys count] - 1)
            {
                [header appendFormat:@"%@\n", [dicData.allKeys objectAtIndex:i]];
                [keys addObject:[dicData.allKeys objectAtIndex:i]];
            }
            else
            {
                [header appendFormat:@"%@,", [dicData.allKeys objectAtIndex:i]];
                [keys addObject:[dicData.allKeys objectAtIndex:i]];
            }
        }
    }

    const uint8_t *headerString = (const uint8_t *)[header cStringUsingEncoding:NSUTF8StringEncoding];
    NSInteger headerLength = [header lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    [output write:headerString maxLength:headerLength];
    
    int crruentCount = 0;
    NSUInteger totalCount = [arrayData count];
    for (NSDictionary *dicData in arrayData)
    {
        NSMutableString *row = [NSMutableString string];
        
        if(progress){
            if(progress(crruentCount,(int)totalCount) != 0)
            {
                break;
            }
        }
        for (int i = 0; i < [dicData.allValues count]; i++)
        {
            if (i == [dicData.allValues count] - 1)
            {
                [row appendFormat:@"%@\n",[dicData objectForKey:[keys objectAtIndex:i]]];
            }
            else
            {
                [row appendFormat:@"%@,",[dicData objectForKey:[keys objectAtIndex:i]]];
            }
        }
        crruentCount++;
        if(progress){
            if(progress(crruentCount,(int)totalCount) != 0)
            {
                break;
            }
        }
        const uint8_t *rowString = (const uint8_t *)[row cStringUsingEncoding:NSUTF8StringEncoding];
        NSInteger rowLength = [row lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        [output write:rowString maxLength:rowLength];
    }

    [output close];
    return 0;
}


+ (int)saveToExcel:(id)data ToDirectory:(NSString *)directory Progress:(int(^)(int index, int count))progress{

    NSString *outpath = [self createNewFileNameWithDirectory:directory Postfix:@"xls"];
    
    NSOutputStream *output = [[NSOutputStream alloc] initToFileAtPath:outpath append:YES];
    [output open];
    NSMutableArray *arrayData = [[NSMutableArray alloc] init];
    if([data isKindOfClass:[NSArray class]])
    {
        NSUInteger fileCount = [data count];
        for (int i = 0; i < fileCount; i++)
        {
            [arrayData addObject:[self dicFromObjectPro:[data objectAtIndex:i]]];
        }
    }
    else
    {
        [arrayData addObject:[self dicFromObjectPro:data]];
    }
    if(arrayData == nil || [arrayData count] == 0)
    {
        NSLog(@"无效的arraydata 数组");
        return -1;
    }
    
    NSMutableString *header = [NSMutableString string];
     NSMutableArray *keys = [NSMutableArray array];
    if ([arrayData count] > 0)
    {
        NSDictionary *dicData = [arrayData firstObject];
        for (int i = 0; i < [dicData.allKeys count]; i++)
        {
            if (i == [dicData.allKeys count] - 1)
            {
                [header appendFormat:@"%@\n", [dicData.allKeys objectAtIndex:i]];
                [keys addObject:[dicData.allKeys objectAtIndex:i]];
            }
            else
            {
                [header appendFormat:@"%@\t", [dicData.allKeys objectAtIndex:i]];
                [keys addObject:[dicData.allKeys objectAtIndex:i]];
            }
        }
    }
    
    const uint8_t *headerString = (const uint8_t *)[header cStringUsingEncoding:NSUTF8StringEncoding];
    NSInteger headerLength = [header lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    [output write:headerString maxLength:headerLength];
    
    int crruentCount = 0;
    NSUInteger totalCount = [arrayData count];
    for (NSDictionary *dicData in arrayData)
    {
        NSMutableString *row = [NSMutableString string];
        if(progress){
            if(progress(crruentCount,(int)totalCount) != 0)
            {
                break;
            }
        }
        for (int i = 0; i < [dicData.allValues count]; i++)
        {
            
            if (i == [dicData.allValues count] - 1)
            {
                [row appendFormat:@"%@\n",[dicData objectForKey:[keys objectAtIndex:i]]];
            }
            else
            {
                [row appendFormat:@"%@\t",[dicData objectForKey:[keys objectAtIndex:i]]];
            }
            
        }
        crruentCount++;
        if(progress){
            if(progress(crruentCount,(int)totalCount) != 0)
            {
                break;
            }
        }
        const uint8_t *rowString = (const uint8_t *)[row cStringUsingEncoding:NSUTF8StringEncoding];
        NSInteger rowLength = [row lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        [output write:rowString maxLength:rowLength];
    }
    
    [output close];
    return 0;
}
+ (int)saveToXML:(id)data ToDirectory:(NSString *)directory Progress:(int(^)(int index, int count))progress{
    NSString *outpath = [self createNewFileNameWithDirectory:directory Postfix:@"xml"];
    NSOutputStream *output = [[NSOutputStream alloc] initToFileAtPath:outpath append:YES];
    [output open];
    NSMutableArray *arrayData = [[NSMutableArray alloc] init];
    if([data isKindOfClass:[NSArray class]])
    {
        NSUInteger fileCount = [data count];
        for (int i = 0; i < fileCount; i++)
        {
            
            if(progress){
                if(progress(i,(int)fileCount) != 0){
                    break;
                }
            }
            [arrayData addObject:[self dicFromObjectPro:[data objectAtIndex:i]]];
            if(progress){
                if(progress(i+1,(int)fileCount) != 0){
                    break;
                }
            }
        }
    }
    else
    {
        [arrayData addObject:[self dicFromObjectPro:data]];
    }
    if(arrayData == nil || [arrayData count] == 0)
    {
        NSLog(@"无效的arraydata 数组");
        return -1;
    }
    [arrayData writeToFile:outpath atomically:YES];
    return 0;
}




@end
