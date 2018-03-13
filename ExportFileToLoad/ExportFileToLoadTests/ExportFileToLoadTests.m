//
//  ExportFileToLoadTests.m
//  ExportFileToLoadTests
//
//  Created by wudong on 2018/3/12.
//  Copyright © 2018年 wudong. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Foo.h"
#import "Moo.h"
#import "ExportContent.h"

@interface ExportFileToLoadTests : XCTestCase

@end

@implementation ExportFileToLoadTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.

    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    Foo *foo = [[Foo alloc] init];
    foo.userName = @"gaoyuqiang";
    foo.userName = nil;
    foo.pwd = 1234;
    foo.isUrl = YES;
    foo.emailList = @[@"sfa@234.com", @"2@34.com"];
    
    Moo *moo = [[Moo alloc] init];
    moo.name = @"moo";
    moo.pwd = @"234";
    moo.profile = @"mooooo";
    
    foo.moo = moo;
    
    Moo *moo1 = [[Moo alloc] init];
    moo1.name = @"moo1";
    moo1.pwd = @"23124";
    moo1.profile = @"m11111ooo";
    
    Moo *moo2 = [[Moo alloc] init];
    moo2.name = @"moo2";
    moo2.pwd = @"2134";
    moo2.profile = @"moobbbbooo";
    
    foo.manyMoo = @[moo1, moo2];
    foo.childrenList = @{@"name":@"gao", @"pwd":@"32424"};
    foo.MooDic = @{@"1" : @{@"s1" : moo1, @"s2" : moo2, @"s3" : @[@"1", @"2"]}, @"2" : moo2};
    
    NSArray *array = [NSArray arrayWithObjects:moo,moo2,moo1, nil];
    

    [ExportContent saveToCSV:array ToDirectory:@"/Users/wudong/Desktop/dic" Progress:nil];
    [ExportContent saveToExcel:array ToDirectory:@"/Users/wudong/Desktop/dic" Progress:nil];
    [ExportContent saveToCSV:array ToDirectory:@"/Users/wudong/Desktop/dic" Progress:^int(int index, int count) {
        NSLog(@"完成 %d / %d",index,count);
//        if(index == 2){
//            return -1;
//        }
        return 0;
    }];
    [ExportContent saveToXML:array ToDirectory:@"/Users/wudong/Desktop/dic" Progress:^int(int index, int count) {
        NSLog(@"完成 %d / %d",index,count);
        //        if(index == 2){
        //            return -1;
        //        }
        return 0;
    }];

    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
