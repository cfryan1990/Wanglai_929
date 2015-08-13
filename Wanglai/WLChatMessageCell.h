//
//  WLChatMessageCell.h
//
//  Created by Reese on 13-8-15.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>
//头像大小
#define HEAD_SIZE 40.0f
#define TEXT_MAX_HEIGHT 500.0f
//间距
#define INSETS 8.0f


enum WLChatMessageCellStyle {
    WLChatMessageCellStyleMe = 0,
    WLChatMessageCellStyleOther = 1
};

@interface WLChatMessageCell : UITableViewCell
{
    UIImageView *_userHead;
    UIImageView *_bubbleBg;
    UIImageView *_headMask;//头像阴影
    UIImageView *_chatImage;
    UILabel *_messageConent;
}
@property (nonatomic) enum WLChatMessageCellStyle msgStyle;
@property (nonatomic) int height;
-(void)setMessageObject:(NSString*)aMessage;
-(void)setHeadImage:(UIImage *)headImage;
//-(void)setMessageObject:(WCMessageObject*)aMessage;
//-(void)setHeadImage:(NSURL*)headImage tag:(int)aTag;
//-(void)setChatImage:(NSURL *)chatImage tag:(int)aTag;
@end
