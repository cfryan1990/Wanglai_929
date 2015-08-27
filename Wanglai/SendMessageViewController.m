//
//  WCSendMessageController.m
//  微信
//
//  Created by Reese on 13-8-11.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import "SendMessageViewController.h"
#import "XMPPAppDelegate.h"
#import "XMPPMessage.h"
#import "WLChatMessageCell.h"
#import "WLChatImageCell.h"

#import "WLMessageObject.h"

#import "ChatVoiceRecorderVC.h"

#import "LCVoice.h"
#import "FileUpLoad.h"
#import "ImageTools.h"
#import "StringUtils.h"

#import "WLMessage.h"

@interface SendMessageViewController ()

@property(nonatomic,retain) LCVoice * voice;
@end

@implementation SendMessageViewController
@synthesize xmppUserObject;
@synthesize msgRecordsArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isOnline = NO;
        currentMsgCount = 0;
        //初始化消息数组
        self.msgRecordsArray = [[NSMutableArray alloc]init];
    //创建录音文件夹
        NSString *imageDir = [NSString stringWithFormat:@"%@/Documents/records/", NSHomeDirectory()];
        BOOL isDir = NO;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
        if ( !(isDir == YES && existed == YES) )
        {
            [fileManager createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, [[UIScreen mainScreen]bounds].size.height);

    if ([self xmppStream].isAuthenticated) {
        isOnline = YES;
        NSLog(@"在线，获取数据！");
        //在title上显示聊天人名字
        self.navigationItem.title = xmppUserObject.displayName;
        self.toJID = self.xmppUserObject.jid;
        self.toJIDString = self.xmppUserObject.jidStr;
        [self getMessageData];
    }
    else{
         NSLog(@"未登录，读取本地数据！");
        self.navigationItem.title = [[self.toJIDString componentsSeparatedByString:@"@"] objectAtIndex:0];
        [self getMessageDataFromLocal];
       
    }

    messageText.returnKeyType = UIReturnKeySend;
    
    _shareMoreView =[[ChatSelectionView alloc]init];
    [_shareMoreView setFrame:CGRectMake(0, 0, 310, 216)];
  //  [_shareMoreView setBackgroundColor:[UIColor whiteColor]];
    [_shareMoreView setDelegate:self];

    switchBtn.showsTouchWhenHighlighted = YES;
    shareMore.showsTouchWhenHighlighted = YES;
    
    self.voice = [[LCVoice alloc] init];
    
    
    recordBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    recordBtn.frame = CGRectMake(35, 7, 205, 30);
    recordBtn.backgroundColor = [UIColor lightGrayColor];
    [recordBtn setTitle:@"按住  说话" forState:UIControlStateNormal];
    [recordBtn setTitle:@"松开  结束" forState:UIControlStateHighlighted];
    [recordBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [recordBtn setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [inputBar addSubview:recordBtn];
//    [recordBtn addTarget:self action:@selector(recordStart:) forControlEvents:UIControlEventTouchDown];
//    [recordBtn addTarget:self action:@selector(recordStop:) forControlEvents:UIControlEventTouchUpInside];
//    [recordBtn addTarget:self action:@selector(recordCancel:) forControlEvents:UIControlEventTouchUpOutside];
    
    [recordBtn addTarget:self action:@selector(recordStart) forControlEvents:UIControlEventTouchDown];
    [recordBtn addTarget:self action:@selector(recordEnd) forControlEvents:UIControlEventTouchUpInside];
    [recordBtn addTarget:self action:@selector(recordCancel) forControlEvents:UIControlEventTouchUpOutside];
  
    
    recordBtn.selected = NO;
    recordBtn.hidden = YES;
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newMsgCome:) name:@"xmppNewMsgNotifaction" object:nil];

    
    [msgRecordTable setBackgroundColor:[UIColor whiteColor]];
    [msgRecordTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    //触摸tableview关闭键盘
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [msgRecordTable addGestureRecognizer:tap];
    
    
    //一个监听键盘高度改变的通知事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
   
    //tableview下方不要被输入框挡住
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, [[UIScreen mainScreen]bounds].size.height - 60);
    }completion:^(BOOL finished){
    }];
 //   滚动到最后一个
    if (self.msgRecordsArray.count > 1) {
        [msgRecordTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.msgRecordsArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    [msgRecordTable reloadData];
 
}


-(void)refresh
{
    //数据库操作
  //  msgRecords =[WCMessageObject fetchMessageListWithUser:_chatPerson.userId byPage:1];
    //有新数据来会自动滚到最后一行数据
    if (msgRecordsArray.count!=0) {
     
        [msgRecordTable reloadData];
        NSLog(@"reloaddata");
        [msgRecordTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:msgRecordsArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ---触摸关闭键盘----
-(void)handleTap:(UIGestureRecognizer *)gesture
{
    [UIView animateWithDuration:0.2 animations:^{
        //调整整个view时注意tableview上面的navigationbar的位置，会遮挡tableview
        self.view.frame = CGRectMake(0, 64, self.view.frame.size.width, [[UIScreen mainScreen]bounds].size.height - 64);
    }completion:^(BOOL finished){}];
    NSLog(@"touched");
    [messageText resignFirstResponder];
  //  [self.view endEditing:YES];
}


#pragma mark - 监听键盘高度改变事件
- (void)keyboardWillShow:(NSNotification *)notification {
    //无候选词的时候的键盘高度
    static CGFloat normalKeyboardHeight = 216.0f;
    //获取传过来的对象
    NSDictionary *info = [notification userInfo];
    //获取有候选词的时候的键盘高度
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    //求差值：高度36px
    CGFloat distanceToMove = kbSize.height - normalKeyboardHeight;
    
    //一定要判断，不然在拼音和英文之间切换的时候会有高度上移的bug。
    if (distanceToMove == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, [[UIScreen mainScreen]bounds].size.height-216);
        }completion:^(BOOL finished){
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-distanceToMove);
        }completion:^(BOOL finished){
        }];
    }
    //键盘升起时，tableview滑倒最后一项数据
    if (self.msgRecordsArray.count > 1) {
        [msgRecordTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.msgRecordsArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}


#pragma mark - my method
- (XMPPAppDelegate *)appDelegate
{
    return (XMPPAppDelegate *)[[UIApplication sharedApplication] delegate];
}

//取得当前的XMPPStream
- (XMPPStream *)xmppStream{
    
    return [[self appDelegate] xmppStream];
}

//查询coredata封装下的消息数据库，在线情况下用
- (void)getMessageData{
    NSManagedObjectContext *context = [[self appDelegate].xmppMessageArchivingCoreDataStorage mainThreadManagedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject" inManagedObjectContext:context];
    
    //创建聊天双方ID的查询条件
    NSPredicate *predicate;
	if ([XMPPJID jidWithString:[[NSUserDefaults standardUserDefaults] stringForKey:XMPPmyJID]])
	{
		predicate = [NSPredicate predicateWithFormat:@"bareJidStr == %@ AND streamBareJidStr == %@",
                     self.toJID, [XMPPJID jidWithString:[[NSUserDefaults standardUserDefaults] stringForKey:XMPPmyJID]]];
	}
	else
	{
		predicate = [NSPredicate predicateWithFormat:@"bareJidStr == %@", self.toJID];
	}
    //设置查询条件
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    [request setPredicate:predicate];
    NSError *error ;
    NSArray *messages = [context executeFetchRequest:request error:&error];
    [self.msgRecordsArray removeAllObjects];
    [self.msgRecordsArray addObjectsFromArray:messages];
}

//查询本地数据库获取消息，查询条件为当前聊天对象的JIDString
- (void)getMessageDataFromLocal{
    [self.msgRecordsArray removeAllObjects];
    [self.msgRecordsArray addObjectsFromArray:[WLMessageObject fetchMessageListWithUser:self.toJIDString]];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //去除cell间隔线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

[self.msgRecordsArray count];
    return [self.msgRecordsArray count];
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
//    
//    if (cell == nil)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
//    cell.backgroundColor = [UIColor clearColor];
//    cell.textLabel.font = [UIFont systemFontOfSize:20];
//    // Configure the cell...
//    XMPPMessageArchiving_Message_CoreDataObject *object = [self.dataArray objectAtIndex:indexPath.row];
//    NSMutableString *showString = [[NSMutableString alloc] init];
//    
////    if (object.bareJidStr) {
////        [showString appendFormat:@"bareJidStr:%@\n",object.bareJidStr];
////    }
//    if (object.body) {
//        if ([object.body hasPrefix:@"base64"]) {
//            [showString appendFormat:@"语音文件"];
//        //    NSData *audioData = [[object.body substringFromIndex:6] base64DecodedData];
//        }else{
//            [showString appendFormat:@"%@\n",object.body];
//        }
//    }
////    if (object.isOutgoing) {
////        [showString appendFormat:@"isOutgoing\n"];
////    }else{
////        [showString appendFormat:@"no out going \n"];
////    }
////    if (object.timestamp) {
////        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
////        [formatter setDateStyle:NSDateFormatterShortStyle];
////        [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
////        [showString appendFormat:@"timestamp:%@\n",[formatter stringFromDate:object.timestamp]];
////    }
//    UILabel * aLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 0, 0)];
//    aLabel.backgroundColor = [UIColor clearColor];
//   
//    //根据showString自动改变label的height
//    //定义字体
//    UIFont *font = [UIFont fontWithName:@"Arial" size:12.0];
//    //设置一个行高上限
//    CGSize size = CGSizeMake(200,2000);
//    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
//    //计算实际frame大小，并将label的frame变成实际大小
//    CGSize labelsize =[showString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
//    [aLabel setFrame:CGRectMake(70, 0, 200, labelsize.height)];
//    
//    
//    aLabel.text = showString;
//    aLabel.font = font;
//    //最大显示几行，取0就是不限行数
//    aLabel.numberOfLines = 0;
//    //设置如何断行，可根据文字或者字符断行
//    aLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    
////    //最大显示几行，取0就是不限行数
////    cell.textLabel.numberOfLines = 0;
////    //设置如何断行，可根据文字或者字符断行
////    cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
////
////   
////    NSLog(@"showString = %@",showString);
////    cell.textLabel.text = showString;
//    [cell.contentView addSubview:aLabel];
//    cell.imageView.image = [UIImage imageNamed:@"defaultPerson"];
//    
//    cell.accessoryType = UITableViewCellAccessoryNone;//没有右箭头，默认会有
//    return cell;
//}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //定义不同类型的cell标识符
    static NSString * identifierMessage = @"ChatMessageCell";
    static NSString * identifierImage = @"ChatImageCell";
    static NSString * identifierAudio = @"ChatAudioCell";
    static NSString * identifierFile = @"ChatFileCell";
    static NSString * identifierLocation = @"ChatLocationCell";
    
    WLChatMessageCell * cellMessage = [tableView dequeueReusableCellWithIdentifier:identifierMessage];
    if (!cellMessage) {
        cellMessage=[[WLChatMessageCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifierMessage];
    }
    WLChatImageCell * cellImage = [tableView dequeueReusableCellWithIdentifier:identifierImage];
    if (!cellImage) {
        cellImage=[[WLChatImageCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifierImage];
    }
    
    if (!isOnline) {
        WLMessageObject *msg = [self.msgRecordsArray objectAtIndex:indexPath.row];
        NSMutableString *showString = [[NSMutableString alloc] init];
        [showString appendFormat:@"%@\n",msg.messageContent];
  //      NSLog(@"toJIDString = %@",self.toJIDString);
        NSLog(@"msgto = %@",msg.messageTo);
       
        if([msg.messageTo isEqualToString:self.toJIDString])
        {
            NSLog(@"ok");
            if (msg.messageContent) {
                if ([msg.messageType isEqualToNumber:[NSNumber numberWithInt:WLMessageTypeImage]])
                {
                    [showString appendFormat:@"图片"];
                    //     NSData *audioData = [[object.body substringFromIndex:6] base64DecodedData];
                    [cellImage setChatImage:[UIImage imageNamed:@"defaultPerson"]];
                    [cellImage setHeadImage:[UIImage imageNamed:@"defaultPerson"]];
                    [cellImage setMsgStyle:WLChatImageCellStyleMe];
                    return cellImage;
                }else
                {
                    [cellMessage setMessageObject:showString];
                    [cellMessage setHeadImage:[UIImage imageNamed:@"defaultPerson"]];
                    //    [cell setHeadImage:[UIImage imageNamed:@"defaultPerson"]];
                    [cellMessage setMsgStyle:WLChatMessageCellStyleMe];
                    return cellMessage;
                }
            }

        }
        else
        {
            if (msg.messageContent) {
                if ([msg.messageType isEqualToNumber:[NSNumber numberWithInt:WLMessageTypeImage]])
                {
                    [showString appendFormat:@"图片文件"];
                    //     NSData *audioData = [[object.body substringFromIndex:6] base64DecodedData];
                    [cellImage setChatImage:[UIImage imageNamed:@"defaultPerson"]];
                    [cellImage setHeadImage:[UIImage imageNamed:@"defaultPerson"]];
                    [cellImage setMsgStyle:WLChatImageCellStyleOther];
                    return cellImage;
                }else
                {
                    [cellMessage setMessageObject:showString];
                    [cellMessage setHeadImage:[self getVcardFromUser:xmppUserObject]];
                    [cellMessage setMsgStyle:WLChatMessageCellStyleOther];
                    return cellMessage;
                }
            }
        }

    }
    
    else{
        XMPPMessageArchiving_Message_CoreDataObject *object = [self.msgRecordsArray objectAtIndex:indexPath.row];
        NSMutableString *showString = [[NSMutableString alloc] init];
        [showString appendFormat:@"%@\n",object.body];
        NSLog(@"mydate = %@",object.timestamp);
        
        //获取自己的头像
        NSData *photoData = [[[self appDelegate] xmppvCardAvatarModule] photoDataForJID:[XMPPJID jidWithString:[[NSUserDefaults standardUserDefaults] stringForKey:XMPPmyJID]]];
        
        if(object.isOutgoing)
        {
            if (object.message) {
                if ([object.message.type isEqualToString:@"image"])
                {
                    [showString appendFormat:@"图片"];
                    //     NSData *audioData = [[object.body substringFromIndex:6] base64DecodedData];
                    [cellImage setChatImage:[UIImage imageNamed:@"defaultPerson"]];
                    [cellImage setHeadImage:[UIImage imageWithData:photoData]];
                    [cellImage setMsgStyle:WLChatImageCellStyleMe];
                    return cellImage;
                }else
                {
                    [cellMessage setMessageObject:showString];
                    [cellMessage setHeadImage:[UIImage imageWithData:photoData]];
                    //    [cell setHeadImage:[UIImage imageNamed:@"defaultPerson"]];
                    [cellMessage setMsgStyle:WLChatMessageCellStyleMe];
                    return cellMessage;
                }
            }
            
        }
        else
        {
            if (object.body) {
                if ([object.message.type isEqualToString:@"image"])
                {
                    [showString appendFormat:@"图片文件"];
                    //     NSData *audioData = [[object.body substringFromIndex:6] base64DecodedData];
                    [cellImage setChatImage:[UIImage imageNamed:@"defaultPerson"]];
                    [cellImage setHeadImage:[UIImage imageWithData:photoData]];
                    [cellImage setMsgStyle:WLChatImageCellStyleOther];
                    return cellImage;
                }else
                {
                    [cellMessage setMessageObject:showString];
                    [cellMessage setHeadImage:[self getVcardFromUser:xmppUserObject]];
                    [cellMessage setMsgStyle:WLChatMessageCellStyleOther];
                    return cellMessage;
                }
            }
        }

        
    }
    
    return cellMessage;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isOnline) {
        XMPPMessageArchiving_Message_CoreDataObject * object = [self.msgRecordsArray objectAtIndex:indexPath.row];
        if([object.message.type isEqualToString:@"image"])
            return 40 + 100;
        else{
            
            NSMutableString *showString = [[NSMutableString alloc] init];
            [showString appendFormat:@"%@\n",object.body];
            //根据showString自动改变label的height
            //设置一个行高上限
            CGSize size = CGSizeMake(200,10000);
            NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15], NSFontAttributeName,nil];
            //计算实际frame大小，并将label的frame变成实际大小
            CGSize labelsize =[showString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
            
            return labelsize.height + 40;
        }
    }
    else{
        WLMessageObject *msg = [self.msgRecordsArray objectAtIndex:indexPath.row];
        if ([msg.messageType isEqualToNumber:[NSNumber numberWithInt:WLMessageTypeImage]]) {
            return 40 + 100;
        }
        else{
            NSMutableString *showString = [[NSMutableString alloc] init];
            [showString appendFormat:@"%@\n",msg.messageContent];
            //根据showString自动改变label的height
            //设置一个行高上限
            CGSize size = CGSizeMake(200,10000);
            NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15], NSFontAttributeName,nil];
            //计算实际frame大小，并将label的frame变成实际大小
            CGSize labelsize =[showString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
            
            return labelsize.height + 40;
        }
    }
    
}

- (UIImage *)getVcardFromUser:(XMPPUserCoreDataStorageObject *)user
{
	// Our xmppRosterStorage will cache photos as they arrive from the xmppvCardAvatarModule.
	// We only need to ask the avatar module for a photo, if the roster doesn't have it.
	
	if (user.photo != nil)
	{
		return user.photo;
	}
	else
	{
		NSData *photoData = [[[self appDelegate] xmppvCardAvatarModule] photoDataForJID:user.jid];
        
		if (photoData != nil)
			return [UIImage imageWithData:photoData];
		else
			return [UIImage imageNamed:@"defaultPerson"];
	}
}

#pragma mark  接受新消息广播
-(void)newMsgCome:(NSNotification *)notifacation
{
    //[WCMessageObject save:notifacation.object];
 
    [self getMessageData];
    [self refresh];
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
//        XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:self.toJID];
//      [message addBody:textField.text];
//        XMPPMessage *message = [XMPPMessage messageWithType:@"image" to:self.toJID];
//        [message addBody:textField.text];
//     [[[self appDelegate] xmppStream] sendElement:message];
    
    
    
//    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
//    [body setStringValue:textField.text];
//    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
//    [message addAttributeWithName:@"type" stringValue:@"chat"];
//    [message addAttributeWithName:@"to" stringValue:self.xmppUserObject.jidStr];
//    [message addChild:body];
//    [[[self appDelegate] xmppStream] sendElement:message];
    
    NSXMLElement *message = [WLMessage messageWitText:textField.text WithCurrentMsgCount:currentMsgCount To:self.xmppUserObject.jidStr WithMediaType:@"Normal"];
    
    
//    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
//    [body setStringValue:textField.text];
//    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
//    [message addAttributeWithName:@"id" stringValue:[NSString stringWithFormat:@"%@-%d",[StringUtils randomString:5], currentMsgCount]];
//    [message addAttributeWithName:@"to" stringValue:self.xmppUserObject.jidStr];
//    [message addAttributeWithName:@"frome" stringValue:[[NSUserDefaults standardUserDefaults] stringForKey:XMPPmyJID]];
//    [message addChild:body];
//    NSXMLElement *request = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:recepipts"];
//    [message addChild:request];
//    NSXMLElement *properties = [NSXMLElement elementWithName:@"properties" xmlns:@"http://www.jivesoftware.com/xmlns/xmpp/properties"];
//    NSXMLElement *property = [NSXMLElement elementWithName:@"property"];
//    NSXMLElement *name = [NSXMLElement elementWithName:@"name" stringValue:@"mediaType"];
//    NSXMLElement *value = [NSXMLElement elementWithName:@"value"];
//    [value addAttributeWithName:@"type" stringValue:@"string"];
//    [value setStringValue:@"Normal"];
//    [property addChild:name];
//    [property addChild:value];
//    [properties addChild:property];
//    [message addChild:properties];
    
    
    
    //发送消息
    [[[self appDelegate] xmppStream] sendElement:message];
    
    WLMessageObject *msg = [[WLMessageObject alloc]init];
    [msg setMessageContent:textField.text];
    [msg setMessageFrom:[[NSUserDefaults standardUserDefaults] stringForKey:XMPPmyJID]];
    [msg setMessageTo:self.xmppUserObject.jidStr];
    [msg setMessageType:[NSNumber numberWithInt:0]];
    [msg setMessageDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    
    if ([WLMessageObject save:msg]) {
        NSLog(@"message storage success");
    //    NSLog(@"%@,  %@,  %@",msg.messageFrom,msg.messageTo,msg.messageContent);
    }
    else{
        NSLog(@"message storage failure");
    }
    
    [self getMessageData];
    [self refresh];
    [textField setText:nil];
    currentMsgCount ++;

    return YES;
}

- (IBAction)shareMore:(id)sender {
    
    [messageText setInputView:messageText.inputView?nil: _shareMoreView];
  
    [messageText reloadInputViews];
    [messageText becomeFirstResponder];
    
}

#pragma mark sharemore按钮组协议
#pragma mark 从库中获取图片

-(void)pickPhotoFromAlbum
{
    
    UIImagePickerController *imgPicker=[[UIImagePickerController alloc]init];
    [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imgPicker setDelegate:self];
    [imgPicker setAllowsEditing:NO];
    
    [self presentViewController:imgPicker animated:YES completion:^{
    }];
    
}

#pragma mark 从摄像头获取活动图片
- (void)pickImageFromCamera
{
    UIImagePickerController *camPicker = [[UIImagePickerController alloc]init];
    [camPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [camPicker setDelegate:self];
    [camPicker setAllowsEditing:NO];
    [camPicker setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:camPicker animated:YES completion:^{
        
    }];
}


#pragma mark ----------图片选择完成-------------
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage  * chosedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
//    {
//        NSLog(@"camera!!!!!!");
        UIImage *theImage = [ImageTools imageWithImageSimple:chosedImage scaledToSize:CGSizeMake(120.0, 120.0)];
        UIImage *midImage = [ImageTools imageWithImageSimple:chosedImage scaledToSize:CGSizeMake(210.0, 210.0)];
        UIImage *bigImage = [ImageTools imageWithImageSimple:chosedImage scaledToSize:CGSizeMake(440.0, 440.0)];
    
        NSString *path = [self saveImage:theImage WithName:@"salesImageSmall.jpg"];
        NSLog(@"path = %@",path);
        [self saveImage:midImage WithName:@"salesImageMid.jpg"];
        [self saveImage:bigImage WithName:@"salesImageBig.jpg"];
        [self dismissViewControllerAnimated:YES completion:nil];
        
        //GCD异步发送
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            FileUpLoad *imageFile = [[FileUpLoad alloc]init];
            imageFile.isImage = YES;
            imageFile.filePath = path;
            NSInteger status = [imageFile UpLoading];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == 0) {
                    NSLog(@"image upload SUCCESS!");
                    
                    
                }
                else{
                    NSLog(@"image upload FAILURE!");
                }
            });
        });

     //   UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
