//
//  FileUpLoad.h
//  FileUpload
//
//  Created by chenfeng on 14-9-3.
//  Copyright (c) 2014年 chenfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUpLoad : NSOperation
{
    UIImage *theimage;
    NSString *filePath;
    BOOL isImage;
}

@property(nonatomic, retain) NSString *filePath;
@property(nonatomic) BOOL isImage;

- (NSInteger) UpLoading;

@end
