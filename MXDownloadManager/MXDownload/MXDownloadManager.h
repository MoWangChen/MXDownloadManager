//
//  MXDownloadManager.h
//  MXDownloadManager
//
//  Created by 谢鹏翔 on 16/3/14.
//  Copyright © 2016年 谢鹏翔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResourceModel.h"

@interface MXDownloadManager : NSObject

// 选择的机型
@property (nonatomic, strong) NSNumber *selectedProduct;


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
 *  @param productType      任务所属机型
 *  @param resourceModel    资源属性
 */
- (void)addDownloadTaskToList:(NSString *)urlString taskName:(NSString *)taskName taskProductType:(NSNumber *)productType resourceModel:(ResourceModel *)resourceModel;


/**
 *  查询任务的下载状态
 *
 *  @param productType 机器型号
 *
 *  @return 状态字典信息
 */
- (NSDictionary *)askForTaskStatusWithProductType:(NSNumber *)productType;

@end
