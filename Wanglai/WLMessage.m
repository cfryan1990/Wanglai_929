//
//  WLMessage.m
//  Wanglai
//
//  Created by 陈峰 on 14-9-28.
//  Copyright (c) 2014年 com.hdu421. All rights reserved.
//

#import "WLMessage.h"
#import "StringUtils.h"

@implementation WLMessage


+(NSXMLElement *)messageWitText:(NSString *)messageText WithCurrentMsgCount:(int)count To:(NSString *)toJidString WithMediaType:(NSString *)mediaTypeString
{
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:messageText];
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"id" stringValue:[NSString stringWithFormat:@"%@-%d",[StringUtils randomString:5], count]];
    [message addAttributeWithName:@"to" stringValue:toJidString];
 //   [message addAttributeWithName:@"from" stringValue:[[NSUserDefaults standardUserDefaults] stringForKey:XMPPmyJID]];
    [message addChild:body];
    NSXMLElement *request = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:recepipts"];
    [message addChild:request];
    NSXMLElement *properties = [NSXMLElement elementWithName:@"properties" xmlns:@"http://www.jivesoftware.com/xmlns/xmpp/properties"];
    NSXMLElement *property = [NSXMLElement elementWithName:@"property"];
    NSXMLElement *name = [NSXMLElement elementWithName:@"name" stringValue:@"mediaType"];
    NSXMLElement *value = [NSXMLElement elementWithName:@"value"];
    [value addAttributeWithName:@"type" stringValue:@"string"];
    [value setStringValue:mediaTypeString];
    [property addChild:name];
    [property addChild:value];
    [properties addChild:property];
    [message addChild:properties];
    
    return message;

}

+(NSXMLElement *)mediaUrl:(NSString *)url mediaSize:(NSString *)size WithCurrentMsgCount:(int)count To:(NSString *)toJidString WithMediaType:(NSString *)mediaTypeString
{
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"id" stringValue:[NSString stringWithFormat:@"%@-%d",[StringUtils randomString:5], count]];
    [message addAttributeWithName:@"to" stringValue:toJidString];
 //   [message addAttributeWithName:@"from" stringValue:[[NSUserDefaults standardUserDefaults] stringForKey:XMPPmyJID]];
   
    NSXMLElement *request = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:recepipts"];
    [message addChild:request];
    NSXMLElement *properties = [NSXMLElement elementWithName:@"properties" xmlns:@"http://www.jivesoftware.com/xmlns/xmpp/properties"];
    //mediaUrl封装
    NSXMLElement *propertyMediaUrl = [NSXMLElement elementWithName:@"property"];
    NSXMLElement *nameMediaUrl = [NSXMLElement elementWithName:@"name" stringValue:@"mediaUrl"];
    NSXMLElement *valueMediaUrl = [NSXMLElement elementWithName:@"value"];
    [valueMediaUrl addAttributeWithName:@"type" stringValue:@"string"];
    [valueMediaUrl setStringValue:url];
    [propertyMediaUrl addChild:nameMediaUrl];
    [propertyMediaUrl addChild:valueMediaUrl];
    //mediaSize封装
    NSXMLElement *propertyMediaSize = [NSXMLElement elementWithName:@"property"];
    NSXMLElement *nameMediaSize = [NSXMLElement elementWithName:@"name" stringValue:@"mediaSize"];
    NSXMLElement *valueMediaSize = [NSXMLElement elementWithName:@"value"];
    [valueMediaSize addAttributeWithName:@"type" stringValue:@"string"];
    [valueMediaSize setStringValue:size];
    [propertyMediaSize addChild:nameMediaSize];
    [propertyMediaSize addChild:valueMediaSize];
    //mediaType封装
    NSXMLElement *propertyMediaType = [NSXMLElement elementWithName:@"property"];
    NSXMLElement *nameMediaType = [NSXMLElement elementWithName:@"name" stringValue:@"mediaType"];
    NSXMLElement *valueMediaType = [NSXMLElement elementWithName:@"value"];
    [valueMediaType addAttributeWithName:@"type" stringValue:@"string"];
    [valueMediaType setStringValue:mediaTypeString];
    [propertyMediaType addChild:nameMediaType];
    [propertyMediaType addChild:valueMediaType];
    
    [properties addChild:propertyMediaUrl];
    [properties addChild:propertyMediaSize];
    [properties addChild:propertyMediaType];
    [message addChild:properties];
    
    return message;
}



@end
