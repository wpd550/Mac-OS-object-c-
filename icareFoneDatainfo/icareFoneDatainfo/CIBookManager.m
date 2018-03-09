//
//  CIBookManager.m
//  icareFoneDatainfo
//
//  Created by wudong on 2018/3/9.
//  Copyright © 2018年 wudong. All rights reserved.
//

#import "CIBookManager.h"

@implementation CIBookManager
@synthesize operationQueue = _operationQueue;
@synthesize completionBlock = _completionBlock,fileSizeProgressBlock = _fileSizeProgressBlock,fileCountProgressBlock = _fileCountProgressBlock;
@synthesize allBookDataInfoArray = _allBookDataInfoArray;



- (NSMutableArray<T*>*)getAllBookDataInfos{
    [self.allBookDataInfoArray removeAllObjects];
    
    // 1 从设备拿结构体
    
    // 2 将数据放入array
    
    // 3 释放结构体
    
    return nil;
}


// delete book
- (void)deleteIBookWithBookDataInfoArray:(NSArray <T*>*) iBookDataInfoArray
                      countProgressBlock:(CIBookFileCountProgressBlock)countBlock
                       sizeProgressBlock:(CIBookFileSizeProgressBlock)sizeBlock
                         completionBlock:(CIBookCompletionBlock)completionBlock{
    NSUInteger iBookArrayCount = [iBookDataInfoArray count];
    if(iBookDataInfoArray == nil || iBookArrayCount == 0){
        if(completionBlock){
            completionBlock(0,nil);
        }
        return;
    }
    
    self.fileCountProgressBlock = countBlock;
    self.fileSizeProgressBlock = sizeBlock;
    self.completionBlock = completionBlock;
    
    [self taskDidStart];
    
    NSMutableArray *failedArray = [NSMutableArray array];
    NSMutableArray *successArray = [NSMutableArray array];
    NSMutableArray *operationArray = [NSMutableArray array];
    __block NSInteger succeededCount = 0;
    for (int i = 0; i<iBookArrayCount; i++)
    {
        NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
            // 串行队列执行
            /**** code.... ****/
            
        }];
        [operationArray addObject:blockOperation];
    }
    __weak typeof(self) weakSelf = self;
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.allBookDataInfoArray removeObjectsInArray:successArray];
            
            // 完成后回掉
            //**** code.... ****/
            [weakSelf taskDidEndWithSucceededCount:succeededCount failedArray:failedArray];
        });
    }];
    blockOperation.name = @"AllTaskCompletionOperationBlockName";
    [operationArray addObject:blockOperation];
    [self.operationQueue addOperations:operationArray waitUntilFinished:YES];
    
}

#pragma mark - CallBack
- (void)taskDidStart {
    _currentProgressSize = 0;
    _totalSize = 0;
    _currentFileSize = 0;
}

- (void)taskDidEndWithSucceededCount:(NSInteger)succeededCount failedArray:(NSArray *)failedArray {
    _currentProgressSize = 0;
    _totalSize = 0;
    _currentFileSize = 0;
    
    
    if (self.completionBlock) {
        self.completionBlock(succeededCount, failedArray);
    }
}


















@end
