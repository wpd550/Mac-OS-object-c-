//
//  TGDataSecurityAlgorithms.h
//  TSGeneralClass
//
//  Created by Tenorshare Developer on 2018/2/27.
//  Copyright © 2018年 Tenorshare Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface TGDataSecurityAlgorithms : NSObject

//Base64加解码
+ (nullable NSString *)base64EncodeString:(nonnull NSString *)string;
+ (nullable NSString *)base64DecodeString:(nonnull NSString *)string;

//按位取反函数
+ (nullable NSData *)bitwiseReverse:(NSData *)data;

//计算字符串的MD5值
+ (NSString *)md5:(NSString *)string;

//计算文件的MD5值
+ (NSString *)md5WithFile:(NSString *)file;

//计算字符串的sha1值
+ (NSString *)sha1:(NSString *)string;

//计算文件的sha1值
+ (NSString *)sha1WithFile:(NSString *)file;

@end
NS_ASSUME_NONNULL_END
