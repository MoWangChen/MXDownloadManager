//
//  MXDownloadManager.m
//  MXDownloadManager
//
//  Created by 谢鹏翔 on 16/3/14.
//  Copyright © 2016年 谢鹏翔. All rights reserved.
//

#import "MXDownloadManager.h"
#import <UIKit/UIKit.h>

@interface MXDownloadManager ()<NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSMutableArray *taskList;         // 任务列表

@property (nonatomic) UIBackgroundTaskIdentifier backgroundIdentify;

@end

@implementation MXDownloadManager

static MXDownloadManager *_dataCenter = nil;
+ (MXDownloadManager *)sharedDataCenter {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dataCenter = [[MXDownloadManager alloc] init];
        
    });
    
    return _dataCenter;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundIdentify = UIBackgroundTaskInvalid;
        
        self.taskList = [NSMutableArray array];
        
    }
    return self;
}



#pragma mark - 添加 查询任务
// 添加任务到任务列表中
- (void)addDownloadTaskToList:(NSString *)urlString taskName:(NSString *)taskName taskProductType:(NSNumber *)productType resourceModel:(ResourceModel *)resourceModel
{
    if (!taskName) {
        return;
    }
    
    NSURLRequest *request = nil;
    
    if (urlString) {
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    }
    else
    {
        return;
    }
    
    // 防止任务重复添加
    for (NSDictionary *dict in self.taskList) {
        if ([urlString isEqualToString:dict[@"url"]]) {
            
            return;
        }
    }
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request];
    
    NSDictionary *dic = @{@"taskName":taskName,
                          @"productType":productType,
                          @"url":urlString,
                          @"taskProgress":@"0%%",
                          @"session":session,
                          @"resourceModel":resourceModel,
                          @"isFinish":@0};
    
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    [self.taskList addObject:mutableDic];
    
    [task resume];
    
    self.backgroundIdentify = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        
        //当时间快结束时，该方法会被调用。
        NSLog(@"Background handler called. Not running background tasks anymore.");
        
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundIdentify];
        
        self.backgroundIdentify = UIBackgroundTaskInvalid;
    }];
}


// 查询任务的工作状态
- (NSDictionary *)askForTaskStatusWithProductType:(NSNumber *)productType
{
    for (NSMutableDictionary *dict in self.taskList) {
        if ([dict[@"productType"] intValue] == [productType intValue]) {
            
            return [dict copy];
        }
    }
    return nil;
}


#pragma mark --- 实现监控下载进度的方法
//整个文件下载"完毕"的调用方法
//location: 整个文件下载后存放位置 (沙盒)
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSLog(@"线程:%@; 位置:%@", [NSThread currentThread], location);
    
    NSMutableDictionary *currentTask = nil;
    
    for (NSMutableDictionary *dict in self.taskList) {
        
        if (dict[@"session"] == session) {
            
            currentTask = dict;
        }
        
        NSLog(@"task:%@  -- %@",dict[@"taskName"],dict[@"taskProgress"]);
    }
    
    //将默认tmp目录下的文件移动到/Libary/Caches/
    NSString *cachesStr = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *filePath = [cachesStr stringByAppendingPathComponent:currentTask[@"taskName"]];
    
    NSError *moveError = nil;
    
    [[NSFileManager defaultManager] moveItemAtPath:location.path toPath:filePath error:&moveError];
    
    if (moveError) {
        NSLog(@"移动文件失败:%@", moveError.userInfo);
    }

    
    NSData *fileProData = [NSKeyedArchiver archivedDataWithRootObject:currentTask[@"resourceModel"]];
    
    NSString *keyOfResource = [NSString stringWithFormat:@"downloadResource_%@",currentTask[@"productType"]];
    
    [[NSUserDefaults standardUserDefaults] setObject:fileProData forKey:keyOfResource];
    
    [currentTask setObject:@1 forKey:@"isFinish"];
}



//调用多次；只要服务器返回数据就会调用该方法
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    //计算进度
    double progressNum = (double)totalBytesWritten / totalBytesExpectedToWrite;
    
    NSString *progress = [NSString stringWithFormat:@"%.1f%%", progressNum*100];
    
    
    for (NSMutableDictionary *dict in self.taskList) {
        if (dict[@"session"] == session) {
            [dict setObject:progress forKey:@"taskProgress"];
        }
        
        NSLog(@"task:%@  -- %@",dict[@"taskName"],dict[@"taskProgress"]);
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (UIApplication.sharedApplication.applicationState == UIApplicationStateActive)
        {
            
        }
        else
        {
            NSLog(@"App is backgrounded. Next number = %@", progress);
            NSLog(@"Background time remaining = %.1f seconds", [UIApplication sharedApplication].backgroundTimeRemaining);
        }
    });
}


@end
