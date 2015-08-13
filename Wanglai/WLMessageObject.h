//
//  WLMessageObject.h
//
//  Created by Reese on 13-8-11.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kMESSAGE_TYPE @"messageType"
#define kMESSAGE_FROM @"messageFrom"
#define kMESSAGE_TO @"messageTo"
#define kMESSAGE_CONTENT @"messageContent"
#define kMESSAGE_DATE @"messageDate"
#define kMESSAGE_ID @"messageId"

enum WLMessageType {
     WLMessageTypePlain = 0,
     WLMessageTypeImage = 1,
     WLMessageTypeVoice =2,
     WLMessageTypeLocation=3
};

enum WLMessageCellStyle {
     WLMessageCellStyleMe = 0,
     WLMessageCellStyleOther = 1,
     WLMessageCellStyleMeWithImage=2,
     WLMessageCellStyleOtherWithImage=3
};


@interface WLMessageObject : NSObject
@property (nonatomic,retain) NSString *messageFrom;
@property (nonatomic,retain) NSString *messageTo;
@property (nonatomic,retain) NSString *messageContent;
@property (nonatomic,retain) NSDate   *messageDate;
@property (nonatomic,retain) NSNumber *messageType;
@property (nonatomic,retain) NSNumber *messageId;

+(WLMessageObject *)messageWithType:(int)aType;

//将对象转换为字典
-(NSDictionary*)toDictionary;
+(WLMessageObject*)messageFromDictionary:(NSDictionary*)aDic;

//数据库增删改查
+(BOOL)save:(WLMessageObject*)aMessage;
+(BOOL)deleteMessageById:(NSNumber*)aMessageId;
+(BOOL)merge:(WLMessageObject*)aMessage;

//获取某联系人聊天记录
+(NSMutableArray *)fetchMessageListWithUser:(NSString *)userId;

//获取最近联系人
+(NSMutableArray *)fetchRecentChatByPage:(int)pageIndex;


@end
