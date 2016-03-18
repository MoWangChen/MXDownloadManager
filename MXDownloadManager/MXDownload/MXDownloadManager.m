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
- (void)addDownloadTaskToList:(NSString *)urlString taskName:(NSString *)taskName taskIdentifier:(NSString *)taskIdentifier
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
    for (MXDownloadModel *model in self.taskList) {
        if ([urlString isEqualToString:model.urlString]) {
            
            return;
        }
    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request];
    
    MXDownloadModel *model = [[MXDownloadModel alloc] init];
    model.taskName = taskName;
    model.taskIdentifier = taskIdentifier;
    model.urlString = urlString;
    model.taskProgress = 0.0f;
    model.session = session;
    model.isFinish = NO;
    model.bytesWritten = 0;
    model.totalBytesWritten = 0;
    model.taskDate = [NSDate date];
    model.taskSpeed = @"0kb/s";
    model.taskSize = @"0M";
    
    [self.taskList addObject:model];
    
    [task resume];
    
    self.backgroundIdentify = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        
        //当时间快结束时，该方法会被调用。
        NSLog(@"Background handler called. Not running background tasks anymore.");
        
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundIdentify];
        
        self.backgroundIdentify = UIBackgroundTaskInvalid;
    }];
}


// 查询任务的工作状态
- (MXDownloadModel *)askForTaskStatusWithTaskIdentifier:(NSString *)taskIdentifier
{
    for (MXDownloadModel *model in self.taskList) {
        if ([model.taskIdentifier isEqualToString:taskIdentifier]  ) {
            
            return model;
        }
    }
    return nil;
}


#pragma mark --- 实现监控下载进度的方法
//整个文件下载"完毕"的调用方法
//location: 整个文件下载后存放位置 (沙盒)
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSLog(@"线程:%@; 位置:%@", [NSThread currentThread], location);
    
    MXDownloadModel *currentTask = nil;
    
    for (MXDownloadModel *model in self.taskList) {
        
        if (model.session == session) {
            
            currentTask = model;
        }
        
        NSLog(@"task:%@  -- %f",model.taskName,model.taskProgress);
    }
    
    //将默认tmp目录下的文件移动到/Libary/Caches/
    NSString *cachesStr = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *filePath = [cachesStr stringByAppendingPathComponent:currentTask.taskName];
    
    NSError *moveError = nil;
    
    [[NSFileManager defaultManager] moveItemAtPath:location.path toPath:filePath error:&moveError];
    
    if (moveError) {
        NSLog(@"移动文件失败:%@", moveError.userInfo);
    }
    
    currentTask.taskSpeed = @"0kb/s";
    currentTask.isFinish = YES;
}



//调用多次；只要服务器返回数据就会调用该方法
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    //计算进度
    float progressNum = (double)totalBytesWritten / totalBytesExpectedToWrite;
    
    NSString *progress = [NSString stringWithFormat:@"%.1f%%", progressNum*100];
    
    for (MXDownloadModel *model in self.taskList) {
        if (model.session == session) {
            model.taskProgress = progressNum;
            model.totalBytesWritten = totalBytesExpectedToWrite;
            model.taskSize = [self formatByteCount:totalBytesExpectedToWrite];
            NSDate *currentDate = [NSDate date];
            if ([currentDate timeIntervalSinceDate:model.taskDate] > 0.5) {
                NSTimeInterval time = [currentDate timeIntervalSinceDate:model.taskDate];
                int64_t speed = (totalBytesWritten - model.bytesWritten) / time*1000;
                model.taskSpeed = [NSString stringWithFormat:@"%@/s",[self formatByteCount:speed]];
                
                
                model.bytesWritten = totalBytesWritten;
            }
            
            
            NSLog(@"task:%@  -- %@ , %@",model.taskName,progress,model.taskSpeed);
        }
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

- (NSString*)formatByteCount:(long long)size
{
    return [NSByteCountFormatter stringFromByteCount:size countStyle:NSByteCountFormatterCountStyleFile];
}

@end
