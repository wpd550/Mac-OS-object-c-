//
//  TGDataSecurityAlgorithms.m
//  TSGeneralClass
//
//  Created by Tenorshare Developer on 2018/2/27.
//  Copyright © 2018年 Tenorshare Developer. All rights reserved.
//

#import "TGDataSecurityAlgorithms.h"
#import "SHAex.h"
#import "md5.h"
#include <stdlib.h>

@implementation TGDataSecurityAlgorithms


// 对一个字符串进行base64编码,并且返回
+ (nullable NSString *)base64EncodeString:(nonnull NSString *)string {
    
    if(!string)
        return nil;
    // 1.先转换为二进制数据
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    // 2.对二进制数据进行base64编码,完成之后返回字符串
    if(data)
        return [data base64EncodedStringWithOptions:0];
    return nil;
}

// 对base64编码之后的字符串解码,并且返回
+ (nullable NSString *)base64DecodeString:(nonnull NSString *)string {
    
    if(!string)
        return nil;
    // 注意:该字符串是base64编码后的字符串
    // 1.转换为二进制数据(完成了解码的过程)
    NSData *data = [[[NSData alloc]initWithBase64EncodedString:string options:0] autorelease];
    
    // 2.把二进制数据在转换为字符串
    if(data)
        return [[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    return nil;
}

+ (nullable NSData *)bitwiseReverse:(NSData *)data{
    if(data == nil){
        return nil;
    }
    NSUInteger length = [data length];
    const char* _cdata = (char*)[data bytes];
    char *result = (char*)malloc(length);
    const char *tmpend = _cdata;
    char *tmphead = result;
    //tmpend =tmpend + length-1;
    for(int i=0;i<length;i++){
        *tmphead = ~(*tmpend);
        tmphead++;
        tmpend++;
    }
    NSData *rdata = [[NSData alloc] initWithBytes:result length:length];
    free(result);
    return [rdata autorelease];
}

//计算字符串的MD5值
+ (NSString *)md5:(NSString *)string{
    if([string length]==0){
        return nil;
    }
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    char* _cString = (char*)[data bytes];
    NSUInteger length = [data length];
    MD5 md5;
    unsigned char chMd5[16] = "";
    md5.init();
    md5.update((unsigned char*)_cString, length);
    md5.final(chMd5);
  
    NSMutableString *output = [NSMutableString stringWithCapacity:32];
    
    for(int i= 0;i<16;i++){
        [output appendFormat:@"%02x",chMd5[i] ];
    }
    return output;
}

//计算文件的MD5值
+ (NSString *)md5WithFile:(NSString *)file{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:file]){
        NSLog(@"文件不存在");
        return nil;
    }
    
    MD5 md5;
    unsigned char chMd5[16] = "";
    md5.init();
    
    FILE *fp = fopen([file UTF8String], "rb");
    
    if(fp ==NULL){
        return nil;
    }
    char *buffer = (char*)malloc(1024);
    memset(buffer, 0, 1024);
    unsigned int sizeLength = fread(buffer, 1, 1024, fp);
    while(sizeLength){
        md5.update((unsigned char*)buffer, sizeLength);
        memset(buffer, 0, 1024);
        sizeLength = fread(buffer, 1, 1024, fp);
    }
    
    fclose(fp);
    free(buffer);
    buffer =NULL;
    md5.final(chMd5);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:32];
    
    for(int i= 0;i<16;i++){
        [output appendFormat:@"%02x",chMd5[i] ];
    }
    return output;
}

//计算字符串的sha1值
+ (NSString *)sha1:(NSString *)string{
    if([string length] ==0){
        return nil;
    }
    const char* _cstring = [string UTF8String];
    CSHA1 sha1;
    sha1.Update((unsigned char*)_cstring, [string length]);
    sha1.Final();
    unsigned char chSha1[20] = "";
    const bool bSuccess = sha1.GetHash(chSha1);
    
    if(bSuccess){
        NSMutableString *output = [NSMutableString stringWithCapacity:40];
        for(int i= 0;i<20;i++){
            [output appendFormat:@"%02x",chSha1[i] ];
        }
        return output;
    }
    return nil;
}

//计算文件的sha1值
+ (NSString *)sha1WithFile:(NSString *)file{
    const char* _cstring = [file UTF8String];
    CSHA1 sha1;
    const bool bSuccess = sha1.HashFile(_cstring);
    sha1.Final();
    unsigned char chSha1[20] = "";

    sha1.GetHash(chSha1);
    if(bSuccess)
    {
        NSMutableString *output = [NSMutableString stringWithCapacity:40];
        for(int i= 0;i<20;i++){
            [output appendFormat:@"%02x",chSha1[i] ];
        }
        return output;
    }
    return nil;
}


@end
