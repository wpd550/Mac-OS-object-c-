//
//  main.m
//  TestGCDGroup
//
//  Created by wudong on 2018/3/16.
//  Copyright © 2018年 wudong. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        dispatch_queue_t disqueue = dispatch_queue_create("wqewqewqasddasdsafdasfdasfd", DISPATCH_QUEUE_CONCURRENT);
        dispatch_group_t disgroup = dispatch_group_create();
        __block int a=1;
        NSMutableArray *array = [NSMutableArray array];
        dispatch_group_async(disgroup, disqueue, ^{
            a++;
    
            [array addObject:@"123245"];
            NSLog(@"11111111111111-----%d",a);
        });
        dispatch_group_async(disgroup, disqueue, ^{
            a++;
            [array addObject:@"qqqq"];
            NSLog(@"22222222222222-----%d",a);
        });
        dispatch_group_async(disgroup, disqueue, ^{
            a++;
            [array addObject:@"wwww"];
            NSLog(@"3333333333333-----%d",a);
        });
        
        dispatch_group_notify(disgroup, disqueue, ^{
            NSLog(@"123");
            NSLog(@"%@",array);
        });
        
        sleep(5);
    }
    return 0;
}
