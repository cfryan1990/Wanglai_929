//
//  ContactViewController.m
//  Wanglai
//
//  Created by Ryan on 14-8-7.
//  Copyright (c) 2014年 com.hdu421. All rights reserved.
//

#import "ContactViewController.h"
#import "LoginViewController.h"
#import "SendMessageViewController.h"

#import "WLContactTableViewCell.h"

#import "XMPPAppDelegate.h"

#import "XMPPFramework.h"
#import "DDLog.h"

#import "ChineseString.h"

#import "WLUserObject.h"

//#import "NSData+Base64.h"

// Log levels: off, error, warn, info, verbose
#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif


@interface ContactViewController ()

@end

@implementation ContactViewController
@synthesize dataArray;
@synthesize contactArray;
@synthesize indexArray;
@synthesize letterResultArr;
@synthesize contactToVcardDictionary;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isOnLine = NO;
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"通讯录";
    
    dataArray = [[NSMutableArray alloc]init];
    contactArray = [[NSMutableArray alloc]init];
    contactToVcardDictionary = [NSMutableDictionary dictionary];
    

    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    if ([self xmppStream].isAuthenticated) {
        NSLog(@"在线！");
        isOnLine = YES;
        [self getContact];
    }
    else
    {
        NSLog(@"不在线！");
        [self getDBFromLoacl];
    }
    
    [self.tableView reloadData];
}

-(NSArray*) getContactFromDB{
    return [[self fetchedResultsController] sections];
}

- (void)getContact
{
    NSIndexPath * contactSortIndexPath = nil;
    //联系人获取及排序，索引
    NSArray *sections = [self getContactFromDB];
    id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:0];
    [dataArray removeAllObjects];
    [dataArray addObjectsFromArray:[sectionInfo objects]];
    NSLog(@"sectioninfo count = %d",[dataArray count]);
    
    if ([dataArray count] != 0)
    {
        [contactArray removeAllObjects];
        NSInteger maxRow = [dataArray count];
        for (int i = 0; i < maxRow; i ++) {
            contactSortIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            XMPPUserCoreDataStorageObject *user = [[self fetchedResultsController]  objectAtIndexPath:contactSortIndexPath];
            NSLog(@"something = %@",user.displayName);
            [contactArray addObject:user.displayName];
            [contactToVcardDictionary setObject:[NSString stringWithFormat:@"%d",i] forKey:user.displayName];
            WLUserObject *newUser = [[WLUserObject alloc]init];
            newUser.userId = user.jidStr;
            newUser.userNickname = user.nickname;
            
            
//            NSData *data = UIImageJPEGRepresentation(user.photo, 1);
//            NSLog(@"原NSString转为data:%@", data);
//            
//            NSString *encodingStr = [data base64Encoding];
//            NSLog(@"Base64编码:%@", encodingStr);
//            
//            newUser.userHead = encodingStr;
            newUser.friendFlag = [NSNumber numberWithInt:1];
            //先检查本地数据库中是否已经存储该联系人
            if (![WLUserObject haveSaveUserById:newUser.userId]) {
                if ([WLUserObject saveNewUser:newUser]) {
                    NSLog(@"需要存储！");
                }
            }
            else{
                NSLog(@"已存储过！");
            }
            
        }
        self.indexArray = [ChineseString IndexArray:contactArray];
        self.letterResultArr = [ChineseString LetterSortArray:contactArray];
        NSLog(@"index count = %d",[indexArray count]);
    }
}

//取得当前程序的委托
-(XMPPAppDelegate *)appDelegate{
    
    return (XMPPAppDelegate *)[[UIApplication sharedApplication] delegate];
}

//取得当前的XMPPStream
-(XMPPStream *)xmppStream{
    
    return [[self appDelegate] xmppStream];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark NSFetchedResultsController
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSFetchedResultsController *)fetchedResultsController
{
	if (fetchedResultsController == nil)
	{
		NSManagedObjectContext *moc = [[self appDelegate] managedObjectContext_roster];
		
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject"
		                                          inManagedObjectContext:moc];
		
		NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"sectionNum" ascending:YES];
		NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"displayName" ascending:YES];
		
		NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, sd2, nil];
		
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		[fetchRequest setEntity:entity];
		[fetchRequest setSortDescriptors:sortDescriptors];
		[fetchRequest setFetchBatchSize:10];
		
		fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
		                                                               managedObjectContext:moc
		                                                                 sectionNameKeyPath:nil
		                                                                          cacheName:nil];
		[fetchedResultsController setDelegate:self];
        NSError *error = nil;
		if (![fetchedResultsController performFetch:&error])
		{
			DDLogError(@"Error performing fetch: %@", error);
		}
	}

	return fetchedResultsController;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self getContact];
	[[self tableView] reloadData];
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


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UITableView
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -Section的Header的值
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *key = [indexArray objectAtIndex:section];
    NSLog(@"key = %@",key);
    return key;
    
}
#pragma mark - Section header view
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];//仅仅只是添加一个lab，无法改变高度等
    lab.backgroundColor = [UIColor colorWithRed:(240/255.0) green:(240/255.0) blue:(240/255.0) alpha:1];
    
    lab.text = [NSString stringWithFormat:@"  %@",[indexArray objectAtIndex:section]];
    lab.textColor = [UIColor grayColor];
    return lab;
}

