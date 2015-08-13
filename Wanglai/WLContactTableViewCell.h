//
//  WLContactTableViewCell.h
//  Wanglai
//
//  Created by Ryan on 14-9-2.
//  Copyright (c) 2014年 com.hdu421. All rights reserved.
//

#import <UIKit/UIKit.h>
//头像大小
#define HEAD_SIZE 40.0f
#define TEXT_MAX_HEIGHT 500.0f
//间距
#define INSETS 5.0f

@interface WLContactTableViewCell : UITableViewCell
{
    UIImageView *_userHead;
  //  UIImageView *_bubbleBg;
  //  UIImageView *_chatImage;
    UILabel *_contactName;
}

-(void)setContactName:(NSString*)aMessage;
-(void)setHeadImage:(UIImage *)headImage;
@end