//    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        //
        
   //     [self sendImage:chosedImage];
        [msgRecordsArray addObject:chosedImage];
        
                
        [self refresh];
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
}

#pragma mark 保存图片到document
-(NSString* )saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
    return fullPathToFile;
}
#pragma mark 从文档目录下获取Documents路径
-(NSString *)documentFolderPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}



//    　　theImage = [UtilMethod imageWithImageSimple:image scaledToSize:CGSizeMake(120.0, 120.0)];
//    　　UIImage *midImage = [UtilMethod imageWithImageSimple:image scaledToSize:CGSizeMake(210.0, 210.0)];
//    　　UIImage *bigImage = [UtilMethod imageWithImageSimple:image scaledToSize:CGSizeMake(440.0, 440.0)];
//    　　[theImage retain];
//    　　[self saveImage:theImage WithName:@"salesImageSmall.jpg"];
//    　　[self saveImage:midImage WithName:@"salesImageMid.jpg"];
//    　　[self saveImage:bigImage WithName:@"salesImageBig.jpg"];
//    　　[self dismissModalViewControllerAnimated:YES];
//    　　[self refreshData];
//    　　[picker release];



- (UIColor *) stringTOColor:(NSString *)str
{
    if (!str || [str isEqualToString:@""]) {
        return nil;
    }
    unsigned red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 1;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&red];
    range.location = 3;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&green];
    range.location = 5;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&blue];
    UIColor *color= [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
    return color;
}


