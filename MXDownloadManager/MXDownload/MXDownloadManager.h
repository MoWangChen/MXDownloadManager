//
//  MXDownloadManager.h
//  MXDownloadManager
//
//  Created by 谢鹏翔 on 16/3/14.
//  Copyright © 2016年 谢鹏翔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXDownloadModel.h"

@interface MXDownloadManager : NSObject

// 任务唯一标识
@property (nonatomic, strong) NSString *taskIdentifier;

/**
 *  资源包任务下载器（单例模式）
 *
 *  @return self
 */
+ (MXDownloadManager *)sharedDataCenter;


/**
 *  添加一个下载任务到任务列表中
 *
 *  @param urlString        下载地址url
 *  @param taskName         任务名称
 *  @param taskIdentifier   任务唯一标识
 *  @param resourceModel    资源属性
 */
- (void)addDownloadTaskToList:(NSString *)urlString taskName:(NSString *)taskName taskIdentifier:(NSString *)taskIdentifier;


/**
 *  查询任务的下载状态
 *
 *  @param taskIdentifier   任务标识符
 *
 *  @return 状态字典信息
 */
- (NSDictionary *)askForTaskStatusWithTaskIdentifier:(NSString *)taskIdentifier;

@end
