//
//  Foo.h
//  ExportFileToLoad
//
//  Created by wudong on 2018/3/12.
//  Copyright © 2018年 wudong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Moo.h"

@interface Foo : NSObject

@property(nonatomic, assign) int pwd;
@property(nonatomic, strong) NSString *userName;
@property(nonatomic, assign) BOOL isUrl;
@property(nonatomic, strong) Moo *moo;
@property(nonatomic, strong) NSArray *emailList;
@property(nonatomic, strong) NSArray *manyMoo;
@property(nonatomic, strong) NSDictionary *childrenList;
@property(nonatomic, strong) NSDictionary *MooDic;

@end