- (IBAction)switchBtn:(id)sender
{
    if (messageText.hidden) {
        [messageText setHidden:NO];
        recordBtn.hidden = YES;
        
    }
    else{
    [messageText setHidden:YES];
        recordBtn.hidden = NO;
    }
}

-(void)recordStart
{
    NSLog(@"开始录音");
    //计算时间用于命名录音文件
    long time = [[NSDate date] timeIntervalSince1970];
//    NSLog(@"190timeInterval:%ld",time);
    tempRecordFileWavName = [NSString stringWithFormat:@"%@_TO_%@%ld.wav",[[NSUserDefaults standardUserDefaults] stringForKey:XMPPmyJID], self.toJIDString, time];
 //   [[NSUserDefaults standardUserDefaults] stringForKey:XMPPmyJID]
    [self.voice startRecordWithPath:[NSString stringWithFormat:@"%@/Documents/records/%@", NSHomeDirectory(), tempRecordFileWavName]];
}

-(void)recordEnd
{

    [self.voice stopRecord];
        
//        if (self.voice.recordTime > 0.0f) {
//            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"\nrecord finish ! \npath:%@ \nduration:%f",self.voice.recordPath,self.voice.recordTime] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//            [alert show];
            //GCD异步发送
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //WAV 转 AMR
                tempRecordFileAmrPath = [VoiceConverter wavToAmr:[NSString stringWithFormat:@"%@/Documents/records/%@", NSHomeDirectory(), tempRecordFileWavName]];
           
                NSLog(@"amrPath = %@",tempRecordFileAmrPath);

                FileUpLoad *soundFile = [[FileUpLoad alloc]init];
                soundFile.isImage = NO;
                soundFile.filePath = tempRecordFileAmrPath;
                NSInteger status = [soundFile UpLoading];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (status == 0) {
                        NSLog(@"Sound Upload SUCCESS!");
                        
                        NSXMLElement *message = [WLMessage mediaUrl:[NSString stringWithFormat:@"http://192.168.1.100:8080/AndroidUploadFileWeb/Files/%@",tempRecordFileAmrPath] mediaSize:@"1" WithCurrentMsgCount:currentMsgCount To:self.xmppUserObject.jidStr WithMediaType:@"Audio"];
                        
                        //发送消息
                        [[[self appDelegate] xmppStream] sendElement:message];

            
                    }
                    else{
                        NSLog(@"Sound Upload FAILURE!");
                    }
                });
            });

    
   
    NSLog(@"结束录音");
}

-(void)recordCancel
{
    [self.voice cancelled];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"取消录音" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alert show];
  
    
}


-(void)sendImage
{
    
}



@end
