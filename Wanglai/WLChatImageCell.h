//
//  WLChatImageCell.h
//  Wanglai
//
//  Created by Ryan on 14-8-27.
//  Copyright (c) 2014年 com.hdu421. All rights reserved.
//

#import <UIKit/UIKit.h>
//头像大小
#define HEAD_SIZE 40.0f
#define TEXT_MAX_HEIGHT 500.0f
//间距
#define INSETS 8.0f

enum WLChatImageCellStyle {
    WLChatImageCellStyleMe = 0,
    WLChatImageCellStyleOther = 1
};


@interface WLChatImageCell : UITableViewCell
{
    UIImageView *_userHead;
    UIImageView *_bubbleBg;
    UIImageView *_headMask;
    UIImageView *_chatImage;
    UILabel *_messageConent;
}

@property (nonatomic) enum WLChatImageCellStyle msgStyle;
@property (nonatomic) int height;
-(void)setMessageObject:(NSString*)aMessage;
-(void)setHeadImage:(UIImage *)headImage;
-(void)setChatImage:(UIImage *)chatImage;

@end
