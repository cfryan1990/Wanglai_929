//
//  WCUserObject.h
//  微信
//
//  Created by Reese on 13-8-11.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kUSER_ID @"userId"
#define kUSER_NICKNAME @"nickName"
#define kUSER_DESCRIPTION @"description"
#define kUSER_USERHEAD @"userHead"
#define kUSER_FRIEND_FLAG @"friendFlag"


@interface WLUserObject : NSObject
@property (nonatomic,retain) NSString* userId;
@property (nonatomic,retain) NSString* userNickname;
@property (nonatomic,retain) NSString* userDescription;
@property (nonatomic,retain) NSString* userHead;
@property (nonatomic,retain) NSNumber* friendFlag;


//数据库增删改查
+(BOOL)saveNewUser:(WLUserObject*)aUser;
+(BOOL)deleteUserById:(NSNumber*)userId;
+(BOOL)updateUser:(WLUserObject*)newUser;
+(BOOL)haveSaveUserById:(NSString*)userId;

+(NSMutableArray*)fetchAllFriendsFromLocal;
+(NSMutableArray*)fetchAllFriendsNameFromLocal;

//将对象转换为字典
-(NSDictionary*)toDictionary;
+(WLUserObject*)userFromDictionary:(NSDictionary*)aDic;
@end
