//
//  MessageViewController.h
//  Wanglai
//
//  Created by Ryan on 14-8-7.
//  Copyright (c) 2014年 com.hdu421. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPAppDelegate.h"

@interface MessageViewController : UITableViewController
{
    int newMessageCount;
    NSArray *contacts;//新消息界面用户JID
    NSMutableDictionary *newMsgDictionary;//用户JID和消息的对应
}

@end
