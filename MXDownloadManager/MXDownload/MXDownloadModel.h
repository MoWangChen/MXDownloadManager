//
//  MXDownloadModel.h
//  MXDownloadManager
//
//  Created by 谢鹏翔 on 16/3/17.
//  Copyright © 2016年 谢鹏翔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXDownloadModel : NSObject

/**
 *  任务名称
 */
@property (nonatomic, strong) NSString *taskName;

/**
 *  任务唯一标识
 */
@property (nonatomic, strong) NSString *taskIdentifier;

/**
 *  下载任务url
 */
@property (nonatomic, strong) NSString *urlString;

/**
 *  下载任务进度
 */
@property (nonatomic, assign) float taskProgress;

/**
 *  任务下载速度
 */
@property (nonatomic, strong) NSString *taskSpeed;

/**
 *  任务大小
 */
@property (nonatomic, strong) NSString *taskSize;

/**
 *  任务会话属性
 */
@property (nonatomic, strong) NSURLSession *session;

/**
 *  任务是否已完成
 */
@property (nonatomic, assign) BOOL isFinish;

/**
 *  任务已下载长度
 */
@property (nonatomic, assign) int64_t bytesWritten;

/**
 *  任务总长度
 */
@property (nonatomic, assign) int64_t totalBytesWritten;

/**
 *  任务时间
 */
@property (nonatomic, strong) NSDate *taskDate;

@end
