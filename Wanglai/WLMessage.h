//
//  WLMessage.h
//  Wanglai
//
//  Created by 陈峰 on 14-9-28.
//  Copyright (c) 2014年 com.hdu421. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"

@interface WLMessage : NSObject

+(NSXMLElement *)messageWitText:(NSString *)messageText WithCurrentMsgCount:(int)count To:(NSString *)toJidString WithMediaType:(NSString *)mediaTypeString;

+(NSXMLElement *)mediaUrl:(NSString *)url mediaSize:(NSString *)size WithCurrentMsgCount:(int)count To:(NSString *)toJidString WithMediaType:(NSString *)mediaTypeString;

@end
