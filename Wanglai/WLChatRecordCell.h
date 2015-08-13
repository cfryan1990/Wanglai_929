//
//  WLChatRecordCell.h
//  Wanglai
//
//  Created by Ryan on 14-9-1.
//  Copyright (c) 2014年 com.hdu421. All rights reserved.
//

#import <UIKit/UIKit.h>
//头像大小
#define HEAD_SIZE 40.0f
#define TEXT_MAX_HEIGHT 500.0f
//间距
#define INSETS 8.0f

enum WLChatRecordCellStyle {
    WLChatRecordCellStyleMe = 0,
    WLChatRecordCellStyleOther = 1
};

@interface WLChatRecordCell : UITableViewCell
{
    UIImageView *_userHead;
    UIImageView *_bubbleBg;
    UIImageView *_headMask;//头像阴影
    UIImageView *_chatImage;
    UILabel *_messageConent;
}

@property (nonatomic) enum WLChatRecordCellStyle msgStyle;
@property (nonatomic) int height;
-(void)setMessageObject:(NSString*)aMessage;
-(void)setHeadImage:(UIImage *)headImage;

@end
