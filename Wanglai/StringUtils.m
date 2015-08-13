//
//  StringUtils.m
//  Wanglai
//
//  Created by 陈峰 on 14-9-28.
//  Copyright (c) 2014年 com.hdu421. All rights reserved.
//

#import "StringUtils.h"

@implementation StringUtils

+ (NSString *)randomString:(int) stringLength
{
    
    char data[stringLength];
    for (int i = 0; i < stringLength ; i++)
    {
        int a = arc4random_uniform(3);
        if (a == 0) {
            data[i] = ('A' + (arc4random_uniform(26)));
        }
        else if (a == 1)
        {
            data[i] = ('a' + (arc4random_uniform(26)));
        }
        else{
            data[i] = ('0' + (arc4random_uniform(10)));
        }
    }
    
    
    NSString *stringResult = [[NSString alloc] initWithBytes:data length:stringLength encoding:NSUTF8StringEncoding];
    return stringResult;
}


@end
