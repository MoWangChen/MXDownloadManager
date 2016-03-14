//
//  ResourceModel.m
//  jy_ai
//
//  Created by 谢鹏翔 on 16/1/12.
//  Copyright © 2016年 coolgo.huang. All rights reserved.
//

#import "ResourceModel.h"

@implementation ResourceModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.fileName forKey:@"fileName"];
    [aCoder encodeObject:self.updateDate forKey:@"updateDate"];
    [aCoder encodeObject:self.produceType forKey:@"produceType"];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.fileName = [coder decodeObjectForKey:@"name"];
        self.updateDate = [coder decodeObjectForKey:@"updateDate"];
        self.produceType = [coder decodeObjectForKey:@"produceType"];
    }
    return self;
}

@end