#pragma mark - Section header height
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 17.0f;
}

#pragma mark - row height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}


#pragma mark Table View Data Source Methods
#pragma mark -设置右方表格的索引数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    
    return contactIndexTitles;
}
#pragma mark - 响应点击索引时的委托方法
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSLog(@"title===%@",title);
    return index;
}

#pragma mark -允许数据源告知必须加载到Table View中的表的Section数。
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [indexArray count];
}
#pragma mark -设置表格的行数为数组的元素个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.letterResultArr objectAtIndex:section] count];
}

#pragma mark -每一行的内容为数组相应索引的值
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ContactCell";
    
    WLContactTableViewCell *contactCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (contactCell == nil)
    {
        contactCell = [[WLContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        contactCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSLog(@"section = %d",indexPath.section);
    NSLog(@"row = %d",indexPath.row);
    NSLog(@"name = %@",[[self.letterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]);
    //当前cell里的用户名
    NSString *name = [[self.letterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    //通过用户名在contactToVcardDictionary中找到对应序列
    NSString *num = [contactToVcardDictionary objectForKey:name];
    
    if (isOnLine) {
        //生成indexPath
        NSIndexPath * sortIndexPath = [NSIndexPath indexPathForRow:[num intValue] inSection:0];
        XMPPUserCoreDataStorageObject * user = [[self fetchedResultsController] objectAtIndexPath:sortIndexPath];
        [contactCell setHeadImage:[self configurePhotoForCell:user]];
    }
    else{
        [contactCell setHeadImage:[UIImage imageNamed:@"defaultPerson"]];
    }
    
    
    [contactCell setContactName:[[self.letterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    
    return contactCell;
}

#pragma mark - Select内容为数组相应索引的值
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"---->%@",[[self.letterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]);
//    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                    message:[[self.letterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]
//                                                   delegate:nil
//                                          cancelButtonTitle:@"YES" otherButtonTitles:nil];
//    [alert show];
    
    
    //向聊天界面传递XMPPUserCoreDataStorageObject对象
    //当前cell里的用户名
    NSString *name = [[self.letterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    //通过用户名在contactToVcardDictionary中找到对应序列
    NSString *num = [contactToVcardDictionary objectForKey:name];

    SendMessageViewController * sendMessageVC = [[SendMessageViewController alloc] init];
    if (isOnLine) {
        //生成indexPath
        NSIndexPath * sortIndexPath = [NSIndexPath indexPathForRow:[num intValue] inSection:0];
        XMPPUserCoreDataStorageObject * user = [[self fetchedResultsController] objectAtIndexPath:sortIndexPath];
        sendMessageVC.xmppUserObject = user;
    }
    else{
        sendMessageVC.toJIDString = [NSString stringWithFormat:@"%@@ryan-pc",name];
    }
    
   
    //系统方法隐藏tabbar，注意要在pushViewController之前隐藏，之后要及时把tabbar恢复
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sendMessageVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UITableViewCell helpers
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (UIImage *)configurePhotoForCell:(XMPPUserCoreDataStorageObject *)user
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


//离线时，本地读取sqlite文件
-(void)getDBFromLoacl
{

    [contactArray removeAllObjects];
    [contactArray addObjectsFromArray:[WLUserObject fetchAllFriendsNameFromLocal]];
    
    
    
    self.indexArray = [ChineseString IndexArray:contactArray];
    self.letterResultArr = [ChineseString LetterSortArray:contactArray];
    NSLog(@"index count ooo= %d",[indexArray count]);

    
}

//NSIndexPath * contactSortIndexPath = nil;
////联系人获取及排序，索引
//NSArray *sections = [self getContactFromDB];
//id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:0];
//[dataArray removeAllObjects];
//[dataArray addObjectsFromArray:[sectionInfo objects]];
//NSLog(@"sectioninfo count = %d",[dataArray count]);
//
//if ([dataArray count] != 0)
//{
//    [contactArray removeAllObjects];
//    NSInteger maxRow = [dataArray count];
//    for (int i = 0; i < maxRow; i ++) {
//        contactSortIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
//        XMPPUserCoreDataStorageObject *user = [[self fetchedResultsController]  objectAtIndexPath:contactSortIndexPath];
//        NSLog(@"something = %@",user.displayName);
//        [contactArray addObject:user.displayName];
//        [contactToVcardDictionary setObject:[NSString stringWithFormat:@"%d",i] forKey:user.displayName];
//    }
//    self.indexArray = [ChineseString IndexArray:contactArray];
//    self.letterResultArr = [ChineseString LetterSortArray:contactArray];
//    NSLog(@"index count = %d",[indexArray count]);
//}


@end
