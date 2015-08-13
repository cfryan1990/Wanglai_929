//
//  ContactViewController.h
//  Wanglai
//
//  Created by Ryan on 14-8-7.
//  Copyright (c) 2014年 com.hdu421. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPAppDelegate.h"

@interface ContactViewController : UITableViewController<NSFetchedResultsControllerDelegate>
{
	NSFetchedResultsController *fetchedResultsController;
    bool isOnLine;
}

//从数据库获取的联系人
@property(nonatomic,retain)NSMutableArray *dataArray;
//未排序联系人
@property(nonatomic,retain)NSMutableArray *contactArray;
//设置索引内容，支持中文索引
@property(nonatomic,retain)NSMutableArray *indexArray;
//设置每个section下的cell内容
@property(nonatomic,retain)NSMutableArray *letterResultArr;
//Vcard和联系人对应关系的字典
@property(nonatomic,retain)NSMutableDictionary *contactToVcardDictionary;




@end
