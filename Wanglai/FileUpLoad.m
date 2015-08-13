//
//  FileUpLoad.m
//  FileUpload
//
//  Created by chenfeng on 14-9-3.
//  Copyright (c) 2014年 chenfeng. All rights reserved.
//

#import "FileUpLoad.h"

#define NOTIFY_AND_LEAVE(X) {[self cleanup:X]; return;}
#define DATA(X) [X dataUsingEncoding:NSUTF8StringEncoding]

// Posting constants
#define IMAGE_CONTENT @"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\nContent-Type: image/jpeg\r\n\r\n"
#define FILE_CONTENT @"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type: image/jpeg\r\n\r\n"
#define STRING_CONTENT @"Content-Disposition: form-data; name=\"%@\"\r\n\r\n"

//指定了http post请求的编码方式为multipart/form-data（上传文件必须用这个）
#define MULTIPART @"multipart/form-data; boundary=------------0x0x0x0x0x0x0x0x"

#define SUCCESS 0
#define FAILURE 1


@implementation FileUpLoad
@synthesize isImage;
@synthesize filePath;




//创建postdata
- (NSData*)generateFormDataFromPostDictionary:(NSDictionary*)dict
{
    id boundary = @"------------0x0x0x0x0x0x0x0x";
    NSArray* keys = [dict allKeys];
    NSMutableData* result = [NSMutableData data];
    
    for (int i = 0; i < [keys count]; i++)
    {
        id value = [dict valueForKey: [keys objectAtIndex:i]];
        [result appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        if ([value isKindOfClass:[NSData class]])
        {
            // handle image data
            NSString *formstring = [NSString stringWithFormat:FILE_CONTENT, [keys objectAtIndex:i], [filePath lastPathComponent]];
            [result appendData: DATA(formstring)];
            [result appendData:value];
        }
        else
        {
            // all non-image fields assumed to be strings
            NSString *formstring = [NSString stringWithFormat:STRING_CONTENT, [keys objectAtIndex:i]];
            [result appendData: DATA(formstring)];
            [result appendData:DATA(value)];
        }
        
        NSString *formstring = @"\r\n";
        [result appendData:DATA(formstring)];
    }
    
    NSString *formstring =[NSString stringWithFormat:@"--%@--\r\n", boundary];
    [result appendData:DATA(formstring)];
    return result;
    
    
}
//上传图片
- (NSInteger) UpLoading
{
    NSURL *url;
    if (!self.filePath)
    {
        NSLog(@"Please set file before uploading.") ;
    }
    
    
    NSMutableDictionary* post_dict = [[NSMutableDictionary alloc] init];

    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    
    
 //   [post_dict setObject:@"Posted from iPhone" forKey:@"message"];
//    [post_dict setObject:UIImageJPEGRepresentation(self.theImage, 0.75f) forKey:@"media"];
    [post_dict setObject:fileData forKey:@"file"];
    
    NSData *postData = [self generateFormDataFromPostDictionary:post_dict];
 
 //   NSString *REMOTE_HOST = @"http://192.168.1.100:8080";
    NSString *fileUrl = @"http://192.168.1.100:8080/AndroidUploadFileWeb/FileUploadServlet";
    NSString *imgUrl = @"http://192.168.1.100:8080/AndroidUploadImageWeb/ImageUploadServlet";
   
    if (isImage) {
        url = [NSURL URLWithString:imgUrl];
    }
    else
    {
        url = [NSURL URLWithString:fileUrl];
    }
  //  url = [NSURL URLWithString:fileUrl];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    if (!urlRequest) NSLog(@"Error creating the URL Request");
    
    [urlRequest setHTTPMethod: @"POST"];
    [urlRequest setValue:MULTIPART forHTTPHeaderField: @"Content-Type"];
    [urlRequest setHTTPBody:postData];
    [urlRequest setTimeoutInterval:10.0];
    
    //同步请求
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    NSInteger responseCode = 0;
    [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    responseCode = [response statusCode];
    if (responseCode == 200)
    {
        return SUCCESS;
    }
    return FAILURE;
    
    //异步请求，需IOS5
//    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
//    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue
//                    completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
//                        if (error) {
//                                NSLog(@"Httperror:%@%d", error.localizedDescription,error.code);
//                        }else{
//            
//                                NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
//                                NSString *status;
//                                if (responseCode == 200)
//                                {
//                                    
//                                    status = @"success";
//                                }
//                                else{
//                                   status = @"failure";
//                                }
//                            [[NSNotificationCenter defaultCenter]postNotificationName:@"recordsUpLoad" object:status ];
//
//            
//            //                    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            
//                             //   NSLog(@"HttpResponseCode:%d", responseCode);
//                            //    NSLog(@"HttpResponseBody %@",responseString);
//        }
//                    }];
    
    
}






@end
