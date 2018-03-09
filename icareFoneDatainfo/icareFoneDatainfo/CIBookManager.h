//
//  CIBookManager.h
//  icareFoneDatainfo
//
//  Created by wudong on 2018/3/9.
//  Copyright © 2018年 wudong. All rights reserved.
//

#import <Foundation/Foundation.h>
#define  T NSData



typedef void(^CIBookCompletionBlock)(NSInteger succeedeCount,NSArray *array);
typedef void(^CIBookFileCountProgressBlock)(NSInteger currentCount,NSInteger totalCount,NSString *bookName);
typedef void(^CIBookFileSizeProgressBlock)(long long currentSize,long long totalSize);

@interface CIBookManager : NSObject{
    long long _currentProgressSize;
    long long _currentFileSize;
    long long _totalSize;
    
    NSMutableArray<T*>* _allBookDataInfoArray;
 
    CIBookCompletionBlock _completionBlock;
    CIBookFileSizeProgressBlock _fileSizeProgressBlock;
    CIBookFileCountProgressBlock _fileCountProgressBlock;
    
    NSOperationQueue *_operationQueue;
}
@property(copy)CIBookCompletionBlock completionBlock;
@property(copy)CIBookFileSizeProgressBlock fileSizeProgressBlock;
@property(copy)CIBookFileCountProgressBlock fileCountProgressBlock;
@property(strong) NSOperationQueue *operationQueue;
@property(strong) NSMutableArray<T*>* allBookDataInfoArray;

- (NSMutableArray<T*>*)getAllBookDataInfos;



@end
