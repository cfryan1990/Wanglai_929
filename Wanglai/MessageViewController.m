//
//  MessageViewController.m
//  Wanglai
//
//  Created by Ryan on 14-8-7.
//  Copyright (c) 2014年 com.hdu421. All rights reserved.
//

#import "MessageViewController.h"
#import "LoginViewController.h"
#import "SendMessageViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        newMessageCount = 0;
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    newMsgDictionary = [[NSMutableDictionary alloc] init];
    contacts = [[NSArray alloc] init];
  //  self.view.backgroundColor = [UIColor redColor];
    self.navigationItem.title = @"新消息";
    NSString *login = [[NSUserDefaults standardUserDefaults] objectForKey:XMPPmyJID];
    XMPPMessage * msgNotifactionType;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newMsgCome:) name:@"xmppNewMsgNotifaction" object:msgNotifactionType];
    
    NSLog(@"login = %@",login);

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//取得当前程序的委托
-(XMPPAppDelegate *)appDelegate{
    
    return (XMPPAppDelegate *)[[UIApplication sharedApplication] delegate];
}

//取得当前的XMPPStream
-(XMPPStream *)xmppStream{
    
    return [[self appDelegate] xmppStream];
}

- (void)setBadgeValue:(NSString *)newValue
{
    if (newValue!=0) {
        self.tabBarItem.badgeValue = newValue;
    }
}

#pragma mark  接受新消息广播
-(void)newMsgCome:(NSNotification *)notifacation
{
    newMessageCount ++;
    [self setBadgeValue:[NSString stringWithFormat:@"%d",newMessageCount]];
    XMPPMessage *msg = notifacation.object;
    NSLog(@"toStr = %@",msg.fromStr);
    [newMsgDictionary setObject:msg forKey:msg.fromStr];
    
    
    //获取新消息界面用户的JID
    contacts = [newMsgDictionary allKeys];
    for (int i =0; i < contacts.count; i++) {
        NSLog(@"newMsgContacts = %@",[contacts objectAtIndex:i]);
    }
    [self.tableView reloadData];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return contacts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierNewMsg = @"newMsgItems";
    UITableViewCell *newMsgcell = [tableView dequeueReusableCellWithIdentifier:identifierNewMsg];
    if (newMsgcell == nil)
    {
        newMsgcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifierNewMsg];
        newMsgcell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSString *newMsgName = [contacts objectAtIndex:indexPath.row];
    
    
    NSData *photoData = [[[self appDelegate] xmppvCardAvatarModule] photoDataForJID:[XMPPJID jidWithString:newMsgName]];
    
    if (photoData != nil)
        newMsgcell.imageView.image = [UIImage imageWithData:photoData];
    else
        newMsgcell.imageView.image = [UIImage imageNamed:@"defaultPerson"];
    
    newMsgcell.textLabel.font = [UIFont systemFontOfSize:18];
    newMsgcell.textLabel.text = newMsgName;
    
    
    XMPPMessage *msgCell = [newMsgDictionary objectForKey:newMsgName];
    newMsgcell.detailTextLabel.font = [UIFont systemFontOfSize:18];
    newMsgcell.detailTextLabel.textColor = [UIColor grayColor];
    newMsgcell.detailTextLabel.text = [NSString stringWithFormat:@"%@",msgCell.body];
    newMsgcell.accessoryType = UITableViewCellAccessoryNone;
    
    return newMsgcell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *newMsgJidString = [contacts objectAtIndex:indexPath.row];
    NSLog(@"name = %@",newMsgJidString);
    
    SendMessageViewController *sendMessageVC = [[SendMessageViewController alloc]init];
    
    //根据jid来获得XMPPUserCoreDataStorageObject
    NSManagedObjectContext *moc = [[self appDelegate] managedObjectContext_roster];
    XMPPUserCoreDataStorageObject *newMsgUserObject = [[self appDelegate].xmppRosterStorage userForJID:[XMPPJID jidWithString:newMsgJidString] xmppStream:[self xmppStream] managedObjectContext:moc];
    
    sendMessageVC.xmppUserObject = newMsgUserObject;
    
    //系统方法隐藏tabbar，注意要在pushViewController之前隐藏，之后要及时把tabbar恢复
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sendMessageVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
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



@end
