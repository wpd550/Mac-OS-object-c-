//
//  TSBaseViewController.m
//
//  Created by liu on 2018/3/7.
//  Copyright © 2018年 liu. All rights reserved.
//
//  Controller基类，封装了一些通用的方法

#import "TSBaseViewController.h"

@interface TSBaseViewController ()

@end

@implementation TSBaseViewController

#pragma mark - 初始化

- (instancetype)initWithNibName:(NSNibName)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self == nil) {
        return nil;
    }
    
    [self setupDefaults];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    
    if (self == nil) {
        return nil;
    }
    
    [self setupDefaults];
    
    return self;
}

- (instancetype)initFromController {
    return [self initFromControllerNibWithBundle:nil];
}

- (instancetype)initFromControllerNibWithBundle:(NSBundle *)nibBundle {
    return [self initWithNibName:NSStringFromClass([self class]) bundle:nibBundle];
}

#pragma mark - 生命周期

- (void)loadView {
    [super loadView];
    
    if (floor(NSAppKitVersionNumber) < NSAppKitVersionNumber10_10) {
        [self setupUI];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - 公共方法

- (void)setupDefaults {
    
}

- (void)setupUI {
    
}

- (void)setRightMouseMenu:(NSMenu *(^)(NSInteger))menuBlock {
    
}

- (NSString *)longlongToTimeString:(long long)time {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    NSLocale *formatterLocal = [[NSLocale alloc] initWithLocaleIdentifier:@"en_us"];
    [formatter setLocale:formatterLocal];
    if (time/1000.0 < 60 * 60)
        [formatter setDateFormat:@"00:mm:ss"];
    else
        [formatter setDateFormat:@"HH:mm:ss"];
    
    NSDate *dateTime = [[NSDate alloc] initWithTimeIntervalSince1970:time/1000.0];
    NSString *dateString = [formatter stringFromDate:dateTime];
    NSString *formatTime = [NSString stringWithString:dateString];
    
    return formatTime;
}

- (void)showLoadingWindow:(BOOL)isShow withLoadingMessage:(NSString *)message {
    if (isShow) {
        
    } else {
        
    }
}

- (NSArray<NSURL *> *)importFile:(BOOL)isChooseDirectories allowedFileTypes:(NSArray<NSString *> *)allowedTypes prompt:(NSString *)prompt {
    // 默认目录桌面
    NSString *directoryURL = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, NO).firstObject;
    
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.allowsMultipleSelection = YES;
    openPanel.canChooseFiles = !isChooseDirectories;
    openPanel.canChooseDirectories = isChooseDirectories;
    openPanel.allowedFileTypes = allowedTypes;
    openPanel.directoryURL = [NSURL URLWithString:directoryURL];
    openPanel.prompt = prompt;
    
    if ([openPanel runModal] != NSModalResponseOK) {
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *importFileURLs = [NSMutableArray array];
    if (isChooseDirectories) { // 拿目录下的文件
        for (NSURL *url in openPanel.URLs) {
            NSArray <NSURL *>*subURLs = [fileManager contentsOfDirectoryAtURL:url includingPropertiesForKeys:nil options:0 error:nil];
            
            for (NSURL *url in subURLs) {
                BOOL isDirectory = NO;
                [fileManager fileExistsAtPath:url.path isDirectory:&isDirectory];
                
                if (!isDirectory) {
                    NSString *pathExtension = url.path.pathExtension;
                    if ([openPanel.allowedFileTypes containsObject:[pathExtension lowercaseString]]) {
                        [importFileURLs addObject:url];
                    }
                }
            }
        }
    } else {
        [importFileURLs addObjectsFromArray:openPanel.URLs];
    }
    
    return importFileURLs;
}

- (NSURL *)exportFileToLocalWithPrompt:(NSString *)prompt {
    // 默认目录桌面
    NSString *directoryURL = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, NO).firstObject;
    
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.allowsMultipleSelection = NO;
    openPanel.canChooseFiles = NO;
    openPanel.canChooseDirectories = YES;
    openPanel.directoryURL = [NSURL URLWithString:directoryURL];
    openPanel.prompt = prompt;
    
    if ([openPanel runModal] != NSModalResponseOK) {
        return nil;
    }
    
    return openPanel.URL;
}

@end
