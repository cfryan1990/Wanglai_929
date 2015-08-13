//
//  ImageTools.m
//  Wanglai
//
//  Created by Ryan on 14-9-9.
//  Copyright (c) 2014年 com.hdu421. All rights reserved.
//

#import "ImageTools.h"

@implementation ImageTools
//压缩图片
+(UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    　　// Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    　　// Tell the old image to draw in this new context, with the desired
    　　// new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    　　// Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    　　// End the context
    UIGraphicsEndImageContext();
    　　// Return the new image.
    return newImage;
}


@end
