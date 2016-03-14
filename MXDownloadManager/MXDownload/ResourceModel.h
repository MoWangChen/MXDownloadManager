//
//  ResourceModel.h
//  jy_ai
//
//  Created by 谢鹏翔 on 16/1/12.
//  Copyright © 2016年 coolgo.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResourceModel : NSObject <NSCoding>
// 资源文件名
@property (nonatomic, strong) NSString *fileName;

// 更新时间
@property (nonatomic, strong) NSString *updateDate;

// 对应机型
@property (nonatomic, strong) NSString *produceType;

@end
